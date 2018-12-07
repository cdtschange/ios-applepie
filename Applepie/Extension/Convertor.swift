//
//  Convertor.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == Int {
    public var toFloat: Float { return Float(base) }
    public var toDouble: Double { return Double(base) }
    public var toString: String { return String(base) }
    public var toFormattedBytes: String {
        return Int64(base).ap.toFormattedBytes
    }
}

public extension Applepie where Base == Int64 {
    public var toFormattedBytes: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useTB, .useGB, .useMB, .useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: base)
    }
}

public extension Applepie where Base == Double {
    public var toFloat: Float { return Float(base) }
    public var toInt: Int { return Int(base) }
    public var toString: String { return String(base) }
}

public extension Applepie where Base == Bool {
    public var toString: String { return base ? "true" : "false" }
}
