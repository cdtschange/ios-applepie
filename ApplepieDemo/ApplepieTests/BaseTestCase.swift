//
//  BaseTestCase.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/9.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest

class BaseTestCase: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func url(forResource fileName: String, withExtension ext: String) -> URL {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.url(forResource: fileName, withExtension: ext)!
    }
}
