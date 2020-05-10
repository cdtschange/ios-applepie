//
//  Router.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/3.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie

public extension APRouter {
    
    static var paramsForTabBarRoute: [String: Any] = ["hidesBottomBarWhenPushed": true]

    @discardableResult
    static func route(toUrl url: String, params: [String: Any] = [:], animation: Bool = true, pop: Bool = false) -> Bool {
        var newParams = params
        newParams["url"] = url
        return route(toName: "BaseWebViewController", params: newParams, storyboardName: nil, animation: animation, pop: pop)
    }
}
