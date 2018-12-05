//
//  APPNetApiPromiseTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2018/12/5.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit
import Alamofire

class APPNetApiPromiseTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    class TestRequestHandler: APRequestHandler {
        var validate: DataRequest.Validation = { _, _, _ in
            return DataRequest.ValidationResult.success
        }
    }
    
    func testThen() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        api.requestHandler = TestRequestHandler()
        
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        
        firstly {
            Promise { sink in
                indicator.show(inView: view, text: text, detailText: nil, animated: true)
                sink.fulfill()
            }
            }.then {
                api.promise(format: .json)
            }.ensure {
                indicator.hide(inView: view, animated: true)
            }.done { data in
                let params = data.result!["args"] as! [String: String]
                assert((Constant.baseParams + Constant.params) == params)
                expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        assert(indicator.showing == false)
    }
    
    func testSerialThen() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Given
        let expectation = XCTestExpectation(description: "Complete")

        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        api.requestHandler = TestRequestHandler()

        let api2 = TestNetApi()
        api2.baseUrlString = Constant.urlString
        api2.baseHeaders = Constant.baseHeaders
        api2.headers = Constant.headers
        api2.baseParams = Constant.baseParams
        api2.url = "get"
        api2.params = Constant.params
        api2.requestHandler = TestRequestHandler()

        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"

        firstly {
            Promise { sink in
                indicator.show(inView: view, text: text, detailText: nil, animated: true)
                sink.fulfill()
            }
            }.then(on: DispatchQueue(label: "", qos: .utility)) { () -> Promise<TestNetApi> in
                assert(Thread.current.isMainThread == false)
                return api.promise(format: .json)
            }.then { data -> Promise<TestNetApi> in
                let params = data.result!["args"] as! [String: String]
                assert((Constant.baseParams + Constant.params) == params)
                return api2.promise(format: .string)
            }.ensure {
                indicator.hide(inView: view, animated: true)
            }.done(on: DispatchQueue.main) { data in
                assert(Thread.current.isMainThread == true)
                assert(data.responseData != nil)
                expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
        assert(indicator.showing == false)
    }
    
    func testErrorThen() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        let code = APStatusCode.badRequest.rawValue
        let message = "test"
        let err = APError(statusCode: code, message: message)
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        api.requestHandler = TestRequestHandler()
        
        let api2 = TestNetApi()
        api2.error = err
        
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        
        firstly {
            Promise { sink in
                indicator.show(inView: view, text: text, detailText: nil, animated: true)
                sink.fulfill()
            }
            }.then {
                when(fulfilled: api.promise(format: .json), api2.promise(format: .json))
            }.ensure {
                indicator.hide(inView: view, animated: true)
            }.done { data, data2 in
                assertionFailure()
                expectation.fulfill()
            }.catch { error in
                assert((error as! APError).description == err.description)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        assert(indicator.showing == false)
    }
    
    func testConcurrentWhen() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        api.requestHandler = TestRequestHandler()
        
        let api2 = TestDataNetApi()
        api2.baseUrlString = Constant.imageUrlString
        api2.baseHeaders = Constant.baseHeaders
        api2.headers = Constant.headers
        api2.baseParams = Constant.baseParams
        api2.url = "u/883027"
        api2.params = Constant.params
        api2.requestHandler = TestRequestHandler()
        
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        
        firstly {
            Promise { sink in
                indicator.show(inView: view, text: text, detailText: nil, animated: true)
                sink.fulfill()
            }
            }.then {
                when(fulfilled: api.promise(format: .json), api2.promise(format: .data))
            }.ensure {
                indicator.hide(inView: view, animated: true)
            }.done { data, data2 in
                let params = data.result!["args"] as! [String: String]
                assert((Constant.baseParams + Constant.params) == params)
                
                assert(data2.imageData != nil)
                expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        assert(indicator.showing == false)
    }
    
    func testThenAndError() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        
        let code = APStatusCode.badRequest.rawValue
        let message = "test"
        let err = APError(statusCode: code, message: message)
        
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.url = "get"
        api.params = Constant.params
        api.requestHandler = TestRequestHandler()
        
        let api2 = TestNetApi()
        api2.error = err
        
        let indicator = APSingleIndicator()
        let view = UIView()
        let text = "Loading"
        
        firstly {
            Promise { sink in
                indicator.show(inView: view, text: text, detailText: nil, animated: true)
                sink.fulfill()
            }
            }.then {
                api.promise(format: .json)
            }.then { _ in
                api2.promise(format: .json)
            }.ensure {
                indicator.hide(inView: view, animated: true)
            }.done { data in
                assertionFailure()
                expectation.fulfill()
            }.catch { error in
                assert((error as! APError).description == err.description)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        assert(indicator.showing == false)
    }
    
    
    func testRequestJsonError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.promise(format: .json).done { _ in
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    
    func testRequestStringError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.promise(format: .string).done { _ in
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    
    func testRequestDataError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.promise(format: .data).done { _ in
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    func testRequestUploadError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test error"))
            }
        }
        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.url = "get"
        api.requestHandler = TestRequestHandler()
        api.promise(format: .upload).done { _ in
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    func testRequestMultipartUploadError() {
        
        // Given
        let expectation = XCTestExpectation(description: "Complete")
        class TestRequestHandler: APRequestHandler {
            var validate: DataRequest.Validation = { _, _, _ in
                return DataRequest.ValidationResult.failure(APError(statusCode: APStatusCode.badRequest.rawValue, message: "test cancel"))
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
        api.promise(format: .multipartUpload).done { _ in
            assertionFailure()
            expectation.fulfill()
            }.catch { error in
                expectation.fulfill()
        }
        
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testUpload() {
        
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
                return urlRequest
            }
            func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
                completion(false, 0.0)
            }
        }
        
        let api = TestUploadNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.url = "post"
        api.method = .post
        api.dataUrl = url(forResource: "rainbow", withExtension: "jpg")
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        
        api.promise(format: .upload).done { _ in
            assert(api.responseData != nil)
            expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testMultipartUpload() {
        
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
                return urlRequest
            }
            func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
                completion(false, 0.0)
            }
        }
        
        let api = TestUploadMultipartNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
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
        
        api.promise(format: .multipartUpload).done { _ in
            assert(api.responseData != nil)
            expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
