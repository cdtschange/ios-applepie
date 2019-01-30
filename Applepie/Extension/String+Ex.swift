//
//  String+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == String {
    public func addingPercentEncodingForUrlQueryValue() -> String {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return base.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!
    }
    
    // Localized
    public var localized: String {
        return NSLocalizedString(base, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    public func localized(withComment:String) -> String {
        return NSLocalizedString(base, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    public func localized(tableName: String) -> String{
        return NSLocalizedString(base, tableName: tableName, bundle: Bundle.main, value: "", comment: "")
    }
    
    public func attributedString(withFont font: UIFont, lineSpacing: CGFloat, alignment: NSTextAlignment? = .left, textColor: UIColor? = nil) -> NSMutableAttributedString {
        guard base.count > 0 else { return NSMutableAttributedString() }
        
        var attributes:[NSAttributedString.Key : Any] = [.font:font]
        if let textColor =  textColor {
            attributes[.foregroundColor] = textColor
        }
        let attributedString = NSMutableAttributedString(string: base,
                                                         attributes:attributes)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment ?? .left
        attributedString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    public func calculateHeight(withWidth width: CGFloat) -> CGFloat {
        let options: NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading]
        let size = base.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: options,
                                     context: nil)
        return size.height
    }
}
