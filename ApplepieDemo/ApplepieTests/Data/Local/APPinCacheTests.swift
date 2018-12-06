//
//  APDiskCacheTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class APPinCacheTests: BaseTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        APPinCache.removeAllObjects()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        APPinCache.removeAllObjects()
    }
    
    
    
    struct TestPinCacheModel {
        static var name: String? {
            get {
                return APPinCache.object(forKey: "TestMemoryCacheModel.name") as? String
            }
            set {
                return APPinCache.setObject(newValue, forKey: "TestMemoryCacheModel.name")
            }
        }
        static var age: Int? {
            get {
                return APPinCache.object(forKey: "TestMemoryCacheModel.age") as? Int
            }
            set {
                return APPinCache.setObject(newValue, forKey: "TestMemoryCacheModel.age")
            }
        }
        static var money: Double? {
            get {
                return APPinCache.object(forKey: "TestMemoryCacheModel.money") as? Double
            }
            set {
                return APPinCache.setObject(newValue, forKey: "TestMemoryCacheModel.money")
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
        
        
        assert(TestPinCacheModel.name == nil)
        TestPinCacheModel.name = "abc"
        usleep(100000)
        assert(TestPinCacheModel.name == "abc")
        TestPinCacheModel.name = nil
        usleep(100000)
        assert(TestPinCacheModel.name == nil)
        
        assert(TestPinCacheModel.age == nil)
        TestPinCacheModel.age = 123
        usleep(100000)
        assert(TestPinCacheModel.age == 123)
        TestPinCacheModel.age = nil
        usleep(100000)
        assert(TestPinCacheModel.age == nil)
        
        assert(TestPinCacheModel.money == nil)
        TestPinCacheModel.money = 1.2
        usleep(100000)
        assert(TestPinCacheModel.money == 1.2)
        TestPinCacheModel.money = nil
        usleep(100000)
        assert(TestPinCacheModel.money == nil)
    }
    
    func testSingle<T: Equatable & Codable>(key: String, value: T) {
        assert(APPinCache.containsObject(forKey: key) == false)
        assert(APPinCache.object(forKey: key) == nil)
        APPinCache.setObject(value, forKey: key)
        usleep(100000)
        assert(APPinCache.containsObject(forKey: key) == true)
        assert((APPinCache.object(forKey: key) as! T) == value)
        APPinCache.removeObject(forKey: key)
        usleep(100000)
        assert(APPinCache.containsObject(forKey: key) == false)
    }
    
}
