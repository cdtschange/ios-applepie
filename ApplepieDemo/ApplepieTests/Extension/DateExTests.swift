//
//  DateExTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class DateExTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let date = Date(fromString: "2018-10-10 10:10:10", format: "yyyy-MM-dd HH:mm:ss")
        assert(date != nil)
        
        assert(("2018-10-10 10:10:10".ap.toDate())?.timeIntervalSince1970.ap.toInt == date?.timeIntervalSince1970.ap.toInt)
        assert(date!.ap.toString() == "2018-10-10 10:10:10")
        
        assert(Date(fromString: "abcd") == nil)
    }

}
