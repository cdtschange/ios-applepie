//
//  APKeychainTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/7.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class APKeychainTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testKeychain() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let key = "testKeychain"
        let chain = APKeychain(identifier: "com.cdts.applepietest")
        assert(chain.string(forKey: key) == nil)
        chain.set(string: "abc", forKey: key)
        assert(chain.string(forKey: key) == "abc")
        chain.set(string: nil, forKey: key)
        chain.set(string: "abc", forKey: key)
        chain.removeObject(forKey: key)
        assert(chain.string(forKey: key) == nil)
    }

}
