//
//  APKeychain.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/7.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Valet

public struct APKeychain {
    
    var valet: Valet
    
    public init(identifier: String) {
        self.init(identifier: identifier, accessibility: .whenUnlocked)
    }
    public init(identifier: String, accessibility: Accessibility) {
        valet = Valet.valet(with: Identifier(nonEmpty: identifier)!, accessibility: accessibility)
    }
    @discardableResult
    public func removeObject(forKey key: String) -> Bool {
        return valet.removeObject(forKey: key)
    }
    public func string(forKey key: String) -> String? {
        return valet.string(forKey: key)
    }
    @discardableResult
    public func set(string: String?, forKey key: String) -> Bool {
        guard let string = string else {
            removeObject(forKey: key)
            return true
        }
        return valet.set(string: string, forKey: key)
    }
}
