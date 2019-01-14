//
//  APSendCodeButton.swift
//  Zijingcaizhi
//
//  Created by 山天大畜 on 2019/1/11.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit

class APSendCodeButton: UIButton {
    private var timer: Timer?
    private var stopTime: Double = 0
    
    open var countDownSeconds: Int = 60
    open var timeupTitle: String = "重新获取"
    var selectedSubffixTitle: String = "秒后可重发"
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func countDown() {
        countDown(countDownSeconds)
    }
    open func countDown(_ seconds: Int) {
        stop()
        self.isSelected = true
        self.isUserInteractionEnabled = false
        self.stopTime = Date().timeIntervalSince1970.advanced(by: Double(seconds))
        self.showRemainSecond()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(APSendCodeButton.timerCountDown), userInfo: nil, repeats: true)
    }
    
    open func stop() {
        timer?.invalidate()
        timer = nil
        self.isSelected = false
        self.isUserInteractionEnabled = true
    }
    
    private func showRemainSecond() {
        let now = Date().timeIntervalSince1970.advanced(by: 0)
        setTitle("\(Int(stopTime - now))\(selectedSubffixTitle)", for: .selected)
    }
    @objc private func timerCountDown() {
        let now = Date().timeIntervalSince1970.advanced(by: 0)
        if now > stopTime {
            stop()
            setTitle(timeupTitle, for: UIControl.State())
        } else {
            showRemainSecond()
        }
    }
    open override func removeFromSuperview() {
        stop()
        super.removeFromSuperview()
    }

}
