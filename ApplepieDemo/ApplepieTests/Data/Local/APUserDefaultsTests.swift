//
//  APUserDefaultsTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import SwiftyUserDefaults

extension DefaultsKeys {
    var name: DefaultsKey<String?> { .init("TestUserDefaultsModel.name") }
    var age: DefaultsKey<Int?> { .init("TestUserDefaultsModel.age") }
    var money: DefaultsKey<Double?> { .init("TestUserDefaultsModel.money") }
}

class APUserDefaultsTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    struct TestUserDefaultsModel {
        static var name: String? {
            get {
                return Defaults[\.name]
            }
            set {
                return Defaults[\.name] = newValue
            }
        }
        static var age: Int? {
            get {
                return Defaults[\.age]
            }
            set {
                return Defaults[\.age] = newValue
            }
        }
        static var money: Double? {
            get {
                return Defaults[\.money]
            }
            set {
                return Defaults[\.money] = newValue
            }
        }
    }
    
    func testCache() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
 
        assert(TestUserDefaultsModel.name == nil)
        TestUserDefaultsModel.name = "abc"
        usleep(100000)
        assert(TestUserDefaultsModel.name == "abc")
        TestUserDefaultsModel.name = nil
        usleep(100000)
        assert(TestUserDefaultsModel.name == nil)
        
        assert(TestUserDefaultsModel.age == nil)
        TestUserDefaultsModel.age = 123
        usleep(100000)
        assert(TestUserDefaultsModel.age == 123)
        TestUserDefaultsModel.age = nil
        usleep(100000)
        assert(TestUserDefaultsModel.age == nil)
        
        assert(TestUserDefaultsModel.money == nil)
        TestUserDefaultsModel.money = 1.2
        usleep(100000)
        assert(TestUserDefaultsModel.money == 1.2)
        TestUserDefaultsModel.money = nil
        usleep(100000)
        assert(TestUserDefaultsModel.money == nil)
    }
    
}
