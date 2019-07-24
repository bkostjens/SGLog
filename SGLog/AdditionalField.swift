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
    
    /**
     Additional Field initialiser
     
     - Parameters:
        - key: the key, must be a valid string of regex (^[\w\.\-]*$)
        - value: can be a String, Double, Float, Int or Bool
    */
    public init(key: String, value: Any?) {
        self.key = key.hasPrefix("_") ? key : "_\(key)"
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
            self.stringValue = "\(intValue)"
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
        
        switch self.value {
        case is String:
            try container.encode(self.value as! String, forKey: key)
        case is Double:
            try container.encode(self.value as! Double, forKey: key)
        case is Float:
            try container.encode(self.value as! Float, forKey: key)
        case is Int:
            try container.encode(self.value as! Int, forKey: key)
        case is Bool:
            try container.encode(self.value as! Bool, forKey: key)
        default:
            throw EncodingError.invalidValueType
        }
    }
}
