//
//  APNetApiErrorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/9.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import Alamofire
import ReactiveCocoa

class APNetApiOtherTests: BaseTestCase {

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetApiWithoutFill() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        let api = TestNetApiWithoutFill()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.signal().on(failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
        
        api.fill(data: [])
    }
    
    func testRequestJsonCancel() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.signal(format: .json).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            model!.task!.cancel()
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRequestStringCancel() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.signal(format: .string).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            model!.task!.cancel()
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testRequestDataCancel() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.signal(format: .data).on(started: {
            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
            model!.task!.cancel()
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    
    func testRequestMultipartUploadError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.canceled.rawValue, message: "test cancel"))
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
        api.signal(format: .multipartUpload).on(started: {
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testRequestJsonNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        var api: TestNetApi? = TestNetApi()
        api!.baseUrlString = Constant.urlString
        api!.url = "get"
        api!.signal(format: .json).on(started: {
            APNetIndicatorClient.remove(api: api!)
            APNetClient.remove(api: api!)
            api = nil
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    func testRequestStringNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        var api: TestNetApi? = TestNetApi()
        api!.baseUrlString = Constant.urlString
        api!.url = "get"
        api!.signal(format: .string).on(started: {
            APNetIndicatorClient.remove(api: api!)
            APNetClient.remove(api: api!)
            api = nil
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    func testRequestDataNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        var api: TestNetApi? = TestNetApi()
        api!.baseUrlString = Constant.urlString
        api!.url = "get"
        api!.signal(format: .data).on(started: {
            APNetIndicatorClient.remove(api: api!)
            APNetClient.remove(api: api!)
            api = nil
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 10)
    }
    
    class TestUploadMultipartNetApiForBeginNil: TestUploadMultipartForExceptionNetApi {
        override func beginMultipartFormData(formData: MultipartFormData) {
            APNetIndicatorClient.remove(api: testRequestMultipartUploadForBeginNilApi!)
            APNetClient.remove(api: testRequestMultipartUploadForBeginNilApi!)
            testRequestMultipartUploadForBeginNilApi = nil
        }
    }
    class TestUploadMultipartNetApiForAdaptDataNil: TestUploadMultipartForExceptionNetApi {
        override func adaptMultipartFormDataResult(result: SessionManager.MultipartFormDataEncodingResult) -> SessionManager.MultipartFormDataEncodingResult {
            APNetIndicatorClient.remove(api: testRequestMultipartUploadForAdaptDataNilApi!)
            APNetClient.remove(api: testRequestMultipartUploadForAdaptDataNilApi!)
            testRequestMultipartUploadForAdaptDataNilApi = nil
            return result
        }
    }
    class TestUploadMultipartNetApiForAdaptDataError: TestUploadMultipartForExceptionNetApi {
        override func adaptMultipartFormDataResult(result: SessionManager.MultipartFormDataEncodingResult) -> SessionManager.MultipartFormDataEncodingResult {
            return SessionManager.MultipartFormDataEncodingResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
        }
    }
    class TestUploadMultipartNetApiForFinishRequestNil: TestUploadMultipartForExceptionNetApi {
        override func didFinishUploadMultipartRequest() {
            APNetIndicatorClient.remove(api: testRequestMultipartUploadForFinishRequestNilApi!)
            APNetClient.remove(api: testRequestMultipartUploadForFinishRequestNilApi!)
            testRequestMultipartUploadForFinishRequestNilApi = nil
        }
    }
    static var testRequestMultipartUploadForBeginNilApi: TestUploadMultipartForExceptionNetApi?
    static var testRequestMultipartUploadForAdaptDataNilApi: TestUploadMultipartForExceptionNetApi?
    static var testRequestMultipartUploadForFinishRequestNilApi: TestUploadMultipartForExceptionNetApi?
    func testRequestMultipartUploadForBeginNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.canceled.rawValue, message: "test cancel"))
            }
        }
        var api: TestUploadMultipartForExceptionNetApi? = TestUploadMultipartNetApiForBeginNil()
        APNetApiOtherTests.testRequestMultipartUploadForBeginNilApi = api
        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
        let fileData = try! Data(contentsOf: imageURL)
        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
        api!.files = [file]
        api!.baseUrlString = Constant.urlString
        api!.url = "post"
        api!.method = .post
        api!.requestHandler = TestRequestHandler()
        api!.signal(format: .multipartUpload).on(starting: {
            api = nil
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    func testRequestMultipartUploadForAdaptDataNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.canceled.rawValue, message: "test cancel"))
            }
        }
        var api: TestUploadMultipartForExceptionNetApi? = TestUploadMultipartNetApiForAdaptDataNil()
        APNetApiOtherTests.testRequestMultipartUploadForAdaptDataNilApi = api
        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
        let fileData = try! Data(contentsOf: imageURL)
        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
        api!.files = [file]
        api!.baseUrlString = Constant.urlString
        api!.url = "post"
        api!.method = .post
        api!.requestHandler = TestRequestHandler()
        api!.signal(format: .multipartUpload).on(starting: {
            api = nil
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    func testRequestMultipartUploadForAdaptDataError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.canceled.rawValue, message: "test cancel"))
            }
        }
        let api: TestUploadMultipartForExceptionNetApi? = TestUploadMultipartNetApiForAdaptDataError()
        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
        let fileData = try! Data(contentsOf: imageURL)
        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
        api!.files = [file]
        api!.baseUrlString = Constant.urlString
        api!.url = "post"
        api!.method = .post
        api!.requestHandler = TestRequestHandler()
        api!.signal(format: .multipartUpload).on(starting: {
        }, failed: { error in
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            assertionFailure()
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
    func testRequestMultipartUploadForFinishRequestNil() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.canceled.rawValue, message: "test cancel"))
            }
        }
        var api: TestUploadMultipartForExceptionNetApi? = TestUploadMultipartNetApiForFinishRequestNil()
        APNetApiOtherTests.testRequestMultipartUploadForFinishRequestNilApi = api
        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
        let fileData = try! Data(contentsOf: imageURL)
        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
        api!.files = [file]
        api!.baseUrlString = Constant.urlString
        api!.url = "post"
        api!.method = .post
        api!.requestHandler = TestRequestHandler()
        api!.signal(format: .multipartUpload).on(starting: {
            api = nil
        }, failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            assertionFailure()
            expectation.fulfill()
        }, interrupted: {
            expectation.fulfill()
        }, value: { data in
        }).start()
        
        wait(for: [expectation], timeout: 20)
    }
}
