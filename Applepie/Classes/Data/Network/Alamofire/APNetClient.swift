//
//  APNetClient.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import CocoaLumberjack

public struct APNetClient {
    
    private static var reachability = NetworkReachabilityManager()
    
    public static func getNetworkStatus() -> Guarantee<NetworkReachabilityManager.NetworkReachabilityStatus> {
        return Guarantee { sink in
            reachability?.startListening(onUpdatePerforming: { status in
                reachability?.stopListening()
                sink(status)
            })
        }
    }
    
    public static var sessions: [String: Session] = [:]
    
    public static func getSession(api: APNetApi) -> Session {
        if sessions.keys.contains(api.sessionIdentifier) {
            return sessions[api.sessionIdentifier]!
        }
        let session: Session = {
            let configuration = URLSessionConfiguration.default
            var headers: [String: Any] = HTTPHeaders.default.dictionary as? [String: Any] ?? [:]
            if let baseHeader = api.baseHeaders {
                headers += baseHeader
            }
            configuration.httpAdditionalHeaders = headers
            configuration.timeoutIntervalForResource = api.timeoutIntervalForResource
            configuration.timeoutIntervalForRequest = api.timeoutIntervalForRequest
            return Session(configuration: configuration, startRequestsImmediately: false)
        }()
        sessions[api.sessionIdentifier] = session
        return session
    }
    
    public static func clearCookie() {
        DDLogInfo("[AP][NetClient] Clear cookie")
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
        if let index = _runningApis.firstIndex(where: { api === $0 }) {
            _runningApis.remove(at: index)
            DDLogDebug("[AP][NetApi][-][\(_runningApis.count)] \(api)")
        }
    }
}

