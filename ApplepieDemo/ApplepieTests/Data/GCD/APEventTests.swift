//
//  APEventTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/26.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import UIKit

class APEventTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExecute() {
        let expectation = XCTestExpectation(description: "Complete")
        var color = UIColor.white
        APEvent().execute(waitFor: {
            assert(Thread.current != Thread.main)
            color = UIColor.red
            usleep(100000) // 0.1s
        }) {
            assert(Thread.current == Thread.main)
            assert(color == UIColor.red)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)

    }

    func testExecuteWithT() {
        let expectation = XCTestExpectation(description: "Complete")
        APEvent().execute(waitFor: {
            assert(Thread.current != Thread.main)
            let color = UIColor.red
            usleep(100000) // 0.1s
            return color
        }) { (color: UIColor) in
            assert(Thread.current == Thread.main)
            assert(color == UIColor.red)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        
    }

    func testSerial() {
        let expectation = XCTestExpectation(description: "Complete")
        var number = 0
        APEvent()
            .serial {
                assert(Thread.current != Thread.main)
                number += 1
                assert(number == 1)
            }.serial {
                assert(Thread.current != Thread.main)
                number += 2
                assert(number == 3)
            }.serial {
                assert(Thread.current != Thread.main)
                number += 3
                assert(number == 6)
            }.serial {
                assert(Thread.current != Thread.main)
                number += 4
                assert(number == 10)
            }.serial {
                assert(Thread.current != Thread.main)
                number += 5
                assert(number == 15)
            }.serialDone {
                assert(Thread.current == Thread.main)
                assert(number == 15)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testConcurrent() {
        let expectation = XCTestExpectation(description: "Complete")
        var number = 0
        APEvent()
            .concurrent {
                assert(Thread.current != Thread.main)
                number += 1
            }.concurrent {
                assert(Thread.current != Thread.main)
                number += 2
            }.concurrentBarrier {
                assert(Thread.current != Thread.main)
                number += 3
            }.concurrentBarrier {
                assert(Thread.current != Thread.main)
                number += 4
            }.concurrent {
                assert(Thread.current != Thread.main)
                number += 5
            }.concurrentDone {
                assert(Thread.current == Thread.main)
                assert(number == 15)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
