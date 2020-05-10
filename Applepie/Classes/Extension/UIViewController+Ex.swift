//
//  UIViewController+Ex.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/13.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public extension Applepie where Base == UIViewController {
    var topMostViewController: UIViewController {
        
        if let presented = base.presentedViewController {
            return presented.ap.topMostViewController
        }
        
        if let navigation = base as? UINavigationController {
            return navigation.visibleViewController?.ap.topMostViewController ?? navigation
        }
        
        if let tab = base as? UITabBarController {
            return tab.selectedViewController?.ap.topMostViewController ?? tab
        }
        
        return base
    }
    
    func canPerformSegue(withIdentifier identifier: String) -> Bool {
        let segueTemplates: AnyObject = base.value(forKey: "storyboardSegueTemplates") as AnyObject
        guard !(segueTemplates is NSNull) else {
            return false
        }
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        let filteredArray: [Any] = segueTemplates.filtered(using: predicate)
        return filteredArray.count > 0
    }
    
    //获得去除Module后的类名
    var simpleClassName: String {
        get {
            let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
            let className = NSStringFromClass(base.classForCoder)
            let prefix = "\(bundleName)."
            if className.hasPrefix(prefix) && className.count > prefix.count {
                let startIndex = className.index(prefix.startIndex, offsetBy: prefix.count)
                return String(className[startIndex...])
            }
            return className
        }
    }
    
    func containsViewControllerInNavigation(_ name: String) -> Bool {
        return (base.navigationController?.viewControllers.filter { $0.ap.simpleClassName == name }.count ?? 0) > 0
    }
}

public extension UIViewController {
    static func topMostViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.ap.topMostViewController
    }
    
    private static func instanceViewControllerInXib(_ name: String) -> UIViewController? {
        let type = UIViewController.fullClassName(name) as? UIViewController.Type
        if let vc = type?.init(nibName: name, bundle: nil) {
            return vc
        }
        let nibPath = Bundle.main.path(forResource: name, ofType: "nib")
        if (nibPath != nil) {
            return NSObject.fromClassName(name) as? UIViewController
        }
        return nil
    }
    private static func instanceViewControllerInStoryboard(_ name: String, storyboardName: String? = nil) -> UIViewController? {
        var storyboard: UIStoryboard?
        if let storyboardName = storyboardName, storyboardName.count > 0 {
            storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        } else {
            storyboard = UIViewController.topMostViewController()?.storyboard
        }
        
        if let storyboard = storyboard {
            if (storyboard.value(forKey: "identifierToNibNameMap") as AnyObject).object(forKey: name) != nil {
                return storyboard.instantiateViewController(withIdentifier: name)
            }
        }
        return nil
    }
    static func instanceViewController(_ name: String, storyboardName: String? = nil) -> UIViewController? {
        if let vc = instanceViewControllerInStoryboard(name, storyboardName: storyboardName) {
            return vc
        }
        if let vc = instanceViewControllerInXib(name) {
            return vc
        }
        let type = NSClassFromString(name) as? UIViewController.Type
        return type?.init()
    }
}
