//
//  APEvent.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/26.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation

public struct APEvent {
    
    /// 主线程需要子线程的处理结果
    public static func execute<T>(queue: DispatchQueue = DispatchQueue.global(), waitFor: @escaping () -> T, finshed: @escaping (T) -> ()) {
        queue.async {
            let data = waitFor()
            DispatchQueue.main.async {
                finshed(data)
            }
        }
    }
    
    /// 主线程不需要子线程的处理结果
    public static func execute(queue: DispatchQueue = DispatchQueue.global(), waitFor: @escaping () -> (), finshed: @escaping () -> ()) {
        let workItem = DispatchWorkItem {
            waitFor()
        }
        queue.async(execute: workItem)
        workItem.wait()
        finshed()
    }

}
