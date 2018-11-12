//
//  OperatorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/7.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class OperatorTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDictionaryOperator() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = ["k1": "v1", "k2": "v2"]
        let b = ["k2": "vv2", "k3": "v3"]
        let c = ["k4": "v4"]
        let a1: [String: String]? = a
        let b1: [String: String]? = b
        let c1: [String: String]? = c
        let d1: [String: String]? = nil
        let d2: [String: String]? = nil
        
        assert((a + b) == ["k1": "v1", "k2": "vv2", "k3": "v3"])
        assert((a + c) == ["k1": "v1", "k2": "v2", "k4": "v4"])
        assert((a1 + b1) == ["k1": "v1", "k2": "vv2", "k3": "v3"])
        assert((a1 + c1) == ["k1": "v1", "k2": "v2", "k4": "v4"])
        assert((a + b + c) == ["k1": "v1", "k2": "vv2", "k3": "v3", "k4": "v4"])
        assert((a + d1) == a)
        assert((d1 + b) == b)
        assert((d1 + b) == b)
        assert((d1 + d2) == [:])
        
        var e = a
        e += b
        assert(e == ["k1": "v1", "k2": "vv2", "k3": "v3"])
    }
}
