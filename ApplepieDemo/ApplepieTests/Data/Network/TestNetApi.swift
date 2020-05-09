//
//  TestNetApi.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/8.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Applepie
import Alamofire
import ReactiveCocoa


struct Constant {
    static let urlString = "https://httpbin.org/"
    static let imageUrlString = "https://avatars0.githubusercontent.com/"
    static let urlNotExistString = "https://invalid-url-here.org/this/does/not/exist"
    static let baseHeaders = ["H1": "hv1"]
    static let headers = ["H2": "hv2"]
    static let baseParams = ["k1": "v1"]
    static let params = ["k2": "v2"]
    static let unicodeParams = [
        "french": "français",
        "japanese": "日本語",
        "arabic": "العربية",
        "emoji": "😃"
    ]
}

class TestNetApi: APNetApi {
    
    var indicator: APIndicatorProtocol?
    
    var url: String = ""
    var method: HTTPMethod = .get
    var params: [String: Any]?
    var headers: HTTPHeaders?
    
    var identifier: String = UUID().uuidString
    var sessionIdentifier: String = "sessionId1"
    var baseHeaders: [String: Any]? = Constant.baseHeaders
    var baseParams: [String : Any]? = Constant.baseParams
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
    func fill(data: Any) {
        if let map = data as? [String: Any] {
            fill(map: map)
        } else if let array = data as? [Any] {
            fill(array: array)
        }
    }
}
class TestStringNetApi: TestNetApi {
    var contentString: String?
    
    override func fill(data: Any) {
        contentString = data as? String
    }
}
class TestDataNetApi: TestNetApi {
    var imageData: Data?
    
    override func fill(data: Any) {
        imageData = data as? Data
    }
}

class TestUploadNetApi: TestNetApi, APNetApiUploadProtocol {
    var dataUrl: URL?
}
class TestUploadMultipartNetApi: TestNetApi, APNetApiUploadMultipart {
    var files: [APUploadMultipartFile]? = nil
}
class TestUploadMultipartForExceptionNetApi: TestNetApi, APNetApiUploadMultipart {
    var files: [APUploadMultipartFile]? = nil
    
    func beginMultipartFormData(formData: MultipartFormData) {}
    func adaptMultipartFormDataResult(result: SessionManager.MultipartFormDataEncodingResult) -> SessionManager.MultipartFormDataEncodingResult {
        return result
    }
    func didFinishUploadMultipartRequest() {}

}

class TestNetApiWithoutFill: APNetApi {
    
    var indicator: APIndicatorProtocol?
    
    var url: String = ""
    var method: HTTPMethod = .get
    var params: [String: Any]?
    var headers: HTTPHeaders?
    
    var identifier: String = UUID().uuidString
    var sessionIdentifier: String = "sessionId1"
    var baseHeaders: [String: Any]?
    var baseParams: [String : Any]?
    var baseUrlString: String = ""
    var timeoutIntervalForRequest: TimeInterval = 60
    var timeoutIntervalForResource: TimeInterval = 60
    var responseData: Data?
    var error: APError?
    var requestHandler: APRequestHandler?
}
