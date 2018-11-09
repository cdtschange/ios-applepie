//
//  BaseTestCase.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2018/11/9.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest

class BaseTestCase: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func url(forResource fileName: String, withExtension ext: String) -> URL {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.url(forResource: fileName, withExtension: ext)!
    }
}
