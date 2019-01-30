//
//  NSAttributedString+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == NSAttributedString {
    public func calculateHeight(withWidth width: CGFloat) -> CGFloat {
        let options: NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading]
        let size = base.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: options,
                                     context: nil)
        return size.height
    }
}

public extension Applepie where Base == NSMutableAttributedString {
    public func calculateHeight(withWidth width: CGFloat) -> CGFloat {
        return (base as NSAttributedString).ap.calculateHeight(withWidth: width)
    }
}
