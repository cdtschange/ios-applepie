//
//  APSendCodeButtonTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import UIKit
import PromiseKit

class APSendCodeButtonTests: BaseTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testButton() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let button = APSendCodeButton(frame: CGRect.zero)
        button.setTitle("Normal", for: .normal)
        button.countDown()
        button.stop()
        assert(button.title(for: .normal) == "Normal")
        assert(button.isSelected == false)
        assert(button.isUserInteractionEnabled == true)

        
        let data = try! NSKeyedArchiver.archivedData(withRootObject: button, requiringSecureCoding: false)
        let coder = try! NSKeyedUnarchiver(forReadingFrom: data)
        let button2 = APSendCodeButton(coder: coder)
        assert(button2 != nil)
        
        let expectation = XCTestExpectation(description: "Complete")
        
        let view = UIView()
        Promise<Void> { sink in
                assert(button.isSelected == false)
                assert(button.isUserInteractionEnabled == true)
                button.countDown(2)
                sink.fulfill(())
            }.then { () -> Guarantee<Void> in
                assert(button.isSelected == true)
                assert(button.isUserInteractionEnabled == false)
                assert(button.title(for: .selected) == "2秒后可重发" || button.title(for: .selected) == "1秒后可重发")
                return after(.seconds(1))
            }.then { () -> Guarantee<Void> in
                assert(button.isSelected == true)
                assert(button.isUserInteractionEnabled == false)
                assert(button.title(for: .selected) == "1秒后可重发" || button.title(for: .selected) == "0秒后可重发")
                return after(.seconds(1))
            }.then { () -> Guarantee<Void> in
                assert(button.isSelected == false)
                assert(button.isUserInteractionEnabled == true)
                assert(button.title(for: .normal) == "重新获取")
                view.addSubview(button)
                button.countDown(2)
                return after(.seconds(1))
            }.done { data in
                button.removeFromSuperview()
                assert(button.isSelected == false)
                assert(button.isUserInteractionEnabled == true)
                assert(button.title(for: .normal) == "重新获取")
                expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
}
