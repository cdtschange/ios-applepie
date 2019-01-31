//
//  APRepeatingTimerTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APRepeatingTimerTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimber() {
        
        let timer = APRepeatingTimer(timeInterval: 0.1)
        var suspend = false
        timer.eventHandler = {
            assert(!suspend)
            print("Timer running")
        }
        let expectation = XCTestExpectation(description: "Complete")
        after(.seconds(1)).map {
            timer.suspend()
            suspend = true
            timer.suspend()
            }.then {
                return after(.seconds(1))
            }.map {
                suspend = false
                timer.resume()
                timer.resume()
            }.then {
                return after(.seconds(1))
            }.done {
                timer.cancel()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }

}
