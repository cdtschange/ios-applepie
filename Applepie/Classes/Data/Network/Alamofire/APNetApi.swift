//
//  RequestApi.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/30.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import PromiseKit
import CocoaLumberjack

public typealias APResult<Success> = Swift.Result<Success, APError>

public enum APResponseType {
    case json, data, string
}
public protocol APNetIndicator {
    func setIndicator(_ indicator: APIndicatorProtocol?, view: UIView?, text: String?) -> Self
}

public protocol APResponseHandler {
    func adapt(_ result: APResult<Any>) -> APResult<Any>
    func adapt(_ result: APResult<Data>) -> APResult<Data>
    func adapt(_ result: APResult<String>) -> APResult<String>
    
    func fill(data: Any)
    func fill(map: [String: Any])
    func fill(array: [Any])
}

public protocol APRequestHandler: RequestInterceptor {
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> DataRequest.ValidationResult
}

public extension APRequestHandler {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }
    func validate(request: URLRequest?, response: HTTPURLResponse, data: Data?) -> DataRequest.ValidationResult {
        return .success(())
    }
}

public protocol APNetApiUpload: APNetApi {
    var dataUrl: URL? { get set }
}
public struct APUploadMultipartFile {
    public var data: Data
    public var name: String
    public var fileName: String
    public var mimeType: String
    public init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
public protocol APNetApiUploadMultipart: APNetApi {
    var files: [APUploadMultipartFile]? { get set }
    func beginMultipartFormData(formData: MultipartFormData)
    func didFinishUploadMultipartRequest()
    func processUpadte(_ process: Progress)
}
public extension APNetApiUploadMultipart {
    func beginMultipartFormData(formData: MultipartFormData) {}
    func didFinishUploadMultipartRequest() {}
    func processUpadte(_ process: Progress) {}
    
    func fillMultipartData(params: [String: Any]?, multipart: MultipartFormData) {
        if let params = params {
            for (key, value) in params {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
            }
        }
        if let files = files {
            for file in files {
                multipart.append(file.data, withName: file.name, fileName: file.fileName, mimeType: file.mimeType)
            }
        }
    }
}

public protocol APNetApi: class, APResponseHandler, APNetIndicator {
    var url: String { get }
    var method: HTTPMethod { get }
    var params: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    
    var identifier: String { get }
    var sessionIdentifier: String { get }
    var baseHeaders: [String: Any]? { get }
    var baseParams: [String: Any]? { get }
    var baseUrlString: String { get }
    var timeoutIntervalForRequest: TimeInterval { get }
    var timeoutIntervalForResource: TimeInterval { get }
    var responseData: Data? { get set }
    var error: APError? { get set }
    var requestHandler: APRequestHandler? { get }
}

public extension APNetApi {
    
    func adapt(_ result: APResult<Any>) -> APResult<Any> {
        return result
    }
    func adapt(_ result: APResult<Data>) -> APResult<Data> {
        return result
    }
    func adapt(_ result: APResult<String>) -> APResult<String> {
        return result
    }
    func fill(data: Any) {
        if let map = data as? [String: Any] {
            fill(map: map)
        } else if let array = data as? [Any] {
            fill(array: array)
        }
    }
    func fill(map: [String : Any]) {}
    func fill(array: [Any]) {}
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
    func setIndicator(_ indicator: APIndicatorProtocol?, view: UIView?, text: String?) -> Self {
        APNetIndicatorClient.add(api: self, indicator: indicator, view: view, text: text)
        return self
    }
}

public extension APNetApi {
    private func getDataRequest() -> DataRequest {
        let requestUrl = try! self.baseUrlString.asURL().appendingPathComponent(self.url)
        let requestParams = baseParams + params
        DDLogInfo("[AP][NetApi] Request start: [\(method.rawValue)] \(requestUrl.absoluteURL.absoluteString)?\(requestParams.ap.queryString)")
        let session = APNetClient.getSession(api: self)
        let request = { () -> DataRequest in
            if let api = self as? APNetApiUpload {
                return session.upload(api.dataUrl!, to: requestUrl, method: self.method, headers: self.headers, interceptor: self.requestHandler)
            } else if let api = self as? APNetApiUploadMultipart {
                var request = URLRequest(url: requestUrl)
                request.httpMethod = method.rawValue
                request.allHTTPHeaderFields = headers?.dictionary
                return session.upload(multipartFormData: { [weak self] formData in
                    api.beginMultipartFormData(formData: formData)
                    api.fillMultipartData(params: requestParams, multipart: formData)
                }, with: request).uploadProgress { progress in
                    api.processUpadte(progress)
                }
            }
            return session.request(requestUrl, method: self.method, parameters: requestParams, headers: self.headers, interceptor: self.requestHandler)
        }()
        APNetIndicatorClient.bind(api: self, request: request)
        request.resume()
        if let validate = requestHandler?.validate {
            return request.validate(validate)
        }
        return request
    }
    
