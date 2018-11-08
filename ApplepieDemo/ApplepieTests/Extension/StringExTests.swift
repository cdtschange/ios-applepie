//
//  StringExTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest

class StringExTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddingPercentEncodingForUrlQueryValue() {
        let str = "+&%$!"
        assert("%2B%26%25%24%21" == str.ap.addingPercentEncodingForUrlQueryValue())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
