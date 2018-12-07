//
//  APUserDefaultsTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

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
                return APUserDefaults.object(forKey: "TestUserDefaultsModel.name") as? String
            }
            set {
                return APUserDefaults.setObject(newValue, forKey: "TestUserDefaultsModel.name")
            }
        }
        static var age: Int? {
            get {
                return APUserDefaults.object(forKey: "TestUserDefaultsModel.age") as? Int
            }
            set {
                return APUserDefaults.setObject(newValue, forKey: "TestUserDefaultsModel.age")
            }
        }
        static var money: Double? {
            get {
                return APUserDefaults.object(forKey: "TestUserDefaultsModel.money") as? Double
            }
            set {
                return APUserDefaults.setObject(newValue, forKey: "TestUserDefaultsModel.money")
            }
        }
    }
    
    func testCache() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        testSingle(key: "testKeyString", value: "test")
        testSingle(key: "testKeyInt", value: 123)
        testSingle(key: "testKeyBool", value: true)
        testSingle(key: "testKeyDouble", value: 1.2)
        testSingle(key: "testKeyList", value: ["a","b"])
        testSingle(key: "testKeyListInt", value: [1,2,3])
        testSingle(key: "testKeyDict", value: ["a": "a1", "b": "b1"])
        
        
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
    
    func testSingle<T: Equatable & Codable>(key: String, value: T) {
        assert(APUserDefaults.object(forKey: key) == nil)
        APUserDefaults.setObject(value, forKey: key)
        usleep(100000)
        assert((APUserDefaults.object(forKey: key) as! T) == value)
        APUserDefaults.removeObject(forKey: key)
        usleep(100000)
        assert(APUserDefaults.object(forKey: key) == nil)
    }
}
