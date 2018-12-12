//
//  APBiometricsTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/12.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class APBiometricsTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsSupport() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")

        APBiometrics.isSupport.done { success in
            print(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func testIsBiometryTypeFaceID() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        
        APBiometrics.isBiometryTypeFaceID.done { success in
            print(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    func testIsBiometryTypeTouchID() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        
        APBiometrics.isBiometryTypeTouchID.done { success in
            print(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    func testAuthenticate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        APBiometrics.authenticate(withReason: "reason", policy: .deviceOwnerAuthentication).done { success in
            print(success)
            }.catch { error in
                print(error)
        }
    }

}
