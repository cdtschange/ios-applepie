//
//  APWKWebView.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/2.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation
import UIKit
import WebViewJavascriptBridge
import CocoaLumberjack
import SnapKit
import MJRefresh

public protocol APWKWebViewDelegate: UIWebViewDelegate, WKNavigationDelegate {
    public func webView(_ webView: WKWebView, updateTitle: String?) -> Void
}
public extension APWKWebViewDelegate {
    public func webView(_ webView: WKWebView, updateTitle: String?) -> Void {}
}

open class APWKWebView: WKWebView, WKNavigationDelegate {
    
    struct InnerConst {
        static let WebViewBackgroundColor : UIColor = UIColor.clear
        static let keyPathForProgress : String = "estimatedProgress"
        static let keyPathForTitle : String = "title"
        static var webViewOffset: [String: CGFloat] = [:]
    }
    
    open var requestHeader: [String: String]?
    open var userAgent: String? {
        get {
            return self.customUserAgent
        }
        set(value) {
            self.customUserAgent = value
        }
    }
    
    open var delegate: APWKWebViewDelegate?
    open var urlString: String?
    open var shouldAllowRedirectToUrlInView: Bool = true
    open var userSelectEnable = true
    open var longTouchEnable = true
    open var rememberOffset: Bool = true
    open var responseCallback: WVJBResponseCallback?
    
    open var progressBarEnable: Bool = true {
        didSet {
            progressView.isHidden = !progressBarEnable
        }
    }
    open var refreshHeaderEnable: Bool = true {
        didSet{
            if refreshHeaderEnable {
                self.scrollView.mj_header = self.webViewWithRefreshingBlock { [weak self] in
                    self?.request(url: self?.urlString ?? "")
                }
            } else {
                self.scrollView.mj_header = nil
            }
        }
    }
    
