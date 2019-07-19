//
//  SGLog.swift
//  SGLog
//
//  Created by Barry Kostjens on 17/07/2019.
//  Copyright © 2019 Prosilic. All rights reserved.
//

import Foundation

public class SGLog  {
    
    static let shared = SGLog()
    
    var url: String?
    var host: String?
    var server: Server?
    
    private init() {}
    
    public static func setURL(_ url: String) {
        self.shared.url = url
        self.shared.server = Server(url: url)
    }
    
    public static func setHost(_ host: String) {
        self.shared.host = host
    }
    
    public static func emergency(_ message: String,
                          fullMessage: String? = nil,
                          additionalFields: [AdditionalField]? = nil,
                          host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.emergency.rawValue)
    }
    
    public static func alert(_ message: String,
                          fullMessage: String? = nil,
                          additionalFields: [AdditionalField]? = nil,
                          host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.alert.rawValue)
    }
    
    public static func critical(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil,
                      host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.critical.rawValue)
    }
    
    public static func error(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil,
                      host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.error.rawValue)
    }
    
    public static func warning(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil,
                      host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.warning.rawValue)
    }
    
    public static func notice(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil,
                      host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.notice.rawValue)
    }
    
    public static func info(_ message: String,
                       fullMessage: String? = nil,
                       additionalFields: [AdditionalField]? = nil,
                       host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.info.rawValue)
    }
    
    public static func debug(_ message: String,
                     fullMessage: String? = nil,
                     additionalFields: [AdditionalField]? = nil,
                     host: String? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.debug.rawValue)
    }
    
    private func log(_ message: String,
                    fullMessage: String?,
                    additionalFields: [AdditionalField]? = nil,
                    level: Int?) {
        print(message)
        
        let gelf = GELF.init(message: message,
                             fullMessage: fullMessage,
                             host: self.host,
                             additionalFields: additionalFields,
                             level: level)
        
        self.server?.post(gelf)
    }
}
