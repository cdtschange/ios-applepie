//
//  APIndicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/1.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

public protocol APIndicatorProtocol: class {
    var showing: Bool { get set }
    func show(inView view: UIView?, text: String?, detailText: String?, animated: Bool)
    func hide(inView view: UIView?, animated: Bool)
}

public class APIndicator: APIndicatorProtocol {
    public var showing: Bool = false
    private var hud: MBProgressHUD?
    
    public init() {}
    
    public func show(inView view: UIView?, text: String?, detailText: String?, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: true)
        showing = true
        DispatchQueue.main.async { [weak self] in
            guard view != nil else { return }
            let hud = MBProgressHUD.showAdded(to: view!, animated: animated)
            hud.mode = .indeterminate
            if let text = text {
                hud.label.text = text
            }
            if let detailText = detailText {
                hud.detailsLabel.text = detailText
            }
            self?.hud = hud
        }
    }
    public func hide(inView view: UIView?, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: false)
        self.showing = false
        DispatchQueue.main.async { [weak self] in
            if let hud = self?.hud {
                hud.hide(animated: animated)
                self?.hud = nil
            } else {
                guard view != nil else { return }
                MBProgressHUD.hide(for: view!, animated: animated)
            }
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        APNetIndicatorClient.remove(indicator: self)
    }
}
