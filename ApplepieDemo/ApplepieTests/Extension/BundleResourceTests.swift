//
//  BundleResourceTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class BundleResourceTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBundle() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let image = Bundle.apImage(named: "ap_arrow_left@2x")
        assert(image != nil)
        assert(Bundle.apImage(named: "abc") == nil)
    }
}
