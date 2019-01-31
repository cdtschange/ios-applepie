//
//  UIColorHexTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class UIColorHexTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testColor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let _ = UIColor(hex3: 0xfff)
        let _ = UIColor(hex4: 0xffff)
        let _ = UIColor(hex6: 0xffffff)
        let _ = UIColor(hex8: 0xffffffff)
        let _ = UIColor(rgba: "#FFF")
        let _ = UIColor(rgba: "#FFFF")
        let _ = UIColor(rgba: "#FFFFFF")
        let _ = UIColor(rgba: "#FFFFFFFF")
        let _ = UIColor(rgba: "#FFFFFFFFF")
        
        assert(UIColor.white.hexString(includeAlpha: true) == "#FFFFFFFF")
        assert(UIColor.white.hexString(includeAlpha: false) == "#FFFFFF")
        assert(UIColor.white.colorComponents() == (1.0, 1.0, 1.0, 1.0))
        
        assert((try? UIColor(rgba_throws: "abcd")) == nil)
        assert((try? UIColor(rgba_throws: "#xyz")) == nil)

    }

}
