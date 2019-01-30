//
//  CacheViewModel.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit

class CacheViewModel: BaseListViewModel {
    
    var type: CacheType = .disk
    
    private var _repository = CacheRepository()
    override var repository: APBaseRepository? {
        return _repository
    }
    
    override func fetchData() -> Promise<Any> {
        var data = [CacheModel]()
        switch type {
        case .disk: data = [
            CacheModel(title: "String", detail: _repository.cacheString),
            CacheModel(title: "Int", detail: _repository.cacheInt),
            CacheModel(title: "Double", detail: _repository.cacheDouble),
            CacheModel(title: "Bool", detail: _repository.cacheBool)]
        case .userDefaults: data = [
            CacheModel(title: "String", detail: _repository.userDefaultsString),
            CacheModel(title: "Int", detail: _repository.userDefaultsInt),
            CacheModel(title: "Double", detail: _repository.userDefaultsDouble),
            CacheModel(title: "Bool", detail: _repository.userDefaultsBool)]
        case .keychain: data = [
            CacheModel(title: "String", detail: _repository.keychainString),
            CacheModel(title: "Int", detail: _repository.keychainInt),
            CacheModel(title: "Double", detail: _repository.keychainDouble),
            CacheModel(title: "Bool", detail: _repository.keychainBool)]
        }
        return Promise { sink in
            sink.fulfill(data)
            }.map { [weak self] data in
                self?.appendDataArray(data)
                return data
        }
    }
    
    func updateData(_ type: CacheType, key: String) -> CacheModel? {
        switch type {
        case .disk:
            switch key {
            case "String": return CacheModel(title: "String", detail: _repository.cacheString)
            case "Int": return CacheModel(title: "Int", detail: _repository.cacheInt)
            case "Double": return CacheModel(title: "Double", detail: _repository.cacheDouble)
            case "Bool": return CacheModel(title: "Bool", detail: _repository.cacheBool)
            default: return nil
            }
        case .userDefaults:
            switch key {
            case "String": return CacheModel(title: "String", detail: _repository.userDefaultsString)
            case "Int": return CacheModel(title: "Int", detail: _repository.userDefaultsInt)
            case "Double": return CacheModel(title: "Double", detail: _repository.userDefaultsDouble)
            case "Bool": return CacheModel(title: "Bool", detail: _repository.userDefaultsBool)
            default: return nil
            }
        case .keychain:
            switch key {
            case "String": return CacheModel(title: "String", detail: _repository.keychainString)
            case "Int": return CacheModel(title: "Int", detail: _repository.keychainInt)
            case "Double": return CacheModel(title: "Double", detail: _repository.keychainDouble)
            case "Bool": return CacheModel(title: "Bool", detail: _repository.keychainBool)
            default: return nil
            }
        }
    }
    
    func fetchString(_ type: CacheType) -> String? {
        switch type {
        case .disk: return _repository.cacheString
        case .userDefaults: return _repository.userDefaultsString
        case .keychain: return _repository.keychainString
        }
    }
    func fetchInt(_ type: CacheType) -> Int? {
        switch type {
        case .disk: return _repository.cacheInt
        case .userDefaults: return _repository.userDefaultsInt
        case .keychain: return _repository.keychainInt
        }
    }
    func fetchDouble(_ type: CacheType) -> Double? {
        switch type {
        case .disk: return _repository.cacheDouble
        case .userDefaults: return _repository.userDefaultsDouble
        case .keychain: return _repository.keychainDouble
        }
    }
    func fetchBool(_ type: CacheType) -> Bool? {
        switch type {
        case .disk: return _repository.cacheBool
        case .userDefaults: return _repository.userDefaultsBool
        case .keychain: return _repository.keychainBool
        }
    }
    
    func saveString(_ type: CacheType) {
        var value = fetchString(type)
        if value == nil || value == "Z" {
            value = "A"
        } else {
            value = String(UnicodeScalar(UnicodeScalar(value!)!.value + 1)!)
        }
        switch type {
        case .disk: _repository.cacheString = value
        case .userDefaults: _repository.userDefaultsString = value
        case .keychain: _repository.keychainString = value
        }
    }
    
    func saveInt(_ type: CacheType) {
        var value = fetchInt(type)
        if value == nil || value == 9 {
            value = 0
        } else {
            value = value! + 1
        }
        switch type {
        case .disk: _repository.cacheInt = value
        case .userDefaults: _repository.userDefaultsInt = value
        case .keychain: _repository.keychainInt = value
        }
    }
    
    func saveDouble(_ type: CacheType) {
        var value = fetchDouble(type)
        if value == nil || value! >= 1.0 {
            value = 0.0
        } else {
            value = value! + 0.1
        }
        switch type {
        case .disk: _repository.cacheDouble = value
        case .userDefaults: _repository.userDefaultsDouble = value
        case .keychain: _repository.keychainDouble = value
        }
    }

    func saveBool(_ type: CacheType) {
        var value = fetchBool(type)
        if value == nil {
            value = true
        } else {
            value = !(value!)
        }
        switch type {
        case .disk: _repository.cacheBool = value
        case .userDefaults: _repository.userDefaultsBool = value
        case .keychain: _repository.keychainBool = value
        }
    }
}
