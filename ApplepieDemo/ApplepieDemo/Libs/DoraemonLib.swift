//
//  DoraemonLib.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation
import DoraemonKit
import Applepie

public struct DoraemonLib {
    public static func setup() {
        #if DEBUG
        DoraemonManager.shareInstance().addH5DoorBlock { url in
            APRouter.route(toUrl: url)
        }
        DoraemonManager.shareInstance().install()
        #endif
    }
}
