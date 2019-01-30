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
import PromiseKit

public protocol APIndicatorProtocol: class {
    var showing: Bool { get set }
    func show(inView view: UIView?, text: String?, detailText: String?, animated: Bool)
    func hide(inView view: UIView?, animated: Bool)
}

public class APIndicator: APIndicatorProtocol {
    public var showing: Bool = false
    private var hud: MBProgressHUD?
    
    public init() {}
    
    public func showTip(inView view: UIView?, text: String?, detailText: String?, animated: Bool, hideAfter: Int, completion: @escaping () -> Void = {}) {
        showTip(inView: view, text: text, detailText: detailText, image: nil, offset: nil, animated: animated, hideAfter: hideAfter, completion: completion)
    }
    public func showTip(inView view: UIView?, text: String?, detailText: String?, image: UIImage?, offset: CGPoint?, animated: Bool, hideAfter: Int, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            guard view != nil else { return }
            MBProgressHUD.hide(for: view!, animated: false)
            let hud = MBProgressHUD.showAdded(to: view!, animated: animated)
            hud.mode = .text
            if let text = text {
                hud.label.text = text
            }
            if let detailText = detailText {
                hud.detailsLabel.text = detailText
            }
            if let image = image {
                hud.mode = .customView;
                hud.customView = UIImageView(image: image)
            }
            if let offset = offset {
                hud.offset = offset
            }
            after(.seconds(hideAfter)).done {
                hud.hide(animated: animated)
                completion()
            }
        }
    }
    
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
    
    public func showProgress(inView view: UIView?, text: String?, detailText: String?, cancelable: Bool, cancelTitle: String?, cancelHandler: (() -> Void)?, type: APIndicatorType, animated: Bool) {
        UIApplication.shared.ap.setNetworkActivityIndicator(show: true)
        showing = true
        DispatchQueue.main.async { [weak self] in
            guard view != nil else { return }
            let hud = MBProgressHUD.showAdded(to: view!, animated: animated)
            hud.mode = type.toHudType()
            if let text = text {
                hud.label.text = text
            }
            if let detailText = detailText {
                hud.detailsLabel.text = detailText
            }
            if cancelable {
                let progressObject = Progress(totalUnitCount: 100)
                progressObject.cancellationHandler = { [weak self] in
                    self?.hide(inView: view, animated: animated)
                    cancelHandler?()
                }
                hud.progressObject = progressObject
                if let title = cancelTitle {
                    hud.button.setTitle(title, for: .normal)
                    hud.button.addTarget(progressObject, action: #selector(Progress.cancel), for: .touchUpInside)
                } else {
                    hud.button.removeTarget(nil, action: nil, for: .allEvents)
                }
            }
            self?.hud = hud
        }
    }
    public func changeProgress(inView view: UIView?, text: String?, detailText: String?, _ progress: Double, animated: Bool) {
        if let progressObject = self.hud?.progressObject {
            let increase = Int64((progress - progressObject.fractionCompleted) * 100)
            progressObject.becomeCurrent(withPendingUnitCount: increase)
            progressObject.resignCurrent()
        } else {
            self.hud?.progress = Float(progress)
        }
        if let text = text {
            self.hud?.label.text = text
        }
        if let detailText = detailText {
            self.hud?.detailsLabel.text = detailText
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        APNetIndicatorClient.remove(indicator: self)
    }
}



public enum APIndicatorType {
    case indeterminate, determinate, determinateHorizontalBar, annularDeterminate, customView, text
    
    func toHudType() -> MBProgressHUDMode {
        switch self {
        case .indeterminate: return .indeterminate
        case .determinate: return .determinate
        case .determinateHorizontalBar: return .determinateHorizontalBar
        case .annularDeterminate: return .annularDeterminate
        case .customView: return .customView
        case .text: return .text
        }
    }
}
