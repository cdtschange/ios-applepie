//
//  Operator.swift
//  Applepie
//
//  Created by 毛蔚 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public func + <K, V>(left: Dictionary<K, V>, right: Dictionary<K, V>)
    -> Dictionary<K, V> {
        var map = Dictionary<K, V>()
        for (k, v) in left {
            map[k] = v
        }
        for (k, v) in right {
            map[k] = v
        }
        return map
}

func += <K, V> (left: inout Dictionary<K, V>, right: Dictionary<K, V>) {
    for (k, v) in right {
        left[k] = v
    }
}
