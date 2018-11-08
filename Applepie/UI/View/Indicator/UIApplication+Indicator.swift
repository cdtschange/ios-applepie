//
//  UIApplication+Indicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/1.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension UIApplication {
    
    private struct UIApplicationConstant {
        static var indicatorCountAssociatedKey = "indicatorCount"
    }
    
    public var indicatorCount : Int {
        get {
            guard let number = objc_getAssociatedObject(self, &UIApplicationConstant.indicatorCountAssociatedKey) as? NSNumber else {
                return 0
            }
            return number.intValue
        }
        
        set(value) {
            objc_setAssociatedObject(self,&UIApplicationConstant.indicatorCountAssociatedKey,NSNumber(value: value),objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension Applepie where Base == UIApplication {
    
    private struct UIApplicationConstant {
        static var queueName = "com.applepie.LockQueue"
    }
    
    public func setNetworkActivityIndicator(show: Bool) {
        let lockQueue = DispatchQueue(label: UIApplicationConstant.queueName, attributes: [])
        lockQueue.sync {
            if show {
                if base.indicatorCount == 0 {
                    base.indicatorCount += 1
                    Async.main { [weak self] in
                        self?.base.isNetworkActivityIndicatorVisible = true
                    }
                } else {
                    base.indicatorCount += 1
                }
            } else {
                base.indicatorCount -= 1
                if base.indicatorCount <= 0 {
                    base.indicatorCount = 0
                    Async.main { [weak self] in
                        self?.base.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
}

