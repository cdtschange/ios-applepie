//
//  APBaseListViewModel.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2018/12/31.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack
import ReactiveSwift
import PromiseKit

open class APBaseListViewModel: APBaseViewModel {

    public var dataIndex: UInt = 0
    public let listLoadNumber: UInt = 20
    public let listMaxNumber: UInt = UInt.max
    public var dataArray: [Any] = []
    
    
    open func appendDataArray(_ data: [Any]?) {
        if let data = data {
            if dataIndex == 0 {
                dataArray = data
            } else {
                dataArray = dataArray + data
            }
        } else {
            if dataIndex == 0 {
                dataArray = []
            }
        }
    }
    
    deinit {
        DDLogError("Deinit: \(NSStringFromClass(type(of: self)))")
    }
}
