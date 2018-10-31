//
//  RequestApi.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/30.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Alamofire
import CocoaLumberjack

public protocol APIndicatorProtocol {
    var indicator: APNetIndicator? { get set }
    func setIndicator(_ indicator: APNetIndicator?, view: UIView?, text: String?) -> Self
}

public protocol APResponseHandler {
    func adapt(_ result: Result<Any>) -> Result<Any>
    func adapt(_ result: Result<Data>) -> Result<Data>
    func adapt(_ result: Result<String>) -> Result<String>
    
    func fill(data: Any)
    func fill(map: [String: Any])
    func fill(array: [Any])
}

public protocol APRequestHandler: RequestAdapter, RequestRetrier {
    var validate: DataRequest.Validation { get }
}

public extension APRequestHandler {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        return urlRequest
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(false, 0)
    }
}

public protocol APNetApi: class, APResponseHandler, APIndicatorProtocol {
    var url: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    
    var identifier: String { get }
    var sessionIdentifier: String { get }
    var baseHeader: [String: Any]? { get }
    var baseUrlString: String { get }
    var timeoutIntervalForRequest: TimeInterval { get }
    var timeoutIntervalForResource: TimeInterval { get }
    var responseData: Data? { get set }
    var error: APNetError? { get set }
    var requestHandler: APRequestHandler? { get }
}

public extension APNetApi {
    
    func adapt(_ result: Result<Any>) -> Result<Any> {
        return result
    }
    func adapt(_ result: Result<Data>) -> Result<Data> {
        return result
    }
    func adapt(_ result: Result<String>) -> Result<String> {
        return result
    }
    func fill(data: Any) {
        if let map = data as? [String: Any] {
            fill(map: map)
        } else if let array = data as? [Any] {
            fill(array: array)
        }
    }
}

public extension APNetApi {
    func toModel<T>(_ type: T.Type, value: Any?) -> T? where T : Decodable {
        guard let value = value else { return nil }
        return toModel(type, value: value)
    }
    func toModel<T>(_ type: T.Type, value: Any) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: value) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

public extension APNetApi {
    public func setIndicator(_ indicator: APNetIndicator?, view: UIView?, text: String?) -> Self {
        APNetIndicator.add(api: self, indicator: indicator, view: view, text: text)
        return self
    }
}

public extension APNetApi {
    private func getDataRequest() -> DataRequest {
        let requestUrl = try! self.baseUrlString.asURL().appendingPathComponent(self.url)
        DDLogInfo("[AP][NetApi] 请求发起: [\(method.rawValue)] \(requestUrl.absoluteURL.absoluteString)?\(params?.ap.toHttpQueryString() ?? "")")
        let sessionManager = APNetClient.getSessionManager(api: self)
        let request = sessionManager.request(requestUrl, method: self.method, parameters: self.params, headers: self.headers)
        if let task = request.task {
            APNetIndicator.bindTask(api: self, task: task)
        }
        request.resume()
        if let validate = requestHandler?.validate {
            return request.validate(validate)
        }
        return request
    }
}
