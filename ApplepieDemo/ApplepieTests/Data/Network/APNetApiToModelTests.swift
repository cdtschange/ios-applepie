//
//  APNetApiToModelTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/9.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest

class APNetApiToModelTests: BaseTestCase {
    
    
    
    private class TestModel: Codable {
        var a: Int?
        var b: String?
        var c: Double?
        var d: Bool?
        var m: TestInnerModel?
    }
    
    private class TestInnerModel: Codable {
        var arr: [String]?
        var dict: [String: String]?
    }
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testToModel() {
        var modelDict: [String: Any] = [:]
        modelDict["a"] = 1
        modelDict["b"] = "word"
        modelDict["c"] = 1.0
        modelDict["d"] = true
        modelDict["m"] = ["arr": ["a","b","c","d"], "dict": ["k1": "v1", "k2": "v2"]]
        let model = TestNetApi().toModel(TestModel.self, value: modelDict)!
        assert(model.a! == 1)
        assert(model.b! == "word")
        assert(model.c! == 1.0)
        assert(model.d! == true)
        assert(model.m!.arr! == ["a","b","c","d"])
        assert(model.m!.dict! == ["k1": "v1", "k2": "v2"])
        
        var modelDictNil: [String: Any]? = nil
        let nilModel = TestNetApi().toModel(TestModel.self, value: modelDictNil)
        assert(nilModel == nil)
        modelDictNil = modelDict
        let notNilModel = TestNetApi().toModel(TestModel.self, value: modelDictNil)
        assert(notNilModel != nil)

  }

}
