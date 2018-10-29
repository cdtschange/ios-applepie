//
//  StringCryptoTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2018/10/26.
//  Copyright © 2018 毛蔚. All rights reserved.
//

import XCTest

class StringCryptoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCer() {
        let cerPath = Bundle.main.path(forResource: "demo", ofType: "crt")
        let data = try! Data(contentsOf: URL(fileURLWithPath: cerPath!))
        let hash = data.ap.hashWithRSA2048Asn1Header(.sha1)
        assert(hash == "f3c26c86b34e51dd6163e4e45b9e262542805708")
    }

    func testEncrypt() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let value = "Hello world!"
        assert(value.ap.encrypt(.md5) == "86fb269d190d2c85f6e0468ceca42a20")
        assert(value.ap.encrypt(.sha1) == "d3486ae9136e7856bc42212385ea797094475802")
        assert(value.ap.encrypt(.sha224) == "7e81ebe9e604a0c97fef0e4cfe71f9ba0ecba13332bde953ad1c66e4")
        assert(value.ap.encrypt(.sha256) == "c0535e4be2b79ffd93291305436bf889314e4a3faec05ecffcbb7df31ad9e51a")
        assert(value.ap.encrypt(.sha384) == "86255fa2c36e4b30969eae17dc34c772cbebdfc58b58403900be87614eb1a34b8780263f255eb5e65ca9bbb8641cccfe")
        assert(value.ap.encrypt(.sha512) == "f6cde2a0f819314cdde55fc227d8d7dae3d28cc556222a0a8ad66d91ccad4aad6094f517a2182360c9aacf6a3dc323162cb6fd8cdffedb0fe038f55e85ffb5b6")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
