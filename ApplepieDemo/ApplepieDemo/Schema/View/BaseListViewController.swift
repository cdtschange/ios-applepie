//
//  BaseListViewController.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2018/12/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import UIKit
import Applepie

open class BaseListViewController: APBaseListViewController {

    var _indicator = APIndicator()
    open override var indicator: APIndicatorProtocol? {
        return _indicator
    }
    
    
}
