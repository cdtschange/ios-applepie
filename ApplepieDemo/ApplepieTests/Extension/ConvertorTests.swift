//
//  ConvertorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/7.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest

class ConvertorTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvertor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a: Int = 5
        assert(a.ap.toFloat == Float(a))
        assert(a.ap.toDouble == Double(a))
        assert(a.ap.toString == String(a))
        
        let b: Double = 6.0
        assert(b.ap.toFloat == Float(b))
        assert(b.ap.toInt == Int(b))
        assert(b.ap.toString == String(b))
        
        var c: Bool = true
        assert(c.ap.toString == String(c))
        c = false
        assert(c.ap.toString == String(c))
        
        var str: String = "1"
        assert(str.ap.toInt == 1)
        str = "1.0"
        assert(str.ap.toDouble == 1.0)
        assert(str.ap.toFloat == 1.0)
        assert(str.ap.toBool == nil)
        str = "true"
        assert(str.ap.toBool == true)
        str = "false"
        assert(str.ap.toBool == false)
        str = " h e y "
        assert(str.ap.trim() == "h e y")
    }


}
