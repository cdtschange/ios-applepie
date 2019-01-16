//
//  Bundle+Resource.swift
//  Applepie
//
//  Created by 毛蔚 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public class APBundle: NSObject {}

public extension Bundle {
    
    public static func apImage(named: String) -> UIImage? {
        if let path = Bundle.apBundle()?.path(forResource: named, ofType: "png") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
    
    public static func apBundle() -> Bundle? {
        if let path = Bundle(for: APBundle.self).path(forResource: "Applepie", ofType: "bundle") {
            return Bundle(path: path)
        }
        return nil
    }
}