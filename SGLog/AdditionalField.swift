//
//  AdditionalField.swift
//  SGLog
//
//  Created by Barry Kostjens on 17/07/2019.
//  Copyright © 2019 Prosilic. All rights reserved.
//

import Foundation

public struct AdditionalField {
    var key : String
    var value : Any?
    
    public init(key: String, value: Any?) {
        self.key = key
        self.value = value
    }
}

extension AdditionalField: Encodable {
    
    enum EncodingError: Error {
        case invalidValueType
    }
    
    private struct CodingKeys : CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = "\(intValue)"
        }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        static func key(named name: String) -> CodingKeys? {
            // Test that the key is a valid string (^[\w\.\-]*$)
            let range = NSRange(location: 0, length: name.utf8.count)
            let regex = try! NSRegularExpression(pattern: "^[\\w\\.\\-]*$")
            return regex.firstMatch(in: name, options: [], range: range) != nil ? CodingKeys(stringValue: name) : nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        //try container.encode(key, forKey: .key)
        guard let key = CodingKeys.key(named: self.key) else {
            return
        }
        
        switch value {
        case is String:
            try container.encode(value as! String, forKey: key)
        case is Double:
            try container.encode(value as! Double, forKey: key)
        case is Int:
            try container.encode(value as! Int, forKey: key)
        default:
            throw EncodingError.invalidValueType
        }
    }
}
