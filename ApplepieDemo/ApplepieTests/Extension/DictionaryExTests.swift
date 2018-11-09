//
//  DictionaryExTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest

class DictionaryExTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQueryString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let dict: [String: Any] = ["int": 1, "string": "word+", "bool": true, "double": 1.0]
        let dictString = "int=1&string=word%2B&bool=true&double=1.0"
        assert(dict.ap.queryString.contains("int=1"))
        assert(dict.ap.queryString.contains("string=word%2B"))
        assert(dict.ap.queryString.contains("bool=true"))
        assert(dict.ap.queryString.contains("double=1.0"))
        assert(dict.ap.queryString.ap.queryDictionary == dict.mapValues{ "\($0)" })
        assert(dictString.ap.queryDictionary == dict.mapValues{ "\($0)" })
    }


}
