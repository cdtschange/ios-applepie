//
//  UIViewControllerExTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/13.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import Applepie

class UIViewControllerExTests: BaseTestCase {
    
    @objc(TestViewController)
    private class TestViewController: UIViewController {}
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewController() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let root = UIViewController.topMostViewController()
        assert(root != nil)
        assert(root?.ap.topMostViewController == root)
        assert(root?.ap.simpleClassName == "ViewController")
        assert(root?.ap.canPerformSegue(withIdentifier: "test") == false)
        assert(root?.ap.canPerformSegue(withIdentifier: "toNext") == true)
        assert(root?.ap.containsViewControllerInNavigation("ViewController") == false)
        assert(UIViewController.instanceViewController("ViewControllerNib") != nil)
        assert(UIViewController.instanceViewController("ViewController") != nil)
        assert(UIViewController.instanceViewController("ViewController", storyboardName: "Main") != nil)
        assert(UIViewController.instanceViewController("TestViewController") != nil)
        assert(UIViewController.instanceViewController("Test") == nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
