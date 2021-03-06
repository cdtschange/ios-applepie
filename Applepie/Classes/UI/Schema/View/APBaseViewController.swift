//
//  APBaseViewController.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2018/12/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import UIKit
import CocoaLumberjack
import PromiseKit

open class APBaseViewController: UIViewController, APRouterProtocol {

    open var params = [String: Any]() {
        didSet {
            self.setValuesForKeys(params)
        }
    }
    
    open var viewModel: APBaseViewModel? {
        get { return nil }
    }
    
    open var indicator: APIndicatorProtocol? {
        get { return nil }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupUI()
        setupNotification()
        setupBinding()
    }
    
    open func setupUI() {
    }
    open func setupNotification() {
    }
    open func setupNavigation() {
    }
    open func setupBinding() {
    }
    open func loadData() {
        
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        if var bvc = vc as? APRouterProtocol {
            if let dict = sender as? [String: Any] {
                if var params = dict["params"] as? [String: Any] {
                    if params["hidesBottomBarWhenPushed"] == nil {
                        params["hidesBottomBarWhenPushed"] = true
                    }
                    bvc.params = params
                }
            }
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    open func showIndicator() {
        indicator?.show(inView: view, text: nil, detailText: nil, animated: true)
    }
    open func hideIndicator() {
        indicator?.hide(inView: view, animated: true)
    }
    open func showTip(_ error: Error, completion: @escaping () -> Void = {}) {
        switch error {
        case let error as APError:
            showTip(error.message, completion: completion)
        default:
            showTip("未知错误", completion: completion)
        }
    }
    open func showTip(_ tip: String, completion: @escaping () -> Void = {}) {
        (indicator as? APIndicator)?.showTip(inView: view, text: tip, detailText: nil, animated: true, hideAfter: 2, completion: completion)
    }
    open var showIndicatorPromise: Promise<Void> {
        return Promise { [unowned self] sink in
            self.showIndicator()
            sink.fulfill(())
        }
    }
    
    deinit {
        DDLogError("Deinit: \(NSStringFromClass(type(of: self)))")
        NotificationCenter.default.removeObserver(self)
    }
}
