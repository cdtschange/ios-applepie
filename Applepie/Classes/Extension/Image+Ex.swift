//
//  Image+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/3/27.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == Image {
    func toBase64() -> String {
        return base.pngData()!.base64EncodedString()
    }
}
public extension Applepie where Base == String {
    func base64ToImage() -> Image? {
        if let decodedData = Data(base64Encoded: base, options: .ignoreUnknownCharacters) {
            return UIImage(data: decodedData)
        }
        return nil
    }
}
