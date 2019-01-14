//
//  APBaseViewModel.swift
//  Zijingcaizhi
//
//  Created by 毛蔚 on 2018/12/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import UIKit
import CocoaLumberjack
import PromiseKit

open class APBaseViewModel {
   
    open var repository: APBaseRepository? {
        get { return nil }
    }
    
    open func fetchData() -> Promise<Any> {
        return Promise { sink in
            sink.fulfill(true)
        }
    }
    
    deinit {
        DDLogError("Deinit: \(NSStringFromClass(type(of: self)))")
    }
}
