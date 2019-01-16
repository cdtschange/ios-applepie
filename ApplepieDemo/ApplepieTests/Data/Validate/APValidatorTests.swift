//
//  APValidatorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APValidatorTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        APValidator.validate(conditions: [(1 == 1, "error1")]).done {
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                assert((error as! APError).message == "error1")
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testValidateList() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        APValidator.validate(conditions: [(0 == 1, "error1"), (1 == 1, "error2")]).done {
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                assert((error as! APError).message == "error2")
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testValidateSuccess() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        APValidator.validate(conditions: [(0 == 1, "error1"), (0 == 1, "error2")]).done {
            expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
