//
//  APNetIndicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack

public class APNetIndicatorClient {
    
    public struct IndicatorModel {
        public var api: APNetApi
        public weak var indicator: APIndicatorProtocol?
        public weak var view: UIView?
        public var text: String?
        public var task: URLSessionTask?
    }
    
    public static var indicators: [String: IndicatorModel] = [:]
    
    public static func getIndicatorModel(identifier: String) -> IndicatorModel? {
        return indicators[identifier]
    }
    public static func remove(indicator: APIndicatorProtocol) {
        let models = indicators.filter { (key, value) in value.indicator === indicator }
        for (_, value) in models {
            if let task = value.task {
                task.cancel()
                DDLogVerbose("[AP][NetIndicator] Cancel task: \(task.taskIdentifier)")
            }
        }
    }
    
    public static func add(api: APNetApi, indicator: APIndicatorProtocol?, view: UIView?, text: String?) {
        DDLogDebug("[AP][NetIndicator][+][\(indicators.count)] \(api)")
        indicators[api.identifier] = IndicatorModel(api: api, indicator: indicator, view: view, text: text, task: nil)
    }
    public static func remove(api: APNetApi) {
        if let _ = indicators.removeValue(forKey: api.identifier) {
            DDLogDebug("[AP][NetIndicator][-][\(indicators.count)] \(api)")
        }
    }
    public static func bind(api: APNetApi, task: URLSessionTask) {
        if var model = indicators[api.identifier] {
            model.task = task
            indicators[api.identifier] = model
            model.indicator?.registerNotification(identifier: api.identifier)
        }
    }
    
    
}

public extension APIndicatorProtocol {
    func registerNotification(identifier: String) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        notificationCenter.addObserver(forName: Notification.Name.Task.DidResume, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator resume")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.show(inView: model.view, text: model.text, detailText: nil, animated: true)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidSuspend, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator suspend")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.hide(inView: model.view, animated: true)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidCancel, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator cancel")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.hide(inView: model.view, animated: true)
                APNetIndicatorClient.remove(api: model.api)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidComplete, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator complete")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicatorClient.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.hide(inView: model.view, animated: true)
                APNetIndicatorClient.remove(api: model.api)
            }
        }
    }
}
