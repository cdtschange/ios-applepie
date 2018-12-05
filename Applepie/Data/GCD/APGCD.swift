//
//  APGCD.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/11/26.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation


public struct APGCD {
    public typealias APGCDBlock = () -> ()
    private var queue: DispatchQueue
    private var group: DispatchGroup?
    private var blocks: [APGCDBlock] = []
    private var timer: DispatchSourceTimer?
    
    public init() {
        queue = DispatchQueue.global()
    }
    public init(queue: DispatchQueue) {
        self.queue = queue
    }
    public mutating func setQueue(queue: DispatchQueue) -> APGCD {
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
    public func serial(_ block: @escaping APGCDBlock) -> APGCD {
        var result = self
        result.blocks.append(block)
        return result
    }
    /// 串行耗时操作，每一段子任务依赖上一个任务完成，全部完成后回调主线程
    /// 处理完毕的回调，在主线程异步执行
    public func serialDone(_ block: @escaping APGCDBlock) {
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
    public func concurrent(_ block: @escaping APGCDBlock) -> APGCD {
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
    public func concurrentBarrier(_ block: @escaping APGCDBlock) -> APGCD {
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
    public func concurrentDone(_ block: @escaping APGCDBlock) {
        group?.notify(queue: .main, execute: {
            block()
        })
    }
    
    /// 延时执行
    public func delayExecute(after: DispatchTimeInterval, code: @escaping APGCDBlock) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after) {
            code()
        }
    }
    
    /// 定时器
    ///
    /// - Parameters:
    ///   - duration: 计时时间
    ///   - repeating: 多久重复一次
    ///   - leeway: 允许误差
    ///   - eventHandle: 处理事件
    ///   - cancelHandle: 计时器结束事件
    public mutating func timer(duration: DispatchTimeInterval,
               repeating: Double,
               leeway: DispatchTimeInterval = DispatchTimeInterval.milliseconds(1),
               invoked: @escaping APGCDBlock,
               canceled: APGCDBlock? = nil)
    {
        let timer = DispatchSource.makeTimerSource()
        timer.setEventHandler {
            invoked()
        }
        timer.setCancelHandler {
            canceled?()
        }
        timer.schedule(deadline: DispatchTime.now(), repeating: repeating, leeway: leeway)
        timer.resume()
        delayExecute(after: duration) {
            timer.cancel()
        }
        self.timer = timer
    }
    public mutating func cancelTimer() {
        self.timer?.cancel()
        self.timer = nil
    }
}

public extension Array {
    /// 并发遍历
    public func concurrentForeach(_ code: (Element) -> ()) {
        DispatchQueue.concurrentPerform(iterations: self.count) { (i) in
            code(self[i])
        }
    }
}
