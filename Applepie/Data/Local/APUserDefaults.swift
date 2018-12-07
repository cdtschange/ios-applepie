//
//  APUserDefaults.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public struct APUserDefaults {
    public static func object(forKey key: String) -> Any? {
        return Defaults.object(forKey: key)
    }
    public static func setObject(_ object: Any?, forKey key: String) {
        guard let obj = object else {
            removeObject(forKey: key)
            return
        }
        return Defaults.set(obj, forKey: key)
    }
    public static func removeObject(forKey key: String) {
        Defaults.removeObject(forKey: key)
    }
}
