//
//  APRouterTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2018/12/13.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APRouterTests: BaseTestCase {
    
    @objc(ViewController1)
    private class ViewController1: UIViewController {}
    @objc(ViewController2)
    private class ViewController2: UIViewController, APRouterProtocol {
        var params: [String : Any] = [:]
    }
    @objc(ViewController3)
    private class ViewController3: UIViewController {}

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRouter() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        let root = UIViewController.topMostViewController()
        var v2: ViewController2?
        let delayTime = 600
        firstly {
            assert(root != nil)
            assert(APRouter.route(toName: "None", animation: false, pop: true) == false)
            assert(APRouter.route(toName: "toNext", animation: false, pop: true) == true)
            assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ApplepieDemo.ViewController")
            assert(APRouter.routeBack(animation: false) == true)
            return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(UIViewController.topMostViewController() == root)
                let nav = UINavigationController(rootViewController: ViewController1())
                root?.present(nav, animated: false, completion: nil)
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController1")
                assert(APRouter.route(toUrl: "http://test", name: "ViewController2", params: ["a": "1", "b": 2, "c": true, "d": 1.2], animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController2")
                v2 = UIViewController.topMostViewController() as? ViewController2
                assert((v2?.params["a"] as? String) == "1")
                assert((v2?.params["b"] as? Int) == 2)
                assert((v2?.params["c"] as? Bool) == true)
                assert((v2?.params["d"] as? Double) == 1.2)
                assert((v2?.params["url"] as? String) == "http://test")
                assert(UIViewController.topMostViewController()?.navigationController?.viewControllers.count == 2)
                assert(APRouter.route(toName: "ViewController3", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController3")
                assert(UIViewController.topMostViewController()?.ap.containsViewControllerInNavigation("ViewController2") == true)
                assert(UIViewController.topMostViewController()?.ap.containsViewControllerInNavigation("ViewController1") == true)
                assert(UIViewController.topMostViewController()?.ap.containsViewControllerInNavigation("ViewController3") == true)
                assert(UIViewController.topMostViewController()?.ap.containsViewControllerInNavigation("ViewController4") == false)
                assert(APRouter.routeBack(params: ["a": "2"], animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController2")
                assert((v2?.params["a"] as? String) == "2")
                assert(APRouter.route(toName: "ViewController3", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.routeBack(toName: "ViewController4", animation: false) == false)
                assert(APRouter.routeBack(toName: "ViewController2", params: ["a": "3"], animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController2")
                assert((v2?.params["a"] as? String) == "3")
                assert(APRouter.routeBack(toName: "ViewController1", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController1")
                assert(APRouter.route(toName: "ViewController2", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.route(toName: "ViewController3", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.routeBack(skip: 0, animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController2")
                assert(APRouter.route(toName: "ViewController3", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.routeBack(skip: 1, animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController1")
                assert(APRouter.route(toName: "ViewController2", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.route(toName: "ViewController3", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.route(toName: "ViewController2", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.route(toName: "ViewController3", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(APRouter.route(toName: "ViewController2", animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(UIViewController.topMostViewController()?.navigationController?.viewControllers.count == 6)
                assert(APRouter.route(toName: "ViewController3", animation: false, pop: true) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController3")
                assert(APRouter.routeBack(toName: "ViewController2", animation: false) == false)
                assert(APRouter.routeBack(animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController2")
                assert(APRouter.route(toName: "ViewController3", animation: false, pop: true) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController3")
                assert(APRouter.routeBack(skip: 1, animation: false) == true)
                return after(.milliseconds(delayTime))
            }.then { () -> Guarantee<Void> in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController2")
                assert(APRouter.routeBack(skip: 5, animation: false) == false)
                assert(APRouter.routeToRoot(animation: false) == true)
                return after(.milliseconds(delayTime))
            }.done { _ in
                assert(NSStringFromClass(UIViewController.topMostViewController()!.classForCoder) == "ViewController1")
                assert(APRouter.routeBack(animation: false) == true)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 25)

    }

}
