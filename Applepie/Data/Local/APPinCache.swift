//
//  APDiskCache.swift
//  Applepie
//
//  Created by 毛蔚 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import PINCache

public struct APPinCache {
    public static func object(forKey key: String) -> Any? {
        return PINCache.shared.object(forKey: key)
    }
    public static func setObject(_ object: Any?, forKey key: String) {
        guard let obj = object else {
            removeObject(forKey: key)
            return
        }
        return PINCache.shared.setObject(obj, forKey: key)
    }
    public static func containsObject(forKey key: String) -> Bool {
        return PINCache.shared.containsObject(forKey: key)
    }
    public static func removeObject(forKey key: String) {
        PINCache.shared.removeObject(forKey: key)
    }
    public static func removeAllObjects() {
        PINCache.shared.removeAllObjects()
    }
}
