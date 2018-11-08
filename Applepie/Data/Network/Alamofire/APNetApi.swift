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
import CocoaLumberjack

public enum APRequestType {
    case json, data, string, uploadMultipart
}
public protocol APNetIndicatorProtocol {
    var indicator: APIndicatorProtocol? { get set }
    func setIndicator(_ indicator: APIndicatorProtocol?, view: UIView?, text: String?) -> Self
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

public struct APUploadFile {
    var data: Data
    var name: String
    var fileName: String
    var mimeType: String
}
public protocol APNetApiUploadProtocol {
    var files: [APUploadFile]? { get set }
}

public protocol APNetApi: class, APResponseHandler, APNetIndicatorProtocol {
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
    public func fill(map: [String : Any]) {}
    public func fill(array: [Any]) {}
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
    public func setIndicator(_ indicator: APIndicatorProtocol?, view: UIView?, text: String?) -> Self {
        APNetIndicatorClient.add(api: self, indicator: indicator, view: view, text: text)
        return self
    }
}

public extension APNetApi {
    private func getDataRequest(data: Data? = nil) -> DataRequest {
        let requestUrl = try! self.baseUrlString.asURL().appendingPathComponent(self.url)
        let requestParams = baseParams + params
        DDLogInfo("[AP][NetApi] 请求发起: [\(method.rawValue)] \(requestUrl.absoluteURL.absoluteString)?\(requestParams.ap.queryString)")
        let sessionManager = APNetClient.getSessionManager(api: self)
        let request = { () -> DataRequest in
            if let data = data {
                return sessionManager.upload(data, to: requestUrl, method: self.method, headers: self.headers)
            }
            return sessionManager.request(requestUrl, method: self.method, parameters: requestParams, headers: self.headers)
        }()
        if let task = request.task {
            APNetIndicatorClient.bind(api: self, task: task)
        }
        request.resume()
        if let validate = requestHandler?.validate {
            return request.validate(validate)
        }
        return request
    }
    private func getMultipartUploadDataRequest(task: URLSessionTask) -> SignalProducer<DataRequest, APError> {
        let requestUrl = try! self.baseUrlString.asURL().appendingPathComponent(self.url)
        let requestParams = baseParams + params
        DDLogInfo("[AP][NetApi] 请求发起: [\(method.rawValue)]\(requestUrl.absoluteURL.absoluteString)?\(requestParams.ap.queryString)")
        let sessionManager = APNetClient.getSessionManager(api: self)
        sessionManager.startRequestsImmediately = true
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        APNetIndicatorClient.bind(api: self, task: task)
        NotificationCenter.default.post(name: Notification.Name.Task.DidResume, object: nil, userInfo: [Notification.Key.Task: task])
      
        return SignalProducer { [unowned self] sink, disposable in
            sessionManager.upload(multipartFormData: { [unowned self] formData in
                self.fillMultipartData(upload: self as! APNetApiUploadProtocol, params: requestParams, multipart: formData)
                }, with: request, encodingCompletion: { [weak self] result in
                    guard let strongSelf = self else {
                        sink.sendInterrupted()
                        return
                    }
                    switch result {
                    case .success(var uploadRequest, _, _):
                        if let validate = strongSelf.requestHandler?.validate {
                            uploadRequest = uploadRequest.validate(validate)
                        }
                        sink.send(value: uploadRequest)
                    case .failure(let error):
                        let (error, canceled) = strongSelf.handleError(error, request: request, response: nil)
                        if canceled {
                            NotificationCenter.default.post(name: Notification.Name.Task.DidCancel, object: nil, userInfo: [Notification.Key.Task: task])
                            sink.sendInterrupted()
                        } else {
                            NotificationCenter.default.post(name: Notification.Name.Task.DidSuspend, object: nil, userInfo: [Notification.Key.Task: task])
                            sink.send(error: error)
                        }
                    }
            })
        }
    }
    
    private func createBody(upload: APNetApiUploadProtocol, params: [String: Any]?) -> Data {
        let multipart = MultipartFormData()
        fillMultipartData(upload: upload, params: params, multipart: multipart)
        return try! multipart.encode()
    }
    private func fillMultipartData(upload: APNetApiUploadProtocol, params: [String: Any]?, multipart: MultipartFormData) {
        if let params = params {
            for (key, value) in params {
                multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: key)
            }
        }
        if let files = upload.files {
            for file in files {
                multipart.append(file.data, withName: file.name, fileName: file.fileName, mimeType: file.mimeType)
            }
        }
    }
    private func handleError(_ error:Error, request: URLRequest? = nil, response: HTTPURLResponse? = nil) -> (APError, Bool) {
        let error = error as NSError
        if let statusCode = APStatusCode(rawValue:error.code) {
            switch(statusCode) {
            case .canceled:
                DDLogWarn("[AP][NetApi] 请求取消: \(request?.url?.absoluteString ?? "" )")
                let err = APError(statusCode: statusCode.rawValue, message: "请求取消")
                self.error = err
                return (err, true)
            default:
                break
            }
        }
        let err = error is APError ? error as! APError : APError(error: error)
        err.response = response
        self.error = err
        DDLogError("[AP][NetApi] 请求失败: \(request?.url?.absoluteString ?? "" ), 错误: \(err)")
        return (err, false)
    }
}

