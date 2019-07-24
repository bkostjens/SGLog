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
    
    /**
     Sets the server URL
     
     - Parameter url: the url of the graylog GELF HTTP Input
    */
    public static func setURL(_ url: String) {
        self.shared.url = url
        self.shared.server = Server(url: url)
    }
    
    /**
     Sets the hostname
     
     - Parameter host: the hostname that gets send to the graylog GELF HTTP Input
    */
    public static func setHost(_ host: String) {
        self.shared.host = host
    }
    
    /**
     Sends an emergency log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
    */
    public static func emergency(_ message: String,
                          fullMessage: String? = nil,
                          additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.emergency.rawValue)
    }
    
    /**
     Sends an alert log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func alert(_ message: String,
                          fullMessage: String? = nil,
                          additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.alert.rawValue)
    }
    
    /**
     Sends a critical log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func critical(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.critical.rawValue)
    }
    
    /**
     Sends an error log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func error(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.error.rawValue)
    }
    
    /**
     Sends an warning log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func warning(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.warning.rawValue)
    }
    
    /**
     Sends a notice log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func notice(_ message: String,
                      fullMessage: String? = nil,
                      additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.notice.rawValue)
    }
    
    /**
     Sends an info log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func info(_ message: String,
                       fullMessage: String? = nil,
                       additionalFields: [AdditionalField]? = nil) {
        self.shared.log(message, fullMessage: fullMessage, additionalFields: additionalFields, level: ErrorLevel.info.rawValue)
    }
    
    /**
     Sends a debug log to the graylog server
     
     - Parameters:
        - message: the short log message
        - fullMessage: a longer message, providing more details about the short message (optional)
        - additionalFields: an array containing AdditionalField objects (optional)
     */
    public static func debug(_ message: String,
                     fullMessage: String? = nil,
                     additionalFields: [AdditionalField]? = nil) {
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
