//
//  APIndicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/1.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import UIKit

public protocol APIndicatorProtocol: class {
    var showing: Bool { get set }
    func show(inView view: UIView?, text: String?, detailText: String?, animated: Bool)
    func hide(inView view: UIView?, animated: Bool)
}

public class APSingleIndicator: APIndicatorProtocol {
    public var showing: Bool = false
    
    public init() {}
    
    public func show(inView view: UIView?, text: String?, detailText: String?, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: true)
        showing = true
        Async.main {
//            self.show(inView: view, text: text, detailText: nil, animated: false)
        }
    }
    public func hide(inView view: UIView?, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: false)
        self.showing = false
        Async.main {
//            self.hide(inView: view, animated: false)
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        APNetIndicatorClient.remove(indicator: self)
    }
}

public class APListIndicator: APIndicatorProtocol {
    public var showing: Bool = false
    
    public init() {}
    
    public func show(inView view: UIView?, text: String?, detailText: String?, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: true)
        showing = true
    }
    public func hide(inView view: UIView?, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: false)
        self.showing = false
        //TODO: Fix
        //            Async.main { [weak self] in
        //                self?.viewController?.endListRefresh()
        //            }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        APNetIndicatorClient.remove(indicator: self)
    }
}
