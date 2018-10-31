//
//  APNetClient.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Alamofire
import CocoaLumberjack

struct APNetClient {
    
    static var sessions: [String: SessionManager] = [:]
    
    static func getSessionManager(api: APNetApi) -> SessionManager {
        if sessions.keys.contains(api.sessionIdentifier) {
            return sessions[api.sessionIdentifier]!
        }
        let sessionManager: SessionManager = {
            let configuration = URLSessionConfiguration.default
            var headers: [String : Any] = SessionManager.defaultHTTPHeaders
            if let baseHeader = api.baseHeader {
                headers += baseHeader
            }
            configuration.httpAdditionalHeaders = headers
            configuration.timeoutIntervalForResource = api.timeoutIntervalForResource
            configuration.timeoutIntervalForRequest = api.timeoutIntervalForRequest
            let sm = SessionManager(configuration: configuration)
            let handler = api.requestHandler
            sm.adapter = handler
            sm.retrier = handler
            sm.startRequestsImmediately = false
            return sm
        }()
        sessions[api.sessionIdentifier] = sessionManager
        return sessionManager
    }
    
    static func clearCookie() {
        DDLogInfo("[AP][NetClient] 清除Cookie")
        let cookieJar = HTTPCookieStorage.shared
        
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    // MARK: RunningApi
    
    private static var _runningApis = [APNetApi]()
    
    public static func runningApis() -> [APNetApi] {
        return _runningApis
    }
    public static func add(api: APNetApi) {
        _runningApis.append(api)
        DDLogDebug("[AP][NetApi][+][\(_runningApis.count)] \(api)")
    }
    public static func remove(api: APNetApi) {
        if let index = _runningApis.index(where: { api === $0 }) {
            _runningApis.remove(at: index)
            DDLogDebug("[AP][NetApi][-][\(_runningApis.count)] \(api)")
        }
    }
}

