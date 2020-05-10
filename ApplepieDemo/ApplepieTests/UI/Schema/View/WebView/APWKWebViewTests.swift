//
//  APWKWebViewTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APWKWebViewTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWebView() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var webView = APWKWebView(frame: CGRect.zero)
       
//        let data = try! NSKeyedArchiver.archivedData(withRootObject: webView, requiringSecureCoding: false)
//        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)
//        let webView2 = APWKWebView(coder: coder)
//        assert(webView2 != nil)
        
        webView = APWKWebView(frame: CGRect.zero, injectScript: "")
        print(webView.userAgent ?? "")
        webView.userAgent = ""
        webView.progressBarEnable = true
        webView.refreshHeaderEnable = false
        webView.refreshHeaderEnable = true
        webView.requestHeader = ["a" : "1"]
        let expectation = XCTestExpectation(description: "Complete")
        Promise<Void> { sink in
            webView.request(url: "https://www.baidu.com")
            sink.fulfill(())
            }.then { () -> Guarantee<Void> in
                return after(.seconds(5))
            }.done { data in
                webView.request(url: "abc")
                expectation.fulfill()
                
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        
        
        
        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
