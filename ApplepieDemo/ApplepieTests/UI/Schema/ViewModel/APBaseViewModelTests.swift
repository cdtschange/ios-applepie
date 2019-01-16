//
//  APBaseViewModelTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APBaseViewModelTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let _ = APBaseRepository()
        let viewModel = APBaseViewModel()
        assert(viewModel.repository == nil)
        let expectation = XCTestExpectation(description: "Complete")
        
        viewModel.fetchData().done { data in
            assert(data as! Bool == true)
            expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }

}
