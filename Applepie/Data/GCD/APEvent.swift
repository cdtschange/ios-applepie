//
//  APEvent.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/26.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation


public struct APEvent {
    public typealias APEventBlock = () -> ()
    private var queue: DispatchQueue
    private var group: DispatchGroup?
    private var blocks: [APEventBlock] = []
    
    public init() {
        queue = DispatchQueue.global()
    }
    public init(queue: DispatchQueue) {
        self.queue = queue
    }
    public mutating func setQueue(queue: DispatchQueue) -> APEvent {
        self.queue = queue
        return self
    }
    
    /// 执行一个耗时操作后回调主线程，主线程需要子线程的处理结果
    public func execute<T>(waitFor: @escaping () -> T, finshed: @escaping (T) -> ()) {
        queue.async {
            let data = waitFor()
            DispatchQueue.main.async {
                finshed(data)
            }
        }
    }
    
    /// 执行一个耗时操作后回调主线程，主线程不需要子线程的处理结果
    public func execute(waitFor: @escaping () -> (), finshed: @escaping () -> ()) {
        let workItem = DispatchWorkItem {
            waitFor()
        }
        queue.async(execute: workItem)
        workItem.wait()
        finshed()
    }
    
    /// 串行耗时操作，每一段子任务依赖上一个任务完成，全部完成后回调主线程
    /// 向全局并发队列添加任务，添加的任务会同步执行
    public func serial(_ block: @escaping APEventBlock) -> APEvent {
        var result = self
        result.blocks.append(block)
        return result
    }
    /// 串行耗时操作，每一段子任务依赖上一个任务完成，全部完成后回调主线程
    /// 处理完毕的回调，在主线程异步执行
    public func serialDone(_ block: @escaping APEventBlock) {
        queue.async {
            for workItem in self.blocks {
                workItem()
            }
            DispatchQueue.main.async {
                block()
            }
        }
    }

    /// 并发耗时操作，每一段子任务独立，所有子任务完成后回调主线程
    /// 向自定义并发队列添加任务，添加的任务会并发执行
    public func concurrent(_ block: @escaping APEventBlock) -> APEvent {
        var result = self
        if result.group == nil {
            result.group = DispatchGroup()
        }
        result.queue = DispatchQueue(label: "apevent.applepie.com", attributes: .concurrent)
        let workItem = DispatchWorkItem {
            block()
        }
        result.queue.async(group: result.group!, execute: workItem)
        return result
    }
    /// 并发耗时操作，每一段子任务独立，所有子任务完成后回调主线程
    /// 此任务执行时会排斥其他的并发任务，一般用于写入事务，保证线程安全。
    public func concurrentBarrier(_ block: @escaping APEventBlock) -> APEvent {
        var result = self
        if result.group == nil {
            result.group = DispatchGroup()
        }
        result.queue = DispatchQueue(label: "apevent.applepie.com", attributes: .concurrent)
        let workItem = DispatchWorkItem(flags: .barrier) {
            block()
        }
        result.queue.async(group: result.group!, execute: workItem)
        return result
    }
    /// 并发耗时操作，每一段子任务独立，所有子任务完成后回调主线程
    /// 处理完毕的回调，在主线程异步执行
    public func concurrentDone(_ block: @escaping APEventBlock) {
        group?.notify(queue: .main, execute: {
            block()
        })
    }
}