    open lazy var webViewBridge: WKWebViewJavascriptBridge = {
        var bridge: WKWebViewJavascriptBridge = WKWebViewJavascriptBridge(for: self)
        bridge.setWebViewDelegate(self)
        return bridge
    }()
    open lazy var progressView: UIProgressView = {
        var progressView =  UIProgressView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0))
        progressView.trackTintColor = UIColor.clear
        self.addSubview(progressView)
        return progressView
    }()
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.setup()
    }
    public init(frame: CGRect, injectScript: String = "") {
        let wkContentVc = WKUserContentController()
        let cookieScript = WKUserScript(source: injectScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        wkContentVc.addUserScript(cookieScript)
        let config = WKWebViewConfiguration()
        config.userContentController = wkContentVc
        super.init(frame: frame, configuration: config)
        self.setup()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func setup(){
        self.backgroundColor = InnerConst.WebViewBackgroundColor
        self.navigationDelegate = self
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.addObserver(self, forKeyPath: InnerConst.keyPathForTitle, options: [NSKeyValueObservingOptions.new], context: nil)
        self.addObserver(self, forKeyPath: InnerConst.keyPathForProgress, options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old], context: nil)
   
        _ = self.webViewBridge
        bindEvents()
    }

    open func bindEvents() {
        /**
         *  H5给Native的单例或者静态变量赋值，
         *  不支持同时改变静态属性和成员变量。需要调用多次依次修改
         *  事件名: changeVariables
         *  参数：
         *       name:String    用.分割类名和单例变量名,例如: BaseService.sharedBaseService（.sharedBaseService为空时,表示修改静态属性）
         *       params:[String:Any] 要修改的参数列表 (注意：修改静态属性时params中的key一定是存在的静态属性，否则会奔溃，因为无法映射静态属性列表判断有无该属性)
         */
        self.bindEvent("changeVariables") { data, responseCallback in
            if let dict = data as? [String: Any] {
                if let name = dict["name"] as? String, let paramsDic = dict["params"] as? [String:Any], name.count > 0 {
                    let (className, instanceName): (String?, String?) = APWKWebView.splitFirstName(name)
                    guard let objcName = className, objcName.count > 0 else {
                        return
                    }
                    guard let instanceClass:NSObject.Type = NSObject.fullClassName(objcName) else { return }
                    if let instanceKey = instanceName, instanceKey.count > 0 {
                        //单例赋值
                        if let instance:NSObject = instanceClass.value(forKey: instanceKey) as? NSObject {
                            SwiftReflectionTool.setParams(paramsDic, for: instance)
                        }
                    }else {
                        //静态属性赋值
                        for (key,value) in paramsDic {
                            instanceClass.setValue(value, forKey: key)
                        }
                    }
                }
            }
        }
        
        self.bindEvent("goToSomewhere") { [weak self] data , responseCallback in
            if let dic = data as? [String:Any] {
                if let name = dic["name"] as? String , name.count > 0 {
                    //获得Controller名和Sb名
                    let (sbName, vcName): (String?, String?) = APWKWebView.splitFirstName(name)
                    if let vcName = vcName, vcName.count > 0  {
                        let pop = (dic["pop"] as? Bool) ?? false
                        let params = dic["params"] as? [String: Any]
                        self?.responseCallback = responseCallback
                        APRouter.route(toName: vcName, params: params ?? [:], storyboardName: sbName, animation: true, pop: pop)
                    }
                }
            }
        }
    }
    
    open func bindEvent(_ eventName: String, handler: @escaping WVJBHandler) {
        webViewBridge.registerHandler(eventName, handler: handler)
    }
    
    open func webViewWithRefreshingBlock(_ refreshingBlock: @escaping MJRefreshComponentRefreshingBlock) -> MJRefreshHeader{
        let header = MJRefreshNormalHeader(refreshingBlock:refreshingBlock);
        header?.activityIndicatorViewStyle = .gray
        header?.labelLeftInset = 0
        header?.setTitle("", for: .idle)
        header?.setTitle("", for: .pulling)
        header?.setTitle("", for: .refreshing)
        header?.lastUpdatedTimeLabel.text = ""
        header?.lastUpdatedTimeText = { _ in return "" }
        return header!
    }
    
    open func willLoadRequest(_ request: URLRequest) -> URLRequest {
        var request = request
        if let header = requestHeader {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    open func request(url: String?) {
        guard
            let urlString = url?.trimmingCharacters(in: .whitespaces), urlString.count > 0 ,
            let urlResult = URL(string: urlString), UIApplication.shared.canOpenURL(urlResult) else {
            DDLogError("Request Invalid Url: \(url ?? "")")
            return
        }
        DDLogInfo("Request url: \(urlString)")
        self.urlString = urlString
        //清除旧数据
        self.evaluateJavaScript("document.body.innerHTML='';") { [weak self] _,_ in
            let request = URLRequest(url: urlResult)
            if let request = self?.willLoadRequest(request) {
                self?.load(request)
            }
        }
    }
    
    /** 计算进度条 */
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ((object as AnyObject).isEqual(self) && ((keyPath ?? "") == InnerConst.keyPathForProgress)) {
            guard progressBarEnable == true else { return }
            let newProgress = (change?[NSKeyValueChangeKey.newKey] as AnyObject).floatValue ?? 0
            let oldProgress = (change?[NSKeyValueChangeKey.oldKey] as AnyObject).floatValue ?? 0
            if newProgress < oldProgress {
                return
            }
            if newProgress >= 1 {
                DispatchQueue.main.async { [weak self] in
                    self?.progressView.isHidden = true
                    self?.progressView.setProgress(0, animated: false)
                }
                
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.progressView.isHidden = false
                    self?.progressView.setProgress(newProgress, animated: true)
                }
            }
        } else if ((object as AnyObject).isEqual(self) && ((keyPath ?? "") == InnerConst.keyPathForTitle)) {
            delegate?.webView(self, updateTitle: self.title)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: - Delegate
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void){
        //存储返回的cookie
        if let response = navigationResponse.response as? HTTPURLResponse, let url = response.url{
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: (response.allHeaderFields as? [String : String]) ?? [:] , for: url)
            for cookie in cookies {
                //DDLogInfo("保存的ResponseCookie Name:\(cookie.name)   value:\(cookie.value)")
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
        urlString = webView.url?.absoluteString
        delegate?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
        decisionHandler(.allow)
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var ret = true
        let urlStr = navigationAction.request.url?.absoluteString.removingPercentEncoding
        
        if shouldAllowRedirectToUrlInView {
            DDLogInfo("Web view direct to url: \(urlStr ?? "")")
            ret = true
        } else {
            DDLogWarn("Web view direct to url forbidden: \(urlStr ?? "")")
            ret = false
        }
        //1.0 判断是不是打开App Store
        if urlStr?.hasPrefix("itms-appss://") == true || urlStr?.hasPrefix("itms-apps://") == true {
            if let url = navigationAction.request.url {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                ret = false
            }
        } else if urlStr?.hasPrefix("http") == false && urlStr?.hasPrefix("https") == false { // 2.0 判断是不是打开其他app，例如支付宝
            if let url = navigationAction.request.url {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                ret = false
            }
        }
        //2.0 Cookie
        //获得cookie
        var cookStr = ""
        if let cookies =  HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                cookStr += "document.cookie = '\(cookie.name)=\(cookie.value);domain=\(cookie.domain);sessionOnly=\(cookie.isSessionOnly);path=\(cookie.path);isSecure=\(cookie.isSecure)';"
            }
        }
        //设置cookie
        if cookStr.count > 0 {
            let sc = WKUserScript(source: cookStr, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(sc)
        }
        if (navigationAction.targetFrame == nil) { //新窗口打不开的bug
            webView.load(navigationAction.request)
        }
        delegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        decisionHandler(ret ? .allow : .cancel)
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let header = self.scrollView.mj_header {
            header.endRefreshing()//结束下拉刷新
        }
        if !userSelectEnable {
            self.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';") {_,_ in}
        }
        if !longTouchEnable {
            self.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';") {_,_ in}
        }
        if rememberOffset {
            if let url = urlString, let offset = InnerConst.webViewOffset[url] {
                webView.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
            }
        }
        delegate?.webView?(webView, didFinish: navigation)
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.webView?(webView, didFail: navigation, withError: error)
    }
    
    public func recordWebView(offset: CGFloat) {
        guard urlString != nil else { return }
        InnerConst.webViewOffset[urlString!] = offset
    }
    
    private class func splitFirstName(_ name: String) -> (String?, String?) {
        let nameList = name.split(separator: ".")
        var className: String?
        var instanceName: String?
        if nameList.count >= 2 {
            className = String(nameList[0])
            instanceName = String(nameList[1])
        }else if nameList.count == 1 {
            className = String(nameList[0])
        }
        return (className, instanceName)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: InnerConst.keyPathForProgress)
        self.removeObserver(self, forKeyPath: InnerConst.keyPathForTitle)
    }
    
}
