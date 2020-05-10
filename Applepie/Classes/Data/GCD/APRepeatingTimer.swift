//
//  APRepeatingTimer.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation
import CocoaLumberjack

public class APRepeatingTimer {
    
    let timeInterval: TimeInterval
    
    public init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.eventHandler?()
            }
        })
        return t
    }()
    
    public var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler(handler: nil)
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
        DDLogInfo("Deinit APRepeatingTimer")
    }
    
    public func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    public func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    public func cancel() {
        suspend()
        timer.setEventHandler(handler: nil)
        timer.cancel()
        eventHandler = nil
    }
}
