//
//  APNetIndicator.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack

public class APNetIndicator {
    
    public struct IndicatorModel {
        var api: APNetApi
        var indicator: APIndicatorProtocol?
        var view: UIView?
        var text: String?
        var task: URLSessionTask?
    }
    
    private static var indicators: [String: IndicatorModel] = [:]
    
    public static func getIndicatorModel(identifier: String) -> IndicatorModel? {
        return indicators[identifier]
    }
    public static func removeIndicator(indicator: APIndicatorProtocol) {
        let models = indicators.filter { (key, value) in indicator.apiIdentifiers.contains(key) }
        for (key, value) in models {
            if let task = value.task {
                task.cancel()
                DDLogVerbose("[AP][NetIndicator] Cancel task: \(task.taskIdentifier)")
            }
            indicators.removeValue(forKey: key)
            DDLogDebug("[AP][NetIndicator][-][\(indicators.count)] \(value.api)")
        }
    }
    
    public static func add(api: APNetApi, indicator: APIndicatorProtocol?, view: UIView?, text: String?) {
        DDLogDebug("[AP][NetIndicator][+][\(indicators.count)] \(api)")
        indicator?.apiIdentifiers.append(api.identifier)
        indicators[api.identifier] = IndicatorModel(api: api, indicator: indicator, view: view, text: text, task: nil)
    }
    public static func remove(api: APNetApi) {
        if let model = indicators.removeValue(forKey: api.identifier) {
            model.indicator?.apiIdentifiers.removeAll(where: { v in v == api.identifier })
            DDLogDebug("[AP][NetIndicator][-][\(indicators.count)] \(api)")
        }
    }
    public static func bindTask(api: APNetApi, task: URLSessionTask) {
        if var model = indicators[api.identifier] {
            model.task = task
            indicators[api.identifier] = model
            model.indicator?.registerNotification(identifier: api.identifier)
        }
    }
    
    
}

public extension APIndicatorProtocol {
    public func registerNotification(identifier: String) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        notificationCenter.addObserver(forName: Notification.Name.Task.DidResume, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator resume")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.show(inView: model.view, text: model.text, detailText: nil, animated: true)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidSuspend, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator suspend")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.hide(inView: model.view, animated: true)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidCancel, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator cancel")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.hide(inView: model.view, animated: true)
                APNetIndicator.remove(api: model.api)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidComplete, object: nil, queue: nil) { (notify) in
            DDLogVerbose("Task Indicator complete")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.getIndicatorModel(identifier: identifier), model.task == task else { return }
                model.indicator?.hide(inView: model.view, animated: true)
                APNetIndicator.remove(api: model.api)
            }
        }
    }
}
