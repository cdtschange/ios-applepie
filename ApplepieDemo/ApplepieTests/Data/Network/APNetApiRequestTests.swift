//
//  APNetApiTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/2.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import Alamofire
import ReactiveCocoa

class APNetApiRequestTests: BaseTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestGet() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        class TestRequestHandler: APRequestHandler {
            
            weak var testApi: APNetApi!
            
            func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
                assert(urlRequest.httpMethod == testApi.method.rawValue)
                let url = try! testApi.baseUrlString.asURL().appendingPathComponent(testApi.url)
                assert(urlRequest.url!.absoluteString.starts(with: url.absoluteString))
                assert(urlRequest.url!.query!.ap.queryDictionary == (Constant.baseParams + Constant.params))
                return urlRequest
            }
        }
        class TestRequestHandler2: APRequestHandler {
            
            weak var testApi: APNetApi!
            
        }

        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        api.sessionIdentifier = "session0"
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        assert(APNetClient.runningApis().count == 0)
        assert(APNetClient.sessions[api.sessionIdentifier] == nil)
        api.signal().on(started: {
            assert(APNetClient.runningApis().count == 1)
            assert(APNetClient.runningApis().first! === api)
            assert(APNetClient.sessions[api.sessionIdentifier] != nil)
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
        }, value: { data in
            assert(APNetClient.runningApis().count == 0)
            assert(api.responseData != nil)
            let headers = data.result!["headers"] as! [String: String]
            (Constant.baseHeaders + Constant.headers).forEach { (key, value) in
                assert(headers[key] == value)
            }
            let params = data.result!["args"] as! [String: String]
            assert((Constant.baseParams + Constant.params) == params)
            let api2 = TestNetApi()
            api2.baseUrlString = Constant.urlString
            api2.baseHeaders = Constant.baseHeaders
            api2.headers = HTTPHeaders(Constant.headers)
            api2.baseParams = Constant.baseParams
            api2.url = "get"
            api2.params = Constant.params
            api2.sessionIdentifier = "session0"
            let handler2 = TestRequestHandler2()
            handler2.testApi = api2
            api2.requestHandler = handler2
            assert(APNetClient.runningApis().count == 0)
            assert(APNetClient.sessions[api2.sessionIdentifier] != nil)
            api2.signal(format: .json).on(started: {
                assert(APNetClient.runningApis().count == 1)
                assert(APNetClient.runningApis().first! === api2)
                assert(APNetClient.sessions[api2.sessionIdentifier] != nil)
            }, failed: { error in
                assertionFailure()
                expectation.fulfill()
            }, completed: {
                expectation.fulfill()
            }, value: { data in
                assert(APNetClient.runningApis().count == 0)
            }).start()
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRequestPost() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        class TestRequestHandler: APRequestHandler {
            
            weak var testApi: APNetApi!
            
            func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
                assert(urlRequest.httpMethod == testApi.method.rawValue)
                let url = try! testApi.baseUrlString.asURL().appendingPathComponent(testApi.url)
                assert(urlRequest.url!.absoluteString.starts(with: url.absoluteString))
                return urlRequest
            }
        }
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "post"
        api.params = Constant.unicodeParams
        api.method = .post
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
            let params = data.result!["form"] as! [String: String]
            assert((Constant.baseParams + Constant.unicodeParams) == params)
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testClearCookie() {
        let cookieJar = HTTPCookieStorage.shared
        let cookie = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": "k=v"], for: URL(string:  "http://test.com")!).first!
        assert(cookieJar.cookies?.contains(cookie) == false)
        cookieJar.setCookie(cookie)
        assert(cookieJar.cookies?.contains(cookie) == true)
        APNetClient.clearCookie()
        assert(cookieJar.cookies?.contains(cookie) == false)
        assert(cookieJar.cookies?.count == 0)
    }

}
