//
//  SGLogTests.swift
//  SGLogTests
//
//  Created by Barry Kostjens on 19/07/2019.
//  Copyright © 2019 Prosilic. All rights reserved.
//

import XCTest
@testable import SGLog

class SGLogTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        SGLog.setHost("testHost")
        SGLog.setURL("https://localhost:12345")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGelfEncodingDecoding() {
        let message = "message"
        let fullMessage = "fullMessage"
        let host = "localhost"
        let level = 5
        
        let additionalField1 = AdditionalField(key: "_username", value: "ricky")
        let additionalField2 = AdditionalField(key: "_distance", value: 25.7)
        let additionalField3 = AdditionalField(key: "_incorrect key", value: "not so much")
        
        let additionalFields = [additionalField1, additionalField2, additionalField3]
        
        let gelf = GELF.init(message: message,
                             fullMessage: fullMessage,
                             host: host,
                             additionalFields: additionalFields,
                             level: level)
        
        let encodedGelf = gelf.jsonData()!
        let decodedGelf = try! JSONDecoder().decode(GELF.self, from: encodedGelf)
        
        print("decodedGelf: \(decodedGelf)")
        XCTAssertEqual(decodedGelf.short_message, message, "short_message is wrong")
        XCTAssertEqual(decodedGelf.full_message, fullMessage, "fullMessage is wrong")
        XCTAssertEqual(decodedGelf.host, host, "host is wrong")
        XCTAssertEqual(decodedGelf.level, level, "level is wring")
       
        XCTAssert(decodedGelf.additionalFields != nil, "additional fields are missing")
        XCTAssert(decodedGelf.additionalFields!.contains(where: { $0.key == "_username" && $0.value as? String == "ricky" }),  "Additionalfield with key _username is wrong")
        XCTAssert(decodedGelf.additionalFields!.contains(where: { $0.key == "_distance" && $0.value as? Double == 25.7 }),  "Additionalfield with key _distance is wrong")
        XCTAssert(!decodedGelf.additionalFields!.contains(where: { $0.key == "_incorrect key" }),  "Additionalfield with key _incorrect key should not exist")
    }

    

}