    private func handleError(_ error: APError, request: URLRequest? = nil, response: HTTPURLResponse? = nil) -> (APError, Bool) {
        if let statusCode = APStatusCode(rawValue:error.code) {
            switch(statusCode) {
            case .canceled:
                DDLogWarn("[AP][NetApi] Request cancel: \(request?.url?.absoluteString ?? "")")
                error.response = response
                self.error = error
                return (error, true)
            default:
                break
            }
        }
        error.response = response
        self.error = error
        DDLogError("[AP][NetApi] Request failed: \(request!.url!.absoluteString), error: \(error)")
        return (error, false)
    }
}

extension AFResult {
    func toAPResult() -> APResult<Success> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            if let error = error.asAFError?.underlyingError {
                if let error = error as? APError {
                    return .failure(error)
                } else {
                    return .failure(APError(error: error as NSError))
                }
            }
            return .failure(APError(error: error as NSError))
        }
    }
}
public extension APNetApi {
    
    private func responseJson() -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink, disposable in
            self.getDataRequest().responseJSON { [weak self] response in
                guard let strongSelf = self else {
                    sink.sendInterrupted()
                    return
                }
                APNetClient.remove(api: strongSelf)
                APNetIndicatorClient.remove(api: strongSelf)
                DDLogInfo("[AP][NetApi] Request complete: \(response.debugDescription)")
                strongSelf.responseData = response.data
                let result = strongSelf.adapt(response.result.toAPResult())
                switch result {
                case .success(let value):
                    strongSelf.fill(data: value)
                    sink.send(value: strongSelf)
                    sink.sendCompleted()
                    return
                case .failure(let error):
                    let (error, canceled) = strongSelf.handleError(error, request: response.request, response: response.response)
                    if canceled {
                        sink.sendInterrupted()
                    } else {
                        sink.send(error: error)
                    }
                }
            }
            disposable.observeEnded {[weak self] in
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
                APNetIndicatorClient.remove(api: strongSelf)
            }
        }
    }
    private func responseData() -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink, disposable in
            self.getDataRequest().responseData { [weak self] response in
                guard let strongSelf = self else {
                    sink.sendInterrupted()
                    return
                }
                APNetClient.remove(api: strongSelf)
                APNetIndicatorClient.remove(api: strongSelf)
                DDLogInfo("[AP][NetApi] Request complete: \(response.debugDescription)")
                strongSelf.responseData = response.data
                let result = strongSelf.adapt(response.result.toAPResult())
                switch result {
                case .success(let value):
                    strongSelf.fill(data: value)
                    sink.send(value: strongSelf)
                    sink.sendCompleted()
                    return
                case .failure(let error):
                    let (error, canceled) = strongSelf.handleError(error, request: response.request, response: response.response)
                    if canceled {
                        sink.sendInterrupted()
                    } else {
                        sink.send(error: error)
                    }
                }
            }
            disposable.observeEnded { [weak self] in
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
                APNetIndicatorClient.remove(api: strongSelf)
            }
        }
    }
    private func requestString() -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink, disposable in
            self.getDataRequest().responseString { [weak self] response in
                guard let strongSelf = self else {
                    sink.sendInterrupted()
                    return
                }
                APNetClient.remove(api: strongSelf)
                APNetIndicatorClient.remove(api: strongSelf)
                DDLogInfo("[AP][NetApi] Request complete: \(response.debugDescription)")
                strongSelf.responseData = response.data
                let result = strongSelf.adapt(response.result.toAPResult())
                switch result {
                case .success(let value):
                    strongSelf.fill(data: value)
                    sink.send(value: strongSelf)
                    sink.sendCompleted()
                    return
                case .failure(let error):
                    let (error, canceled) = strongSelf.handleError(error, request: response.request, response: response.response)
                    if canceled {
                        sink.sendInterrupted()
                    } else {
                        sink.send(error: error)
                    }
                }
            }
            disposable.observeEnded { [weak self] in
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
                APNetIndicatorClient.remove(api: strongSelf)
            }
        }
    }
    func signal(format: APResponseType = .json) -> SignalProducer<Self, APError> {
        if let err = error {
            return SignalProducer { sink, _ in
                sink.send(error: err)
            }
        }
        var it = self
        if APNetIndicatorClient.getIndicatorModel(identifier: identifier) == nil {
            it = self.setIndicator(nil, view: nil, text: nil)
        }
        switch format {
        case .json:
            return it.responseJson()
        case .data:
            return it.responseData()
        case .string:
            return it.requestString()
        }
        
    }
    
    func promise(format: APResponseType = .json) -> Promise<Self> {
        if let err = error {
            return Promise { sink in
                sink.reject(err)
            }
        }
        var it = self
        if APNetIndicatorClient.getIndicatorModel(identifier: identifier) == nil {
            it = self.setIndicator(nil, view: nil, text: nil)
        }
        switch format {
        case .json:
            return Promise { sink in
                it.responseJson().on(failed: { err in
                    sink.reject(err)
                }, value: { data in
                    sink.fulfill(data)
                }).start()
            }
        case .data:
            return Promise { sink in
                it.responseData().on(failed: { err in
                    sink.reject(err)
                }, value: { data in
                    sink.fulfill(data)
                }).start()
            }
        case .string:
            return Promise { sink in
                it.requestString().on(failed: { err in
                    sink.reject(err)
                }, value: { data in
                    sink.fulfill(data)
                }).start()
            }
        }
    }
}
