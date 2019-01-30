//
//  WebBridgeViewController.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

class WebBridgeViewController: BaseWebViewController {

    override func setupUI() {
        super.setupUI()
        webView.refreshHeaderEnable = false
        
    }
    override func setupBinding() {
        super.setupBinding()
        webView.bindEvent("jsCallNative") { data, callback in
            callback?("Response from native.")
        }
        webView.bindEvent("showTip") { [weak self] data, callback in
            if let content = (data as? [String: Any])?["content"] as? String {
                self?.showTip(content)
            }
            callback?("Response from native.")
        }
        webView.bindEvent("routeBack") { _, _ in
            APRouter.routeBack()
        }
    }
    override func loadData() {
        let path = Bundle.main.path(forResource: "webview_bridge", ofType: "html")
        let contents = try? String(contentsOfFile: path!, encoding: .utf8)
        webView.loadHTMLString(contents!, baseURL: nil)
    }

}
