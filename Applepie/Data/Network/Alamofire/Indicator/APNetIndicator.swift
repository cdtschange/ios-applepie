//
//  APNetIndicator.swift
//  Applepie
//
//  Created by 毛蔚 on 2018/10/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack

public enum APNetIndicatorStatus {
    case standby, running, stop
}

public protocol APNetIndicatorProtocol {
    
}

public class APNetIndicator: APNetIndicatorProtocol {
    
    public struct IndicatorModel {
        var api: APNetApi
        var indicator: APNetIndicator?
        var view: UIView?
        var text: String?
        var task: URLSessionTask?
    }
    
    private static var indicators: [String: IndicatorModel] = [:]
    
    public static func add(api: APNetApi, indicator: APNetIndicator?, view: UIView?, text: String?) {
        DDLogDebug("[AP][NetIndicator][+][\(indicators.count)] \(api)")
        indicators[api.identifier] = IndicatorModel(api: api, indicator: indicator, view: view, text: text, task: nil)
    }
    public static func remove(api: APNetApi) {
        if let _ = indicators.removeValue(forKey: api.identifier) {
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
    
    private func registerNotification(identifier: String) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        notificationCenter.addObserver(forName: Notification.Name.Task.DidResume, object: nil, queue: nil) { [weak self] (notify) in
            DDLogVerbose("Task Indicator resume")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.indicators[identifier], model.task == task else { return }
                self?.turn(status: .running, model: model)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidSuspend, object: nil, queue: nil) { [weak self] (notify) in
            DDLogVerbose("Task Indicator suspend")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.indicators[identifier], model.task == task else { return }
                self?.turn(status: .stop, model: model)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidCancel, object: nil, queue: nil) { [weak self] (notify) in
            DDLogVerbose("Task Indicator cancel")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.indicators[identifier], model.task == task else { return }
                self?.turn(status: .stop, model: model)
                APNetIndicator.remove(api: model.api)
            }
        }
        notificationCenter.addObserver(forName: Notification.Name.Task.DidComplete, object: nil, queue: nil) { [weak self] (notify) in
            DDLogVerbose("Task Indicator complete")
            if let task = notify.userInfo?[Notification.Key.Task] as? URLSessionTask {
                guard let model = APNetIndicator.indicators[identifier], model.task == task else { return }
                self?.turn(status: .stop, model: model)
                APNetIndicator.remove(api: model.api)
            }
        }
    }
    
    func turn(status: APNetIndicatorStatus, model: IndicatorModel) {}

}
