//
//  APIndicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/1.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import UIKit

public enum APIndicatorStatus {
    case standby, running, stop
}

public protocol APIndicatorProtocol: class {
    var apiIdentifiers: [String] { get set }
    var showing: Bool { get set }
    func turn(status: APIndicatorStatus, view: UIView?, text: String?)
    func show(inView view: UIView, text: String?, detailText: String?, animated: Bool)
    func hide(inView view: UIView, animated: Bool)
}

public class APSingleIndicator: APIndicatorProtocol {
    public var apiIdentifiers: [String] = []
    public var showing: Bool = false
    
    public func show(inView view: UIView, text: String?, detailText: String?, animated: Bool) {
        
    }
    public func hide(inView view: UIView, animated: Bool) {
        
    }
    
    public func turn(status: APIndicatorStatus, view: UIView?, text: String?) {
        switch status {
        case .running:
            UIApplication.shared.ap.setNetworkActivityIndicator(show: true)
            guard let view = view else { return }
            showing = true
            Async.main {
                self.show(inView: view, text: text, detailText: nil, animated: false)
            }
        case .stop:
            UIApplication.shared.ap.setNetworkActivityIndicator(show: false)
            guard let view = view else { return }
            self.showing = false
            Async.main {
                self.hide(inView: view, animated: false)
            }
        default:
            break
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        APNetIndicator.removeIndicator(indicator: self)
    }
}

public class APListIndicator: APIndicatorProtocol {
    public var apiIdentifiers: [String] = []
    public var showing: Bool = false
    
    public func show(inView view: UIView, text: String?, detailText: String?, animated: Bool) {}
    public func hide(inView view: UIView, animated: Bool) {}
    
    public func turn(status: APIndicatorStatus, view: UIView?, text: String?) {
        switch status {
        case .running:
            UIApplication.shared.ap.setNetworkActivityIndicator(show: true)
        case .stop:
            UIApplication.shared.ap.setNetworkActivityIndicator(show: false)
            //TODO: Fix
//            Async.main { [weak self] in
//                self?.viewController?.endListRefresh()
//            }
        default:
            break
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        APNetIndicator.removeIndicator(indicator: self)
    }
}
