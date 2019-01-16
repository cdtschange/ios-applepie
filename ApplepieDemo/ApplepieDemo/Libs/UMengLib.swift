//
//  UMengLib.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/15.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

public struct UMengLib {
    public static func setup() {
        UMConfigure.initWithAppkey(UMengConfig.appKey, channel: GlobalConfig.channel)
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false
        if !GlobalConfig.isRelease {
            UMConfigure.setLogEnabled(true)
            UMCommonLogManager.setUp()
        }
    }
    public static func handleOpen(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return UMSocialManager.default()?.handleOpen(url, options: options) ?? false
    }
}
