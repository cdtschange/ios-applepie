//
//  APBaseViewControllerTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APBaseListViewControllerTests: BaseTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct TestError: Error {
        var code: Int
    }
    
    func testListViewController() {
        let expectation = XCTestExpectation(description: "Complete")
        Promise<Void> { sink in
            APRouter.route(toName: "DataViewController")
            sink.fulfill()
            }.then {
                return after(.seconds(1))
            }.done {
                APRouter.routeBack()
                expectation.fulfill()
                
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
}
