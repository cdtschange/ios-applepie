//
//  APIndicatorTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/8.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APIndicatorTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIndicator() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // single indicator
        
        let indicator = APIndicator()

        assert(UIApplication.shared.indicatorCount == 0)
        assert(indicator.showing == false)
        indicator.show(inView: nil, text: nil, detailText: nil, animated: true)
        assert(indicator.showing == true)
        assert(UIApplication.shared.indicatorCount == 1)
        indicator.hide(inView: nil, animated: true)
        assert(indicator.showing == false)
        assert(UIApplication.shared.indicatorCount == 0)

        
        // multi indicator concurrent
        let indicator1 = APIndicator()
        let indicator2 = APIndicator()
        assert(UIApplication.shared.indicatorCount == 0)
        indicator1.show(inView: nil, text: nil, detailText: nil, animated: true)
        assert(indicator1.showing == true)
        assert(UIApplication.shared.indicatorCount == 1)
        indicator2.show(inView: nil, text: nil, detailText: nil, animated: true)
        assert(UIApplication.shared.indicatorCount == 2)
        assert(indicator2.showing == true)
        indicator1.hide(inView: nil, animated: true)
        assert(indicator1.showing == false)
        assert(indicator2.showing == true)
        assert(UIApplication.shared.indicatorCount == 1)
        indicator2.hide(inView: nil, animated: true)
        assert(indicator1.showing == false)
        assert(indicator2.showing == false)
        assert(UIApplication.shared.indicatorCount == 0)
        
        let expectation = XCTestExpectation(description: "Complete")

        let view = UIView()
        let indicator3 = APIndicator()
        firstly {
            Promise { sink in
                indicator3.showTip(inView: view, text: "text", detailText: "detail", image: UIImage(), offset: CGPoint.zero, animated: false, hideAfter: 0)
                sink.fulfill(())
            }
            }.then {
                return after(.seconds(1))
            }.ensure {
                indicator3.showTip(inView: nil, text: "text", detailText: "detail", animated: false, hideAfter: 0) {}
                indicator3.show(inView: view, text: "text", detailText: "detail", animated: false)
            }.then {
                return after(.seconds(1))
            }.ensure {
                indicator3.hide(inView: view, animated: false)
            }.then {
                return after(.seconds(1))
            }.done { data in
                indicator3.hide(inView: view, animated: false)
                expectation.fulfill()
            }.catch { error in
                assertionFailure()
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }

    func testProgressIndicator() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // single indicator
        
        let indicator = APIndicator()
        
        let expectation = XCTestExpectation(description: "Complete")
        
        let view = UIView()
        let text2 = "test2"
        let detail2 = "detail2"
        
        indicator.showProgress(inView: nil, text: nil, detailText: nil, cancelable: false, cancelTitle: nil, cancelHandler: nil, type: .determinate, animated: false)
        after(.seconds(1)).then { () -> Guarantee<Void> in
                indicator.changeProgress(inView: view, text: text2, detailText: detail2, progress: 0.1, animated: false)
                return after(.seconds(1))
            }.then { () -> Guarantee<Void> in
                indicator.cancelProgress()
                indicator.showProgress(inView: view, text: "text", detailText: "detail", cancelable: true, cancelTitle: "Cancel", cancelHandler: {}, type: .determinate, animated: false)
                return after(.seconds(1))
            }.then { () -> Guarantee<Void> in
                indicator.changeProgress(inView: view, text: text2, detailText: detail2, progress: 0.1, animated: false)
                return after(.seconds(1))
            }.then { () -> Guarantee<Void> in
                indicator.cancelProgress()
                return after(.seconds(1))
            }.done { data in
                indicator.showProgress(inView: view, text: "text", detailText: "detail", cancelable: true, cancelTitle: nil, cancelHandler: {}, type: .determinate, animated: false)
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 10)
    }

}
