//
//  NSObjectExTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/13.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class NSObjectExTests: BaseTestCase {
    
    @objc(Foo)
    private class Foo: NSObject {}

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFullClassName() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        assert(NSObject.fullClassName("ViewController")?.description() == "ApplepieDemo.ViewController")
        assert(NSObject.fullClassName("Abc") == nil)
        
        assert(NSObject.fromClassName("ViewController") != nil)
        assert(NSObject.fromClassName("Foo") != nil)
        assert(NSObject.fromClassName("Abc") == nil)
        
 }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
