//
//  SimpleWebViewController.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit

class SimpleWebViewController: BaseWebViewController {

    
    override func setupUI() {
        super.setupUI()
        webView.refreshHeaderEnable = false

    }
    override func loadData() {
        let path = Bundle.main.path(forResource: "webview_simple", ofType: "html")
        let contents = try? String(contentsOfFile: path!, encoding: .utf8)
        webView.loadHTMLString(contents!, baseURL: nil)
    }
}
