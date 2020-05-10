//
//  APNetIndicatorClientTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/8.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import Alamofire
import ReactiveCocoa

extension String {
    /// User info dictionary key representing the `Request` associated with the notification.
    fileprivate static let requestKey = "org.alamofire.notification.key.request"
}

class APNetIndicatorClientTests: BaseTestCase {
    
    func mockRequest() -> Request {
        return Session().request(URLRequest(url: URL(string: "https://www.baidu.com")!))
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    class TestRequestHandler: APRequestHandler {
        
        weak var testApi: APNetApi!
    }
    
    func testNetIndicator() {
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APIndicator()
        let view = UIView()
        let text = "Loading"
        api.setIndicator(indicator, view: view, text: text).signal(format: .json).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model != nil)
            assert(model!.api === api)
            assert(model!.indicator === indicator)
            assert(model!.view == view)
            assert(model!.text == text)
            assert(model!.request != nil)
            assert(indicator.showing == true)
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model == nil)
            let api2 = TestNetApi()
            api2.baseUrlString = Constant.urlString
            api2.baseHeaders = Constant.baseHeaders
            api2.headers = HTTPHeaders(Constant.headers)
            api2.baseParams = Constant.baseParams
            api2.url = "get"
            api2.params = Constant.params
            let handler2 = TestRequestHandler()
            handler2.testApi = api2
            api2.requestHandler = handler2
            let indicator2 = APIndicator()
            let view2 = UIView()
            let text2 = "Loading"
            api2.setIndicator(indicator2, view: view2, text: text2).signal(format: .json).on(started: {
                let model = APNetIndicatorClient.getIndicatorModel(identifier: api2.identifier)
                assert(model != nil)
                assert(model!.api === api2)
                assert(model!.indicator === indicator2)
                assert(model!.view == view2)
                assert(model!.text == text2)
                assert(model!.request != nil)
                assert(indicator2.showing == true)
            }, failed: { error in
                assertionFailure()
                expectation.fulfill()
            }, completed: {
                let model = APNetIndicatorClient.getIndicatorModel(identifier: api2.identifier)
                assert(model == nil)
                expectation.fulfill()
            }, value: { data in
            }).start()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRemoveIndicator() {
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APIndicator()
        let view = UIView()
        let text = "Loading"
        api.setIndicator(indicator, view: view, text: text).signal(format: .json).on(started: {
            APNetIndicatorClient.remove(indicator: indicator)
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model == nil)
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testCancelTask() {
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APIndicator()
        let view = UIView()
        let text = "Loading"
        api.setIndicator(indicator, view: view, text: text).signal(format: .json).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model != nil)
            assert(model!.indicator!.showing == true)
            model!.request!.cancel()
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model == nil)
            assert(indicator.showing == false)
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testMockCancel() {
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APIndicator()
        let view = UIView()
        let text = "Loading"
        
        let request = mockRequest()
        _ = api.setIndicator(indicator, view: view, text: text)
        APNetIndicatorClient.bind(api: api, request: request)
        var model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        NotificationCenter.default.post(name: Request.didResumeNotification, object: nil, userInfo: [String.requestKey: request])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == true)
        NotificationCenter.default.post(name: Request.didCancelNotification, object: nil, userInfo: [String.requestKey: request])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model == nil)
        
    }
    
    func testMockSuspend() {
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders as [String: Any]
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APIndicator()
        let view = UIView()
        let text = "Loading"
        
        let request = mockRequest()
        _ = api.setIndicator(indicator, view: view, text: text)
        APNetIndicatorClient.bind(api: api, request: request)
        var model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        NotificationCenter.default.post(name: Request.didResumeNotification, object: nil, userInfo: [String.requestKey: request])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == true)
        NotificationCenter.default.post(name: Request.didSuspendNotification, object: nil, userInfo: [String.requestKey: request])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == false)
        NotificationCenter.default.post(name: Request.didResumeNotification, object: nil, userInfo: [String.requestKey: request])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == true)
        NotificationCenter.default.post(name: Request.didCompleteTaskNotification, object: nil, userInfo: [String.requestKey: request])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model == nil)
    }
    
}
