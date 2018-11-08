//
//  Operator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>)
    -> Dictionary<K, V> {
        return left.merging(right, uniquingKeysWith: { v1, v2 in v2})
}
public func + <K, V>(left: Dictionary<K, V>?, right: Dictionary<K, V>?)
    -> Dictionary<K, V> {
        return (left ?? [:]) + (right ?? [:])
}
public func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>?)
    -> Dictionary<K, V> {
        return left + (right ?? [:])
}
public func + <K, V>(left: Dictionary<K, V>?, right: Dictionary<K, V>)
    -> Dictionary<K, V> {
        return (left ?? [:]) + right
}

public func += <K, V> (left: inout Dictionary<K, V>, right: Dictionary<K, V>) {
    left.merge(right, uniquingKeysWith: { v1, v2 in v2})
}
