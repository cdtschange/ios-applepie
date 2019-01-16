//
//  APBaseViewControllerTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APBaseWebViewControllerTests: BaseTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    struct TestError: Error {
        var code: Int
    }
    
    func testWebViewController() {
        let expectation = XCTestExpectation(description: "Complete")
        Promise<Void> { sink in
            APRouter.route(toUrl: "https://www.baidu.com", name: "BaseWebViewController")
            sink.fulfill()
            }.then {
                return after(.seconds(5))
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
