//
//  Convertor.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == Int {
    var toFloat: Float { return Float(base) }
    var toDouble: Double { return Double(base) }
    var toString: String { return String(base) }
    var toFormattedBytes: String {
        return Int64(base).ap.toFormattedBytes
    }
}

public extension Applepie where Base == Int64 {
    var toFormattedBytes: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useTB, .useGB, .useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: base)
    }
}

public extension Applepie where Base == Double {
    var toFloat: Float { return Float(base) }
    var toInt: Int { return Int(base) }
    var toString: String { return String(base) }
}

public extension Applepie where Base == Bool {
    var toString: String { return base ? "true" : "false" }
}


public extension Applepie where Base == String {
    var toInt: Int? { return NumberFormatter().number(from: base)?.intValue }
    var toDouble: Double? { return NumberFormatter().number(from: base)?.doubleValue }
    var toFloat: Float? { return NumberFormatter().number(from: base)?.floatValue }
    var toBool: Bool? {
        let trimmedString = base.ap.trim().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    func trim() -> String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
