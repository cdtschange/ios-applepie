//
//  APNetIndicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack
import Alamofire

public class APNetIndicatorClient {
    
    public struct IndicatorModel {
        public var api: APNetApi
        public weak var indicator: APIndicatorProtocol?
        public weak var view: UIView?
        public var text: String?
        public var request: Request?
    }
    
    public static var indicators: [String: IndicatorModel] = [:]
    
    public static func getIndicatorModel(identifier: String) -> IndicatorModel? {
        return indicators[identifier]
    }
    public static func remove(indicator: APIndicatorProtocol) {
        let models = indicators.filter { (key, value) in value.indicator === indicator }
        for (_, value) in models {
            if let request = value.request {
                request.cancel()
                DDLogVerbose("[AP][NetIndicator] Cancel request: \(request.id)")
            }
        }
    }
    
    public static func add(api: APNetApi, indicator: APIndicatorProtocol?, view: UIView?, text: String?) {
        DDLogDebug("[AP][NetIndicator][+][\(indicators.count)] \(api)")
        indicators[api.identifier] = IndicatorModel(api: api, indicator: indicator, view: view, text: text, request: nil)
    }
    public static func remove(api: APNetApi) {
        if let model = indicators.removeValue(forKey: api.identifier) {
            model.indicator?.hide(inView: model.view, animated: true)
            DDLogDebug("[AP][NetIndicator][-][\(indicators.count)] \(api)")
        }
    }
    public static func bind(api: APNetApi, request: Request, show: Bool = true) {
        if var model = indicators[api.identifier] {
            model.request = request
            indicators[api.identifier] = model
            model.indicator?.registerNotification(identifier: api.identifier)
            if show {
                model.indicator?.show(inView: model.view, text: model.text, detailText: nil, animated: true)
            }
        }
    }
    
    
}

public extension APIndicatorProtocol {
    func registerNotification(identifier: String) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        notificationCenter.addObserver(forName: Request.didResumeNotification, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator resume")
            if let request = notify.request {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.request == request else { return }
                model.indicator?.show(inView: model.view, text: model.text, detailText: nil, animated: true)
            }
        }
        notificationCenter.addObserver(forName: Request.didSuspendNotification, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator suspend")
            if let request = notify.request {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.request == request else { return }
                model.indicator?.hide(inView: model.view, animated: true)
            }
        }
        notificationCenter.addObserver(forName: Request.didCancelNotification, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator cancel")
            if let request = notify.request {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.request == request else { return }
                APNetIndicatorClient.remove(api: model.api)
            }
        }
        notificationCenter.addObserver(forName: Request.didCompleteTaskNotification, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator complete")
            if let request = notify.request {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.request == request else { return }
                APNetIndicatorClient.remove(api: model.api)
            }
        }
    }
}
