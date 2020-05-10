//
//  APErrorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/8.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import Alamofire
import ReactiveCocoa

class APErrorTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPError() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let code = APStatusCode.badRequest.rawValue
        let message = "test"
        let error = APError(statusCode: code, message: message)
        assert(error.statusCode == code)
        assert(error.originalMessage == message)
        assert(error.message == message)
        assert(error.description.contains("statusCode"))
        assert(error.description.contains("message"))
        
        let httpMessage = "<html>"
        let httpError = APError(statusCode: code, message: httpMessage)
        assert(httpError.statusCode == code)
        assert(httpError.originalMessage == httpMessage)
        assert(httpError.message == httpError.defaultMessage)
        
        let emptyError = APError(statusCode: code, message: "")
        assert(emptyError.statusCode == code)
        assert(emptyError.originalMessage == "")
        assert(emptyError.message == httpError.defaultMessage)
        
        let nsError = NSError(domain: "domain", code: code, userInfo: nil)
        let testNSError = APError(error: nsError)
        assert(testNSError.statusCode == code)
        assert(testNSError.message == nsError.description)
        
    }
    
    func testApiError() {
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.error = APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error")
        api.signal().on(failed: { error in
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, value: { data in
            assertionFailure()
        }).start()
        wait(for: [expectation], timeout: 10)
    }

    
    func testRequestJsonError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> DataRequest.ValidationResult {
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.signal(format: .json).on(started: {
        }, failed: { error in
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    
    
    func testRequestStringError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> DataRequest.ValidationResult {
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.signal(format: .string).on(started: {
        }, failed: { error in
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    
    
    func testRequestDataError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> DataRequest.ValidationResult {
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.signal(format: .data).on(started: {
        }, failed: { error in
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testRequestMultipartUploadError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> DataRequest.ValidationResult {
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestUploadMultipartNetApi()
        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
        let fileData = try! Data(contentsOf: imageURL)
        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
        api.files = [file]
        api.baseUrlString = Constant.urlString
        api.url = "post"
        api.method = .post
        api.requestHandler = TestRequestHandler()
        api.signal().on(started: {
        }, failed: { error in
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
}
