//
//  CacheRepository.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class CacheRepository: BaseRepository {
    struct InnerConstant {
        static let keychainIdentifier = "com.cdts.applepiedemo"
    }
    var cacheString: String? {
        get {
            return APPinCache.object(forKey: "ApplepieDemo.cacheString") as? String
        }
        set {
            return APPinCache.setObject(newValue, forKey: "ApplepieDemo.cacheString")
        }
    }
    var cacheInt: Int? {
        get {
            return APPinCache.object(forKey: "ApplepieDemo.cacheInt") as? Int
        }
        set {
            return APPinCache.setObject(newValue, forKey: "ApplepieDemo.cacheInt")
        }
    }
    var cacheDouble: Double? {
        get {
            return APPinCache.object(forKey: "ApplepieDemo.cacheDouble") as? Double
        }
        set {
            return APPinCache.setObject(newValue, forKey: "ApplepieDemo.cacheDouble")
        }
    }
    var cacheBool: Bool? {
        get {
            return APPinCache.object(forKey: "ApplepieDemo.cacheBool") as? Bool
        }
        set {
            return APPinCache.setObject(newValue, forKey: "ApplepieDemo.cacheBool")
        }
    }
    
    var userDefaultsString: String? {
        get {
            return APUserDefaults.object(forKey: "ApplepieDemo.userDefaultsString") as? String
        }
        set {
            return APUserDefaults.setObject(newValue, forKey: "ApplepieDemo.userDefaultsString")
        }
    }
    var userDefaultsInt: Int? {
        get {
            return APUserDefaults.object(forKey: "ApplepieDemo.userDefaultsInt") as? Int
        }
        set {
            return APUserDefaults.setObject(newValue, forKey: "ApplepieDemo.userDefaultsInt")
        }
    }
    var userDefaultsDouble: Double? {
        get {
            return APUserDefaults.object(forKey: "ApplepieDemo.userDefaultsDouble") as? Double
        }
        set {
            return APUserDefaults.setObject(newValue, forKey: "ApplepieDemo.userDefaultsDouble")
        }
    }
    var userDefaultsBool: Bool? {
        get {
            return APUserDefaults.object(forKey: "ApplepieDemo.userDefaultsBool") as? Bool
        }
        set {
            return APUserDefaults.setObject(newValue, forKey: "ApplepieDemo.userDefaultsBool")
        }
    }
    
    
    private let keychain = APKeychain(identifier: InnerConstant.keychainIdentifier)
    var keychainString: String? {
        get {
            return keychain.string(forKey: "ApplepieDemo.keychainString")
        }
        set {
            keychain.set(string: newValue, forKey: "ApplepieDemo.keychainString")
        }
    }
    var keychainInt: Int? {
        get {
            return keychain.string(forKey: "ApplepieDemo.keychainInt")?.ap.toInt
        }
        set {
            keychain.set(string: newValue?.ap.toString, forKey: "ApplepieDemo.keychainInt")
        }
    }
    var keychainDouble: Double? {
        get {
            return keychain.string(forKey: "ApplepieDemo.keychainDouble")?.ap.toDouble
        }
        set {
            keychain.set(string: newValue?.ap.toString, forKey: "ApplepieDemo.keychainDouble")
        }
    }
    var keychainBool: Bool? {
        get {
            return keychain.string(forKey: "ApplepieDemo.keychainBool")?.ap.toBool
        }
        set {
            keychain.set(string: newValue?.ap.toString, forKey: "ApplepieDemo.keychainBool")
        }
    }
}

enum CacheType: String {
    case disk, userDefaults, keychain
}

struct CacheModel {
    var title: String
    var detail: Any?
}
