//
//  NSObject+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/13.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension NSObject {
    ///  获取完整的类名
    static func fullClassName(_ className : String) -> NSObject.Type? {
        let className = (Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "") + "." + className
        let fullName = NSClassFromString(className) as? NSObject.Type
        return fullName
    }
    
    static func fromClassName(_ className : String) -> NSObject? {
        let type = NSClassFromString(className) as? NSObject.Type
        if let obj = type?.init() {
            return obj
        }
        return fullClassName(className)?.init()
    }
}
