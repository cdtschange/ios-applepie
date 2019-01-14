//
//  APIndicatorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/8.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class APIndicatorTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIndicator() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // single indicator
        assert(UIApplication.shared.indicatorCount == 0)
        let indicator = APIndicator()
        assert(indicator.showing == false)
        indicator.show(inView: nil, text: nil, detailText: nil, animated: true)
        assert(indicator.showing == true)
        assert(UIApplication.shared.indicatorCount == 1)
        indicator.hide(inView: nil, animated: true)
        assert(indicator.showing == false)
        assert(UIApplication.shared.indicatorCount == 0)

        
        // multi indicator concurrent
        let indicator1 = APIndicator()
        let indicator2 = APIndicator()
        assert(UIApplication.shared.indicatorCount == 0)
        indicator1.show(inView: nil, text: nil, detailText: nil, animated: true)
        assert(indicator1.showing == true)
        assert(UIApplication.shared.indicatorCount == 1)
        indicator2.show(inView: nil, text: nil, detailText: nil, animated: true)
        assert(UIApplication.shared.indicatorCount == 2)
        assert(indicator2.showing == true)
        indicator1.hide(inView: nil, animated: true)
        assert(indicator1.showing == false)
        assert(indicator2.showing == true)
        assert(UIApplication.shared.indicatorCount == 1)
        indicator2.hide(inView: nil, animated: true)
        assert(indicator1.showing == false)
        assert(indicator2.showing == false)
        assert(UIApplication.shared.indicatorCount == 0)
        
    }

}
