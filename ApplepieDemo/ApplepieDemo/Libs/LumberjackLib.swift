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
    public static func setup(level: DDLogLevel = DDLogLevel.verbose) {
        dynamicLogLevel = level
        if let logger = DDTTYLogger.sharedInstance {
            DDLog.add(logger)
            //        DDLog.add(DDASLLogger.sharedInstance)
            logger.colorsEnabled = true
            logger.setForegroundColor(UIColor.blue, backgroundColor: nil, for: .info)
            logger.setForegroundColor(UIColor(rgba: "#008040"), backgroundColor: nil, for: .verbose)
        }
        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")
    }
}
