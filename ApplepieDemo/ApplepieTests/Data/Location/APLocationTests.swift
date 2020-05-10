//
//  APLocationTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/11.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import SwiftLocation
import PromiseKit
import CoreLocation

class APLocationTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        print(APLocation.currentLocation ?? "")
        APLocation.currentPosition(timeout: 3).then { location -> Promise<[CLPlacemark]?> in
                print(location)
                print(APLocation.currentLocation ?? "")
                return APLocation.transferToPlace(location: location)
            }.done { placemarks in
                print(placemarks ?? "")
                expectation.fulfill()
            }.catch { error in
                print(error)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testIPLocation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        print(APLocation.currentLocation ?? "")
        APLocation.currentPosition(usingIP: .ipAPI).then { location -> Promise<[CLPlacemark]?> in
            print(location)
            print(APLocation.currentLocation ?? "")
            return APLocation.transferToPlace(location: CLLocation(latitude: location.coordinates!.latitude, longitude: location.coordinates!.longitude))
            }.done { placemarks in
                print(placemarks ?? "")
                expectation.fulfill()
            }.catch { error in
                print(error)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testContinueLocation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Complete")
        print(APLocation.currentLocation ?? "")
        APLocation.subscribePosition(onUpdate: { (location, error) in
            print(location ?? "")
            print(error ?? "")
        })
        after(.seconds(1)).done {
            APLocation.stop()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testLocationTimeout() {
        APLocation.currentPosition(timeout: 1).done { location in
                print(location)
            }.catch { error in
                print(error)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
