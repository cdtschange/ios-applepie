//
//  APCrashHandler.swift
//  Applepie
//
//  Created by 山天大畜 on 2019/3/28.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import Foundation

private typealias SignalAction = @convention(c) (Int32, UnsafeMutablePointer<__siginfo>?, UnsafeMutableRawPointer?) -> Void

public typealias CrashCallback = ((_ signal: Int32?, _ exception: NSException?, _ stackTracing: String) -> ())

private var previousABRTSignalHandler: SignalAction?
private var previousBUSSignalHandler: SignalAction?
private var previousFPESignalHandler: SignalAction?
private var previousPIPESignalHandler: SignalAction?
private var previousILLSignalHandler: SignalAction?
private var previousSEGVSignalHandler: SignalAction?
private var previousSYSSignalHandler: SignalAction?
private var previousTRAPSignalHandler: SignalAction?

private var proviseHandler: NSUncaughtExceptionHandler?
private func globalHandlerException(exception: NSException) {
    APCrashHandler.shared.signalHandler?(nil, exception, getStackTracing())
    proviseHandler?(exception)
}

private func getStackTracing(signal: Int32? = nil) -> String {
    var info = "Signal Exception:\n"
    info += "Signal \(signalName(signal: signal)) was raised.\n"
    info += "Call Stack:\n"
    // 这里过滤掉第一行日志
    // 因为注册了信号崩溃回调方法，系统会来调用，将记录在调用堆栈上，因此此行日志需要过滤掉
    var first = true
    for symbol in Thread.callStackSymbols {
        if first {
            first = false
            continue
        }
        info += symbol + "\n"
    }
    info += "threadInfo:\n"
    info += Thread.current.description
    return info
}

public class APCrashHandler: NSObject {
    public static let shared = APCrashHandler()
    public var signalHandler: CrashCallback?
    
    private override init() {
        super.init()
    }
    public func registerSignalHandler(callback: @escaping CrashCallback) {
        signalHandler = callback
        proviseHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(globalHandlerException(exception:))
        
        APCrashHandler.backupOriginalHandler()
        APCrashHandler.signalRegister()
    }
    private class func signalRegister() {
        signalRegister(signal: SIGABRT)
        signalRegister(signal: SIGBUS)
        signalRegister(signal: SIGFPE)
        signalRegister(signal: SIGILL)
        signalRegister(signal: SIGPIPE)
        signalRegister(signal: SIGSEGV)
        signalRegister(signal: SIGSYS)
        signalRegister(signal: SIGTRAP)
    }
    
    private class func backupOriginalHandler() {
        var old_action_abrt: sigaction = sigaction()
        sigaction(SIGABRT, nil, &old_action_abrt);
        if ((old_action_abrt.__sigaction_u.__sa_sigaction) != nil) {
            previousABRTSignalHandler = old_action_abrt.__sigaction_u.__sa_sigaction;
        }
        
        var old_action_bus: sigaction = sigaction()
        sigaction(SIGBUS, nil, &old_action_bus);
        if old_action_bus.__sigaction_u.__sa_sigaction != nil {
            previousBUSSignalHandler = old_action_bus.__sigaction_u.__sa_sigaction
        }
        
        var old_action_fpe: sigaction = sigaction()
        sigaction(SIGFPE, nil, &old_action_fpe);
        if old_action_fpe.__sigaction_u.__sa_sigaction != nil {
            previousFPESignalHandler = old_action_fpe.__sigaction_u.__sa_sigaction
        }
        
        var old_action_ill: sigaction = sigaction()
        sigaction(SIGILL, nil, &old_action_ill);
        if old_action_ill.__sigaction_u.__sa_sigaction != nil {
            previousILLSignalHandler = old_action_ill.__sigaction_u.__sa_sigaction
        }
        
        var old_action_pipe: sigaction = sigaction()
        sigaction(SIGPIPE, nil, &old_action_pipe);
        if old_action_pipe.__sigaction_u.__sa_sigaction != nil {
            previousPIPESignalHandler = old_action_pipe.__sigaction_u.__sa_sigaction
        }
        
        var old_action_segv: sigaction = sigaction()
        sigaction(SIGSEGV, nil, &old_action_segv);
        if old_action_segv.__sigaction_u.__sa_sigaction != nil {
            previousSEGVSignalHandler = old_action_segv.__sigaction_u.__sa_sigaction
        }
        
        var old_action_sys: sigaction = sigaction()
        sigaction(SIGSYS, nil, &old_action_sys);
        if old_action_sys.__sigaction_u.__sa_sigaction != nil {
            previousSYSSignalHandler = old_action_sys.__sigaction_u.__sa_sigaction
        }
        
        var old_action_trap: sigaction = sigaction()
        sigaction(SIGTRAP, nil, &old_action_trap);
        if old_action_trap.__sigaction_u.__sa_sigaction != nil {
            previousTRAPSignalHandler = old_action_trap.__sigaction_u.__sa_sigaction
        }
    }
    private class func signalRegister(signal:Int32) {
        var action = sigaction()
        action.sa_flags = SA_NODEFER | SA_SIGINFO
        action.__sigaction_u.__sa_sigaction = { (signal, info, context) in
            APCrashHandler.shared.signalHandler?(signal, nil, getStackTracing(signal: signal))
            APCrashHandler.previousSignalHandler(signal: signal, info: info, context: context)
            kill(getpid(), SIGKILL)
        }
        sigemptyset(&action.sa_mask)
        sigaction(signal, &action, nil)
    }
    
    private class func previousSignalHandler(signal: Int32, info:UnsafeMutablePointer<__siginfo>?, context:UnsafeMutableRawPointer?) {
        var previousSignalHandler: SignalAction?
        switch signal {
        case SIGABRT:
            previousSignalHandler = previousABRTSignalHandler
            break;
        case SIGBUS:
            previousSignalHandler = previousBUSSignalHandler
            break;
        case SIGFPE:
            previousSignalHandler = previousFPESignalHandler
            break;
        case SIGILL:
            previousSignalHandler = previousILLSignalHandler
            break;
        case SIGPIPE:
            previousSignalHandler = previousPIPESignalHandler
            break;
        case SIGSEGV:
            previousSignalHandler = previousSEGVSignalHandler
            break;
        case SIGSYS:
            previousSignalHandler = previousSYSSignalHandler
            break;
        case SIGTRAP:
            previousSignalHandler = previousTRAPSignalHandler
            break;
        default:
            break;
        }
        previousSignalHandler?(signal, info, context)
    }
}


private func signalName(signal: Int32?) -> String {
    guard signal != nil else {
        return ""
    }
    var signalName = ""
    switch (signal!) {
    case SIGABRT:
        signalName = "SIGABRT";
        break;
    case SIGBUS:
        signalName = "SIGBUS";
        break;
    case SIGFPE:
        signalName = "SIGFPE";
        break;
    case SIGILL:
        signalName = "SIGILL";
        break;
    case SIGPIPE:
        signalName = "SIGPIPE";
        break;
    case SIGSEGV:
        signalName = "SIGSEGV";
        break;
    case SIGSYS:
        signalName = "SIGSYS";
        break;
    case SIGTRAP:
        signalName = "SIGTRAP";
        break;
    default:
        break;
    }
    return signalName;
}
