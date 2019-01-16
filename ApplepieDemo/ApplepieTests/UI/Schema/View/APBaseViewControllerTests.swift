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

class APBaseViewControllerTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct TestError: Error {
        var code: Int
    }

    func testViewController() {
        var vc: APBaseViewController! = UIViewController.topMostViewController() as? APBaseViewController
        vc.params = ["title": "Home"]
        let expectation = XCTestExpectation(description: "Complete")
        vc.showTip(APError(statusCode: 400, message: "test"))
        vc.showTip(TestError(code: 400))
        vc.showTip("test")
        vc.showIndicatorPromise.done {
            vc.hideIndicator()
            vc = nil
            expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }

}
