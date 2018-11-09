//
//  APNetApiErrorTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2018/11/9.
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
    
//    func testMultipartUploadCancel() {
//
//        // Given
//        let expectation = XCTestExpectation(description: "Complete")
//
//        let api = TestUploadMultipartNetApi()
//        api.baseUrlString = Constant.urlNotExistString
//        api.url = ""
//        let imageURL = url(forResource: "rainbow", withExtension: "jpg")
//        let fileData = try! Data(contentsOf: imageURL)
//        let file = APUploadMultipartFile(data: fileData, name: "testName", fileName: "testFile" , mimeType: "image/jpeg")
//        api.files = [file]
//        api.signal(format: .multipartUpload).on(started: {
//            let model = APNetIndicatorClient.getIndicatorModel(identifier: api.identifier)
//            model!.task!.cancel()
//        }, failed: { error in
//            assertionFailure()
//            expectation.fulfill()
//        }, completed: {
//            assertionFailure()
//            expectation.fulfill()
//        }, interrupted: {
//            expectation.fulfill()
//        }, value: { data in
//        }).start()
//
//        wait(for: [expectation], timeout: 20)
//    }
    
    
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
        
        wait(for: [expectation], timeout: 20)
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
        
        wait(for: [expectation], timeout: 20)
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
        
        wait(for: [expectation], timeout: 20)
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
}
