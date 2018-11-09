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

class APNetIndicatorClientTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    class TestRequestHandler: APRequestHandler {
        
        weak var testApi: APNetApi!
        
        var validate: DataRequest.Validation = { _, _, _ in
            return DataRequest.ValidationResult.success
        }
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            return urlRequest
        }
        func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
            completion(false, 0.0)
        }
    }
    
    func testNetIndicator() {
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        api.setIndicator(indicator, view: view, text: text).signal(format: .json).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model != nil)
            assert(model!.api === api)
            assert(model!.indicator === indicator)
            assert(model!.view == view)
            assert(model!.text == text)
            assert(model!.task != nil)
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
            api2.headers = Constant.headers
            api2.baseParams = Constant.baseParams
            api2.url = "get"
            api2.params = Constant.params
            let handler2 = TestRequestHandler()
            handler2.testApi = api2
            api2.requestHandler = handler2
            let indicator2 = APListIndicator()
            let view2 = UIView()
            let text2 = "Loading"
            api2.setIndicator(indicator2, view: view2, text: text2).signal(format: .json).on(started: {
                let model = APNetIndicatorClient.getIndicatorModel(identifier: api2.identifier)
                assert(model != nil)
                assert(model!.api === api2)
                assert(model!.indicator === indicator2)
                assert(model!.view == view2)
                assert(model!.text == text2)
                assert(model!.task != nil)
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
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APSingleIndicator()
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
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        api.setIndicator(indicator, view: view, text: text).signal(format: .json).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            assert(model != nil)
            assert(model!.indicator!.showing == true)
            model!.task!.cancel()
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
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        
        _ = api.setIndicator(indicator, view: view, text: text)
        let task = URLSessionTask()
        APNetIndicatorClient.bind(api: api, task: task)
        var model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        NotificationCenter.default.post(name: Notification.Name.Task.DidResume, object: nil, userInfo: [Notification.Key.Task: task])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == true)
        NotificationCenter.default.post(name: Notification.Name.Task.DidCancel, object: nil, userInfo: [Notification.Key.Task: task])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model == nil)
        
    }
    
    func testMockSuspend() {
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        
        _ = api.setIndicator(indicator, view: view, text: text)
        let task = URLSessionTask()
        APNetIndicatorClient.bind(api: api, task: task)
        var model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        NotificationCenter.default.post(name: Notification.Name.Task.DidResume, object: nil, userInfo: [Notification.Key.Task: task])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == true)
        NotificationCenter.default.post(name: Notification.Name.Task.DidSuspend, object: nil, userInfo: [Notification.Key.Task: task])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == false)
        NotificationCenter.default.post(name: Notification.Name.Task.DidResume, object: nil, userInfo: [Notification.Key.Task: task])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model != nil)
        assert(model?.indicator?.showing == true)
        NotificationCenter.default.post(name: Notification.Name.Task.DidComplete, object: nil, userInfo: [Notification.Key.Task: task])
        model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
        assert(model == nil)
    }
    
}
