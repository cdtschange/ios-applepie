//
//  APBiometrics.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/12.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import PromiseKit
import LocalAuthentication
import CocoaLumberjack

public enum APBiometricsError: Error {
    case unsupported, unknown
}

public struct APBiometrics {
    private static var context: Promise<LAContext> {
        return Promise { sink in
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                DDLogInfo("[Biometrics] Supported")
                sink.fulfill(context)
            } else {
                DDLogWarn("[Biometrics] UnSupported")
                sink.reject(error ?? APBiometricsError.unsupported)
            }
        }
    }
    
    public static var isSupport: Guarantee<Bool> {
        return context.map { _ in
            return true
            }.recover { _ in
                return Guarantee { sink in
                    sink(false)
                }
        }
    }
    
    public static var isBiometryTypeTouchID: Guarantee<Bool> {
        return context.map { context in
            if #available(iOS 11, *) {
                if context.biometryType == .touchID {
                    return true
                }
                return false
            } else {
                return true
            }
            }.recover { _ in
                return Guarantee { sink in
                    sink(false)
                }
        }
    }
    public static var isBiometryTypeFaceID: Guarantee<Bool> {
        return context.map { context in
            if #available(iOS 11, *) {
                if context.biometryType == .faceID {
                    return true
                }
                return false
            } else {
                return false
            }
            }.recover { _ in
                return Guarantee { sink in
                    sink(false)
                }
        }
    }
    
    public static func authenticate(withReason reason: String, policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics) -> Promise<Bool> {
        return context.then { context -> Promise<Bool> in
            return Promise<Bool> { sink in
                context.evaluatePolicy(policy, localizedReason: reason) { (success, error) in
                    if success {
                        DDLogInfo("[Biometrics] Auth Success")
                        sink.fulfill(true)
                    } else {
                        DDLogInfo("[Biometrics] Auth Failed")
                        sink.reject(error ?? APBiometricsError.unknown)
                    }
                }
            }
        }
    }
}
