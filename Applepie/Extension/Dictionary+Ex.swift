//
//  Dictionary+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == Dictionary<String, Any> {
    public func toHttpQueryString() -> String {
        let parameterArray = base.map { (key, value) -> String in
            let pKey = key.ap.addingPercentEncodingForUrlQueryValue()!
            var stringValue = ""
            switch value {
            case let intValue as Int: stringValue = intValue.ap.toString
            case let doubleValue as Double: stringValue = doubleValue.ap.toString
            case let boolValue as Bool: stringValue = boolValue.ap.toString
            default:
                stringValue = "\(value)"
            }
            let pValue = stringValue.ap.addingPercentEncodingForUrlQueryValue() ?? ""
            return "\(pKey)=\(pValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
    
    public func toModel<T>(_ type: T.Type) -> T? where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
