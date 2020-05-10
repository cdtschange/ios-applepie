//
//  Bundle+Resource.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public class APBundle: Bundle {
    
    public static let resourceBundle: Bundle = Bundle(url: Bundle(for: APBundle.self).url(forResource: "Applepie", withExtension: "bundle")!)!
}
