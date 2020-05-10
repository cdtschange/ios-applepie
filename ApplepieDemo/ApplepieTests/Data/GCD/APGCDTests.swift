//
//  APGCDTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/26.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import UIKit

class APGCDTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExecute() {
        let expectation = XCTestExpectation(description: "Complete")
        var color = UIColor.white
        APGCD().execute(waitFor: {
            assert(Thread.current != Thread.main)
            color = UIColor.red
            usleep(100000) // 0.1s
        }) {
            assert(Thread.current == Thread.main)
            assert(color == UIColor.red)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        assert(color == UIColor.red)

    }

    func testExecuteWithT() {
        let expectation = XCTestExpectation(description: "Complete")
        APGCD().execute(waitFor: {
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
        APGCD()
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
        assert(number == 15)
    }
    
    func testConcurrent() {
        let expectation = XCTestExpectation(description: "Complete")
        var number = 0
        APGCD(queue: DispatchQueue.global())
            .concurrent {
                assert(Thread.current != Thread.main)
                number += 1
                print("testConcurrent:1 num:\(number)")
            }.concurrent {
                assert(Thread.current != Thread.main)
                number += 2
                print("testConcurrent:2 num:\(number)")
            }.concurrentBarrier {
                assert(Thread.current != Thread.main)
                number += 3
                print("testConcurrent:3 num:\(number)")
            }.concurrentBarrier {
                assert(Thread.current != Thread.main)
                number += 4
                print("testConcurrent:4 num:\(number)")
            }.concurrent {
                assert(Thread.current != Thread.main)
                number += 5
                print("testConcurrent:5 num:\(number)")
            }.concurrentDone {
                assert(Thread.current == Thread.main)
                print("testConcurrent:done num:\(number)")
                assert(number == 15)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        assert(number == 15)
    }
    
    func testConcurrent2() {
        let expectation = XCTestExpectation(description: "Complete")
        var number = 0
        var gcd = APGCD()
        gcd = gcd.setQueue(queue: DispatchQueue.global())
        gcd
            .concurrentBarrier {
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
        assert(number == 15)
    }
    
    func testDelayExecute() {
        let expectation = XCTestExpectation(description: "Complete")
        var num = 0
        APGCD().delayExecute(after: .milliseconds(500)) {
            num += 1
            assert(Thread.current == Thread.main)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
        assert(num == 1)
    }
    
    func testTimer() {
        let expectation = XCTestExpectation(description: "Complete")
        var num = 0
        var event = APGCD()
        var date: Date?
        let milliseconds = 50
        let repeating = 0.01
        event.timer(duration: .milliseconds(milliseconds), repeating: repeating, invoked: {
            num += 1
            if date == nil {
                date = Date()
            } else {
                assert(abs((Date().timeIntervalSince(date!)) - Double(num) * repeating) < 0.1)
            }
        }, canceled: {
            assert(num == milliseconds / 10 + 1)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10)
    }
    
    func testTimerAbort() {
        let expectation = XCTestExpectation(description: "Complete")
        var num = 0
        var event = APGCD()
        var date: Date?
        let milliseconds = 50
        let repeating = 0.01
        event.timer(duration: .milliseconds(milliseconds), repeating: repeating, invoked: {
            num += 1
            if date == nil {
                date = Date()
            } else {
                assert(abs((Date().timeIntervalSince(date!)) - Double(num) * repeating) < 0.1)
            }
        }, canceled: {
            assert(num == 2 + 1)
            assert(abs(Date().timeIntervalSince(date!) - 0.025) < 0.01)
            expectation.fulfill()
        })
        event.delayExecute(after: .milliseconds(25)) {
            event.cancelTimer()
        }
        wait(for: [expectation], timeout: 10)
    }
    
//    func testArrayConcurrentPerform() {
//        let data = [1, 2, 3]
//        var sum = 0
//        
//        data.concurrentForeach { (ele) in
//            usleep(100000) // 0.1s
//            sum += ele
//        }
//        assert(sum == 6)
//    }
}
