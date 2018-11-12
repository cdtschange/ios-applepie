//
//  Dictionary+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == Dictionary<String, Any> {
    public var queryString: String {
        let parameterArray = base.map { (key, value) -> String in
            let pKey = key.ap.addingPercentEncodingForUrlQueryValue()
            var stringValue = ""
            switch value {
            case let intValue as Int: stringValue = intValue.ap.toString
            case let doubleValue as Double: stringValue = doubleValue.ap.toString
            case let boolValue as Bool: stringValue = boolValue.ap.toString
            default:
                stringValue = "\(value)"
            }
            let pValue = stringValue.ap.addingPercentEncodingForUrlQueryValue()
            return "\(pKey)=\(pValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}

public extension Applepie where Base == String {
    public var queryDictionary: [String: String] {
        var queryStrings = [String: String]()
        for pair in base.components(separatedBy: "&") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding!
            queryStrings[key] = value
        }
        return queryStrings
    }
}
