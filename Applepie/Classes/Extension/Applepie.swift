//
//  Applepie.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/26.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import ImageIO
import UIKit

#if os(macOS)
import AppKit
public typealias Image = NSImage
public typealias View = NSView
public typealias Color = NSColor
public typealias ImageView = NSImageView
public typealias Button = NSButton
#else
import UIKit
public typealias Image = UIImage
public typealias Color = UIColor
#if !os(watchOS)
public typealias ImageView = UIImageView
public typealias View = UIView
public typealias Button = UIButton
#else
import WatchKit
#endif
#endif

public final class Applepie<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/**
 A type that has Applepie extensions.
 */
public protocol ApplepieCompatible {
    associatedtype CompatibleType
    var ap: CompatibleType { get }
}

public extension ApplepieCompatible {
    var ap: Applepie<Self> {
        return Applepie(self)
    }
}

extension Int: ApplepieCompatible { }
extension Int64: ApplepieCompatible { }
extension Double: ApplepieCompatible { }
extension Bool: ApplepieCompatible { }
extension Dictionary: ApplepieCompatible { }
extension Array: ApplepieCompatible { }
extension Image: ApplepieCompatible { }
extension String: ApplepieCompatible { }
extension NSAttributedString: ApplepieCompatible { }
extension Date: ApplepieCompatible { }
extension Data: ApplepieCompatible { }
extension UIViewController: ApplepieCompatible { }
extension UIApplication: ApplepieCompatible { }
extension ImageView: ApplepieCompatible { }
extension Button: ApplepieCompatible { }
extension UIColor: ApplepieCompatible { }
