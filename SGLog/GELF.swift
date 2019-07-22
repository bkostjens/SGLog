//
//  GELF.swift
//  SGLog
//
//  Created by Barry Kostjens on 17/07/2019.
//  Copyright © 2019 Prosilic. All rights reserved.
//

import Foundation

internal struct GELF {
    
    // GELF spec version – “1.1”; MUST be set by client library.
    var version: String = "1.1"
    
    // the name of the host, source or application that sent this message; MUST be set by client library.
    var host: String = "SGLog"
    
    // a short descriptive message; MUST be set by client library.
    var short_message: String
    
    // a long message that can i.e. contain a backtrace; optional.
    var full_message: String?
    
    // Seconds since UNIX epoch with optional decimal places for milliseconds; SHOULD be set by client library. Will be set to the current timestamp (now) by the server if absent.
    var timestamp: Double = NSDate().timeIntervalSince1970
    
    // the level equal to the standard syslog levels; optional, default is 1 (ALERT).
    var level: Int = ErrorLevel.info.rawValue
    
    /*
        every field you send and prefix with an underscore (_) will be treated as an additional field. Allowed characters in field names are any word character (letter, number, underscore), dashes and dots. The verifying regular expression is: ^[\w\.\-]*$. Libraries SHOULD not allow to send id as additional field (_id). Graylog server nodes omit this field automatically.
    */
    var additionalFields: [AdditionalField]?
    
    init(message:String,
         fullMessage: String? = nil,
         host: String? = nil,
         additionalFields: [AdditionalField]? = nil,
         level: Int? = nil) {
        
        self.short_message = message
        self.full_message = fullMessage
        self.additionalFields = additionalFields
        
        if let host = host {
            self.host = host
        }
        
        if let level = level {
            self.level = level
        }
    }
    
    internal func jsonData() -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch let error {
            print ("\(#file) \(#function) error converting to JSON: \(error)")
            return nil
        }
    }
}

extension GELF : Codable {
    
    enum DecodingError: Error {
        case invalidKey
        case invalidValueType
    }
    
    enum CodingKeys : CodingKey {
        case version
        case host
        case short_message
        case full_message
        case timestamp
        case level
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var intValue: Int?
        var stringValue: String
        
        init?(intValue: Int) { self.intValue = intValue; self.stringValue = "\(intValue)"; return nil }
        init?(stringValue: String) {
            self.stringValue = stringValue
            if (!self.stringValue.hasPrefix("_")) {
                return nil
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.version, forKey: .version)
        try container.encode(self.host, forKey: .host)
        try container.encode(self.short_message, forKey: .short_message)
        try container.encode(self.timestamp, forKey: .timestamp)
        try container.encode(self.level, forKey: .level)
        
        if let full_message = self.full_message {
            try container.encode(full_message, forKey: .full_message)
        }
        
        if let additionalFields = self.additionalFields {
            for additionalField in additionalFields {
                try additionalField.encode(to: encoder)
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.version = try container.decode(String.self, forKey: .version)
        self.host = try container.decode(String.self, forKey: .host)
        self.short_message = try container.decode(String.self, forKey: .short_message)
        self.timestamp = try container.decode(Double.self, forKey: .timestamp)
        self.level = try container.decode(Int.self, forKey: .level)
        self.full_message = try? container.decode(String.self, forKey: .full_message)
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        if (dynamicContainer.allKeys.count == 0) { return }
      
        self.additionalFields = []
        for key in dynamicContainer.allKeys {
            if let v = try? dynamicContainer.decode(String.self, forKey: key) {
                self.additionalFields?.append(AdditionalField(key: key.stringValue, value: v))
            } else if let v = try? dynamicContainer.decode(Bool.self, forKey: key) {
                self.additionalFields?.append(AdditionalField(key: key.stringValue, value: v))
            } else if let v = try? dynamicContainer.decode(Int.self, forKey: key) {
                self.additionalFields?.append(AdditionalField(key: key.stringValue, value: v))
            } else if let v = try? dynamicContainer.decode(Double.self, forKey: key) {
                self.additionalFields?.append(AdditionalField(key: key.stringValue, value: v))
            } else if let v = try? dynamicContainer.decode(Float.self, forKey: key) {
                self.additionalFields?.append(AdditionalField(key: key.stringValue, value: v))
            } else {
                throw DecodingError.invalidValueType
            }
        }
    }
}
