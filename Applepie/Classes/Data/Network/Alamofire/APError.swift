//
//  NetError.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public enum APStatusCode: Int {
    case `default` = 0
    case canceled = 15
    case validateFailed = -99999
    case badRequest = 400
    case unAuthorized = 401
    case loginOtherDevice = 403
    
}

open class APError : NSError {
    public var response: HTTPURLResponse?
    public var statusCode: Int = 0
    public var message: String = ""
    public var originalMessage: String = ""
    open var defaultMessage = "Unkown Error"
    
    public init(statusCode: Int, message: String) {
        self.statusCode = statusCode
        self.message = message
        self.originalMessage = message
        super.init(domain: "APError", code: statusCode, userInfo: ["message":message])
        if message.count == 0 {
            self.message = defaultMessage
        }
        if message.contains("<html") {
            self.message = defaultMessage
        }
    }
    public convenience init(error: NSError){
        self.init(statusCode: error.code, message: error.description)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override var description: String {
        return "statusCode: \(statusCode), message: \(message), originalMessage: \(originalMessage), response: \(String(describing: response))"
    }
    
}
