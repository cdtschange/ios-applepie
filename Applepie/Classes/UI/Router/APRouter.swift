//
//  APRouter.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/12.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack

public protocol APRouterProtocol {
    var params: [String: Any] { get set }
}

public struct APRouter {
    
    private static var topViewController: UIViewController? {
        return UIViewController.topMostViewController()
    }
    
    @discardableResult
    public static func route(toName name: String, params: [String: Any] = [:], storyboardName: String? = nil, animation: Bool = true, pop: Bool = false) -> Bool {
        DDLogInfo("Route name: \(name) (\(params.ap.queryString))")
        if let vc = UIViewController.instanceViewController(name, storyboardName: storyboardName) {
            if var vc = vc as? APRouterProtocol {
                vc.params = params
            }
            if pop {
                topViewController?.present(vc, animated: animation, completion: nil)
            } else {
                topViewController?.navigationController?.pushViewController(vc, animated: animation)
            }
            return true
        } else if topViewController?.ap.canPerformSegue(withIdentifier: name) == true {
            topViewController?.performSegue(withIdentifier: name, sender: ["params": params])
            return true
        }
        DDLogError("Can't route to: \(name), please check the name")
        return false
    }
    @discardableResult
    public static func route(toUrl url: String, name: String, params: [String: Any] = [:], storyboardName: String? = nil, animation: Bool = true, pop: Bool = false) -> Bool {
        var newParams = params
        newParams["url"] = url
        return route(toName: name, params: newParams, storyboardName: storyboardName, animation: animation, pop: pop)
    }
    @discardableResult
    public static func routeBack(toName name: String? = nil, params: [String: Any] = [:], animation: Bool = true) -> Bool {
        let count = topViewController?.navigationController?.viewControllers.count ?? 0
        if let name = name {
            DDLogInfo("Route back to \(name)")
            if count <= 1 {
                return false
            } else {
                if let vc = topViewController?.navigationController?.viewControllers.dropLast().reversed().filter({ $0.ap.simpleClassName == name }).first {
                    if var vc = vc as? APRouterProtocol {
                        vc.params = params
                    }
                    return topViewController?.navigationController?.popToViewController(vc, animated: animation) != nil
                }
            }
        } else {
            DDLogInfo("Route back")
            if count <= 1 {
                topViewController?.dismiss(animated: animation, completion: nil)
                return true
            }
            let vc = topViewController!.navigationController!.viewControllers[count - 2]
            if var vc = vc as? APRouterProtocol {
                vc.params = params
            }
            return topViewController?.navigationController?.popToViewController(vc, animated: animation) != nil
        }
        return false
    }
    // skip = 0 equals routeBack with no name, will return to last viewcontroller
    @discardableResult
    public static func routeBack(skip number: Int, params: [String: Any] = [:], animation: Bool = true) -> Bool {
        DDLogInfo("Route back: \(number)")
        let count = topViewController?.navigationController?.viewControllers.count ?? 0
        if count <= 1 {
            topViewController?.dismiss(animated: animation, completion: nil)
            return true
        } else {
            if count > number + 1 {
                let vc = topViewController!.navigationController!.viewControllers[count - 2 - number]
                if var vc = vc as? APRouterProtocol {
                    vc.params = params
                }
                return topViewController?.navigationController?.popToViewController(vc, animated: animation) != nil
            }
        }
        return false
    }
    @discardableResult
    public static func routeToRoot(animation: Bool = true) -> Bool {
        DDLogInfo("Route to root")
        return topViewController?.navigationController?.popToRootViewController(animated: animation) != nil
    }
    
}
