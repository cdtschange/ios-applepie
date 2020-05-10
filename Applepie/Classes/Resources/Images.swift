//
//  Bundle+Resource.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public enum APImages: String {
    case arrowLeft = "ap_arrow_left"
    case arrowRight = "ap_arrow_right"
    
    public var image: UIImage? {
        UIImage(named: self.rawValue, in: APBundle.resourceBundle, compatibleWith: nil)
    }
}
