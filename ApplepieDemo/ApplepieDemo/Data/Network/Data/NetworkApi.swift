//
//  NetworkApi.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation
import Applepie
import Alamofire

open class NetworkApi: APNetApi {
    
    public var indicator: APIndicatorProtocol?
    
    open var url: String { return "" }
    open var method: HTTPMethod { return .get }
    open var params: [String: Any]? { return nil }
    open var headers: HTTPHeaders? { return nil }
    
    public var identifier: String = UUID().uuidString
    public var sessionIdentifier: String = "NetworkApi"
    public var baseHeaders: [String: Any]? = ["base": "header from base"]
    public var baseParams: [String : Any]? = ["base": "params from base"]
    public var baseUrlString: String = "https://httpbin.org"
    public var timeoutIntervalForRequest: TimeInterval = 60
    public var timeoutIntervalForResource: TimeInterval = 60
    public var responseData: Data?
    public var error: APError?
    public var requestHandler: APRequestHandler?
    
    public var result: [String : Any]?
    
    open func fill(map: [String : Any]) {
        result = map
    }
    open func fill(data: Any) {
        if let map = data as? [String: Any] {
            fill(map: map)
        } else if let array = data as? [Any] {
            fill(array: array)
        }
    }
}

class NetworkApiHander: APRequestHandler {
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


class GetNetworkApi: NetworkApi {
    
    override var url: String {
        return "/get"
    }
    override var params: [String : Any]? {
        return ["param1": 1, "param2": "abc"]
    }
    override var headers: HTTPHeaders? {
        return ["header1": "xyz"]
    }
}

class PostNetworkApi: NetworkApi {
    
    override var url: String {
        return "/post"
    }
    override var method: HTTPMethod {
        return .post
    }
    override var params: [String : Any]? {
        return ["param1": 1, "param2": "abc"]
    }
    override var headers: HTTPHeaders? {
        return ["header1": "xyz"]
    }
}

class PutNetworkApi: NetworkApi {
    
    override var url: String {
        return "/put"
    }
    override var method: HTTPMethod {
        return .put
    }
    override var params: [String : Any]? {
        return ["param1": 1, "param2": "abc"]
    }
    override var headers: HTTPHeaders? {
        return ["header1": "xyz"]
    }
}

class DeleteNetworkApi: NetworkApi {
    
    override var url: String {
        return "/delete"
    }
    override var method: HTTPMethod {
        return .delete
    }
    override var params: [String : Any]? {
        return ["param1": 1, "param2": "abc"]
    }
    override var headers: HTTPHeaders? {
        return ["header1": "xyz"]
    }
}

class UploadNetworkApi: NetworkApi, APNetApiUploadProtocol {
    var dataUrl: URL?
    
    override var url: String {
        return "/post"
    }
    override var method: HTTPMethod {
        return .post
    }
    override var params: [String : Any]? {
        return ["param1": 1, "param2": "abc"]
    }
    override var headers: HTTPHeaders? {
        return ["header1": "xyz"]
    }
}

class MultipartUploadNetworkApi: NetworkApi, APNetApiUploadMultipartProtocol {
    var files: [APUploadMultipartFile]?
    
    override var url: String {
        return "/post"
    }
    override var method: HTTPMethod {
        return .post
    }
    override var params: [String : Any]? {
        return ["param1": 1, "param2": "abc"]
    }
    override var headers: HTTPHeaders? {
        return ["header1": "xyz"]
    }
}
