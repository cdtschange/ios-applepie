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

struct Constant {
    static let urlString = "https://httpbin.org/"
    static let baseHeaders = ["H1": "hv1"]
    static let headers = ["H2": "hv2"]
    static let baseParams = ["k1": "v1"]
    static let params = ["k2": "v2"]
}

class APNetApiRequestTests: XCTestCase {
    
    private class TestNetApi: APNetApi {
        
        var indicator: APIndicatorProtocol?
        
        var url: String = ""
        var method: HTTPMethod = .get
        var params: [String: Any]?
        var headers: HTTPHeaders?
        
        var identifier: String = UUID().uuidString
        var sessionIdentifier: String = ""
        var baseHeaders: [String: Any]?
        var baseParams: [String : Any]?
        var baseUrlString: String = ""
        var timeoutIntervalForRequest: TimeInterval = 60
        var timeoutIntervalForResource: TimeInterval = 60
        var responseData: Data?
        var error: APError?
        var requestHandler: APRequestHandler?
        
        var result: [String : Any]?
        
        func fill(map: [String : Any]) {
            result = map
        }
    }
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestClassMethodWithMethodGet() {
        
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

        let api = TestNetApi()
        api.baseUrlString = Constant.urlString
        api.baseHeaders = Constant.baseHeaders
        api.headers = Constant.headers
        api.baseParams = Constant.baseParams
        api.params = Constant.params
        api.url = "get"
        api.params = Constant.params
        let handler = TestRequestHandler()
        handler.testApi = api
        api.requestHandler = handler
        api.signal(format: .json).on(failed: { error in
            assertionFailure()
            expectation.fulfill()
        }, completed: {
            expectation.fulfill()
        }, value: { data in
            assert(api.responseData != nil)
            let headers = data.result!["headers"] as! [String: String]
            (Constant.baseHeaders + Constant.headers).forEach { (key, value) in
                assert(headers[key] == value)
            }
            let params = data.result!["args"] as! [String: String]
            assert((Constant.baseParams + Constant.params) == params)
        }).start()
        
        wait(for: [expectation], timeout: 10)
        
        
        // When
//        let request = api.request(urlString)
//
//        // Then
//        XCTAssertNotNil(request.request)
//        XCTAssertEqual(request.request?.httpMethod, "GET")
//        XCTAssertEqual(request.request?.url?.absoluteString, urlString)
//        XCTAssertNil(request.response)
    }

    
    
//    private class TestModel: Codable {
//        //        var a: Int?
//        var b: String?
//        //        var c: Double?
//        //        var d: Bool?
//        //        var m: TestInnerModel?
//    }
//    
//    private class TestInnerModel: Codable {
//        var arr: [String]?
//        var dict: [String: String]?
//    }
//    
//    func testToModel() {
//        var modelDict: [String: String] = [:]
//        //        modelDict["a"] = 1
//        modelDict["b"] = "word"
//        //        modelDict["c"] = 1.0
//        //        modelDict["d"] = true
//        //        modelDict["m"] = ["arr": ["a","b","c","d"], "dict": ["k1": "v1", "k2": "v2"]]
//        let strValue = """
//{"b": "word"}
//"""
//        guard let data = try? JSONSerialization.data(withJSONObject: strValue) else { return }
//        let model: TestModel =  try! JSONDecoder().decode(TestModel.self, from: data)
//        //        assert(model.a! == 1)
//    }
}