public extension APNetApi {
    private func requestJson(data: Data? = nil) -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink, disposable in
            self.getDataRequest(data: data).responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
                DDLogInfo("[AP][NetApi] 请求完成: \(response.request?.url?.absoluteString ?? "" ), 耗时: \(String(format:"%.2f", response.timeline.requestDuration))")
                strongSelf.responseData = response.data
                
                let str: String = response.result.value == nil ? "" :  "\(response.result.value!)"
                #if DEBUG
                DDLogInfo("[AP][NetApi] 请求结果：Json: \(str.ap.unicodeDecode())")
                #else
                DDLogInfo("[AP][NetApi] 请求结果：Json: \(str)")
                #endif
                let result = strongSelf.adapt(response.result)
                switch result {
                case .success:
                    if let value = result.value {
                        strongSelf.fill(data: value)
                    }
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
            }
        }
    }
    private func requestData() -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink, disposable in
            self.getDataRequest().responseData { [weak self] response in
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
                DDLogInfo("[AP][NetApi] 请求完成: \(response.request?.url?.absoluteString ?? "" ), 耗时: \(String(format:"%.2f", response.timeline.requestDuration))")
                strongSelf.responseData = response.data
                DDLogInfo("[AP][NetApi] 请求结果：Data: \(response.result.value?.count ?? 0) bytes")
                let result = strongSelf.adapt(response.result)
                switch result {
                case .success:
                    if let value = result.value {
                        strongSelf.fill(data: value)
                    }
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
            }
        }
    }
    private func requestString() -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink, disposable in
            self.getDataRequest().responseString { [weak self] response in
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
                DDLogInfo("[AP][NetApi] 请求完成: \(response.request?.url?.absoluteString ?? "" ), 耗时: \(String(format:"%.2f", response.timeline.requestDuration))")
                strongSelf.responseData = response.data
                DDLogInfo("[AP][NetApi] 请求结果：String: \(String(describing: response.result.value))")
                let result = strongSelf.adapt(response.result)
                switch result {
                case .success:
                    if let value = result.value {
                        strongSelf.fill(data: value)
                    }
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
            }
        }
    }
    private func requestUploadMultipart() -> SignalProducer<Self, APError> {
        APNetClient.add(api: self)
        return SignalProducer { [unowned self] sink,disposable in
            let task = URLSessionTask()
            self.getMultipartUploadDataRequest(task: task).on(failed: { error in
                sink.send(error: error)
            }, interrupted: {
                sink.sendInterrupted()
            }, value: { request in
                request.responseJSON { [weak self] response in
                    guard let strongSelf = self else { return }
                    APNetClient.remove(api: strongSelf)
                    DDLogInfo("[AP][NetApi] 请求完成: \(response.request?.url?.absoluteString ?? "" ), 耗时: \(String(format:"%.2f", response.timeline.requestDuration))")
                    strongSelf.responseData = response.data
                    DDLogInfo("[AP][NetApi] 请求结果：Json: \(String(describing: response.result.value))")
                    let result = strongSelf.adapt(response.result)
                    switch result {
                    case .success:
                        NotificationCenter.default.post(name: Notification.Name.Task.DidComplete, object: nil, userInfo: [Notification.Key.Task: task])
                        if let value = result.value {
                            strongSelf.fill(data: value)
                        }
                        sink.send(value: strongSelf)
                        sink.sendCompleted()
                        return
                    case .failure(let error):
                        let (error, canceled) = strongSelf.handleError(error, request: response.request, response: response.response)
                        if canceled {
                            NotificationCenter.default.post(name: Notification.Name.Task.DidCancel, object: nil, userInfo: [Notification.Key.Task: task])
                            sink.sendInterrupted()
                        } else {
                            NotificationCenter.default.post(name: Notification.Name.Task.DidSuspend, object: nil, userInfo: [Notification.Key.Task: task])
                            sink.send(error: error)
                        }
                    }
                }
            }).start()
            
            disposable.observeEnded { [weak self] in
                NotificationCenter.default.post(name: Notification.Name.Task.DidComplete, object: nil, userInfo: [Notification.Key.Task: task])
                guard let strongSelf = self else { return }
                APNetClient.remove(api: strongSelf)
            }
        
        }
    }
    func signal(format: APRequestType = .json) -> SignalProducer<Self, APError> {
        if let err = error {
            return SignalProducer { sink, _ in
                sink.send(error: err)
            }
        }
        switch format {
        case .json:
            if let uploador = self as? APNetApiUploadProtocol {
                let data = self.createBody(upload: uploador, params: self.params)
                return self.requestJson(data: data)
            }
            return self.requestJson()
        case .data:
            return self.requestData()
        case .string:
            return self.requestString()
        case .uploadMultipart:
            return self.requestUploadMultipart()
        }
        
    }
}
