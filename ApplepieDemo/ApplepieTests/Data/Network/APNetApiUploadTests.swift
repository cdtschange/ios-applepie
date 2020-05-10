//
//  APNetApiUploadTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/9.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import Alamofire
import ReactiveCocoa

class APNetApiUploadTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpload() {
        
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
        
        let api = TestUploadNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.url = "post"
        api.method = .post
        api.dataUrl = url(forResource: "rainbow", withExtension: "jpg")
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        assert(APNetClient.runningApis().count == 0)
        api.signal().on(started: {
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
            let dataString = data.result!["data"] as! String
            let data = try! Data(contentsOf: api.dataUrl!)
            assert(dataString.contains(data.base64EncodedString()))
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }

    func testMultipartUpload() {
        
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
        
        let api = TestUploadMultipartNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = HTTPHeaders(Constant.headers)
        api.baseParams = Constant.baseParams
        api.url = "post"
        api.params = Constant.unicodeParams
        api.method = .post
        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
        let fileData = try! Data(contentsOf: imageURL)
        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
        api.files = [file]
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        assert(APNetClient.runningApis().count == 0)
        api.signal().on(started: {
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
            let params = data.result!["form"] as! [String: Any]
            (Constant.baseParams + Constant.unicodeParams).forEach { (key, value) in
                assert(params[key] as! String == value)
            }
            let files = data.result!["files"] as! [String: Any]
            assert(files.keys.count == 1)
            assert((files[file.name] as! String).contains(file.data.base64EncodedString()))
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }

}
