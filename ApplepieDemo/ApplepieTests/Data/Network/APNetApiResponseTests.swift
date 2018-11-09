//
//  APNetApiResponseTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/9.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import Alamofire
import ReactiveCocoa

class APNetApiResponseTests: BaseTestCase {

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testResponseJson() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        class TestRequestHandler: APRequestHandler {
            
            weak var testApi: APNetApi!
            
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.success
            }
        }
        
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
        assert(APNetClient.runningApis().count == 0)
        api.signal(format: .json).on(started: {
            assert(APNetClient.runningApis().count == 1)
            assert(APNetClient.runningApis().first! === api)
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            expectation.fulfill()
        }, value: { data in
            assert(APNetClient.runningApis().count == 0)
            assert(api.responseData != nil)
            let headers = data.result!["headers"] as! [String: String]
            (Constant.baseHeaders + Constant.headers).forEach { (key, value) in
                assert(headers[key] == value)
            }
            let params = data.result!["args"] as! [String: String]
            assert((Constant.baseParams + Constant.params) == params)
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testResponseString() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        class TestRequestHandler: APRequestHandler {
            
            weak var testApi: APNetApi!
            
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.success
            }
            func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
                assert(urlRequest.httpMethod == testApi.method.rawValue)
                let url = try! testApi.baseUrlString.asURL().appendingPathComponent(testApi.url)
                assert(urlRequest.url!.absoluteString.starts(with: url.absoluteString))
                assert(urlRequest.url!.query!.ap.queryDictionary == (Constant.baseParams + Constant.params))
                return urlRequest
            }
            func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
                completion(false, 0.0)
            }
        }
        
        let api = TestStringNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        assert(APNetClient.runningApis().count == 0)
        api.signal(format: .string).on(started: {
            assert(APNetClient.runningApis().count == 1)
            assert(APNetClient.runningApis().first! === api)
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            expectation.fulfill()
        }, value: { data in
            assert(APNetClient.runningApis().count == 0)
            assert(api.responseData != nil)
            assert(api.contentString != nil)
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testResponseData() {
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        class TestRequestHandler: APRequestHandler {
            
            weak var testApi: APNetApi!
            
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.success
            }
            func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
                assert(urlRequest.httpMethod == testApi.method.rawValue)
                let url = try! testApi.baseUrlString.asURL().appendingPathComponent(testApi.url)
                assert(urlRequest.url!.absoluteString.starts(with: url.absoluteString))
                assert(urlRequest.url!.query!.ap.queryDictionary == (Constant.baseParams + Constant.params))
                return urlRequest
            }
            func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
                completion(false, 0.0)
            }
        }
        
        let api = TestDataNetApi()
        api.baseUrlString = Constant.imageUrlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "u/883027"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        assert(APNetClient.runningApis().count == 0)
        api.signal(format: .data).on(started: {
            assert(APNetClient.runningApis().count == 1)
            assert(APNetClient.runningApis().first! === api)
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            expectation.fulfill()
        }, value: { data in
            assert(APNetClient.runningApis().count == 0)
            assert(api.responseData != nil)
            assert(api.imageData != nil)
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }

}
