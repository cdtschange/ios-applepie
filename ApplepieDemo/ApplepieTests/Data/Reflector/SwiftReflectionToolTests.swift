//
//  SwiftReflectionToolTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class SwiftReflectionToolTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    class TestObj: NSObject {
        var name: String?
        var age: Int?
        @objc
        var objName: String = ""
        @objc
        var objInt: Int = 0
        @objc
        var objDouble: Double = 0.0
        @objc
        var objFloat: Float = 0.0
        @objc
        var objDate: Date = Date(timeIntervalSince1970: 0)
    }

    func testReflector() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let obj = TestObj()
        let dict = SwiftReflectionTool.propertyList(obj: obj)
        assert(dict?.count == 5)
        assert(String(describing: dict?.first?["objName"]) == "Optional(NSString)")
        let date = Date()
        SwiftReflectionTool.setParams(
            [
                "objName": "abc",
                "objInt": 1,
                "objDouble": 1.0,
                "objFloat": 2.0,
                "objDate": date
            ]
            , for: obj)
        assert(obj.objName == "abc")
        assert(obj.objInt == 1)
        assert(obj.objDouble == 1.0)
        assert(obj.objFloat == 2.0)
        assert(obj.objDate == date)
        
        SwiftReflectionTool.setParams(["objDate": "2018-10-10 10:10:10"], for: obj)
        let dateValue = Date(fromString: "2018-10-10 10:10:10", format: "yyyy-MM-dd HH:mm:ss")
        assert(obj.objDate == dateValue)
 }

}
