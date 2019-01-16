//
//  APBaseWebViewController.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/2.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SnapKit

open class APBaseWebViewController: APBaseViewController, UIScrollViewDelegate, APWKWebViewDelegate {
    
    open var rootViewBackgroundColor : UIColor = UIColor(hex6: 0xefeff4)
    open var webViewBackgroundColor : UIColor = UIColor.clear
    open var pannelTitleColor : UIColor = UIColor.gray
    open var backgroundTitleColor : UIColor = UIColor.darkGray
    open var bottomNavigationBarHeight : CGFloat = 50.0
    open var bottomNavigationBarButtonOffset : CGFloat = 60.0
    open var bottomNavigationBarButtonHeight : CGFloat = 40.0
    open var bottomNavigationBarButtonWidth : CGFloat = 40.0
    
    @objc
    open var url: String?

    open var bottomNavigationBarEnable: Bool = true {
        didSet {
            bottomNavigationBar?.snp.remakeConstraints({ (make) in
                make.left.right.bottom.equalTo(self.view)
                make.height.equalTo(bottomNavigationBarEnable ? bottomNavigationBarHeight : 0)
            })
        }
    }
    weak var _webView: APWKWebView?
    public var webView: APWKWebView {
        guard _webView == nil else {
            return _webView!
        }
        _webView = self.createWebView()
        _webView?.delegate = self
        return _webView!
    }
    
    open var bottomNavigationBar: UIView?
    open var bottomNavigationLeftButton: UIButton?
    open var bottomNavigationRightButton: UIButton?
    open var injectScript:String = ""
    
    private func createWebView() -> APWKWebView {
        let _webView = APWKWebView(frame: CGRect.zero, injectScript: injectScript)
        //声明scrollView的位置 添加下面代码
        if #available(iOS 11.0, *) {
            _webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        _webView.backgroundColor = webViewBackgroundColor
        _webView.scrollView.delegate = self
        self.view.addSubview(_webView)
        
        let bottomView = UIView(frame: CGRect.zero);
        bottomView.backgroundColor = UIColor.white
        self.view.addSubview(bottomView)
        
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(Bundle.apImage(named: "ap_arrow_left"), for: .normal)
        btnLeft.addTarget(self, action: #selector(APBaseWebViewController.click_bar_left(_:)), for: .touchUpInside)
        bottomView.addSubview(btnLeft)
        let btnRight = UIButton(type: .custom)
        btnRight.setImage(Bundle.apImage(named: "ap_arrow_right"), for: .normal)
        btnRight.addTarget(self, action: #selector(APBaseWebViewController.click_bar_right(_:)), for: .touchUpInside)
        bottomView.addSubview(btnRight)
        bottomView.clipsToBounds = true
        
        _webView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.left.right.top.equalTo(self.view)
            }
            make.bottom.equalTo(bottomView)
        }
        
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.left.right.bottom.equalTo(self.view)
            }
            make.height.equalTo(0)
        }
        btnLeft.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomView.snp.centerX).offset(-bottomNavigationBarButtonOffset)
            make.height.equalTo(bottomNavigationBarButtonHeight)
            make.width.equalTo(bottomNavigationBarButtonWidth)
        }
        btnRight.snp.makeConstraints { (make) in
            make.centerX.equalTo(bottomView.snp.centerX).offset(bottomNavigationBarButtonOffset)
            make.height.equalTo(bottomNavigationBarButtonHeight)
            make.width.equalTo(bottomNavigationBarButtonWidth)
        }
        self.bottomNavigationBar = bottomView
        self.bottomNavigationLeftButton = btnLeft
        self.bottomNavigationRightButton = btnRight
        
        return _webView
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    open override func setupUI() {
        super.setupUI()
        webView.refreshHeaderEnable = true
    }
    open override func loadData() {
        super.loadData()
        webView.request(url: url)
    }
    
    @objc open func click_bar_left(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    @objc open func click_bar_right(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    open func webView(_ webView: WKWebView, updateTitle: String?) {
        self.title = updateTitle
    }
    private var bottomNavigationBarShowed = false
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if bottomNavigationBarEnable {
            if webView.canGoBack && !bottomNavigationBarShowed {
                bottomNavigationBarShowed = true
                bottomNavigationBar?.snp.remakeConstraints({ (make) in
                    make.left.right.bottom.equalTo(self.view)
                    make.height.equalTo(bottomNavigationBarHeight)
                })
            }
            self.bottomNavigationLeftButton?.isEnabled = webView.canGoBack
            self.bottomNavigationRightButton?.isEnabled = webView.canGoForward
        }
    }
    
    //MARK : - ScrollViewDelegate
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.webView.recordWebView(offset: scrollView.contentOffset.y)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.webView.recordWebView(offset: scrollView.contentOffset.y)
    }
}
