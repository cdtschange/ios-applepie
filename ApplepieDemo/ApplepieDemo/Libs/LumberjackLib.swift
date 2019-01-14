//
//  APLog.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/8.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import CocoaLumberjack

public struct LumberjackLib {
    public static func setup(level: DDLogLevel = DDLogLevel.debug) {
        defaultDebugLevel = level
        DDLog.add(DDTTYLogger.sharedInstance)
        //        DDLog.add(DDASLLogger.sharedInstance)
        DDTTYLogger.sharedInstance.colorsEnabled = true
        DDTTYLogger.sharedInstance.setForegroundColor(UIColor.blue, backgroundColor: nil, for: .info)
        DDTTYLogger.sharedInstance.setForegroundColor(UIColor(rgba: "#008040"), backgroundColor: nil, for: .verbose)
        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
    }
}
