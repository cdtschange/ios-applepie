//
//  StringExTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/11/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class StringExTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddingPercentEncodingForUrlQueryValue() {
        let str = "+&%$!"
        assert("%2B%26%25%24%21" == str.ap.addingPercentEncodingForUrlQueryValue())
    }
    
    func testLocalizeString() {
        let str = "abc"
        assert(str.ap.localized == "abc")
        assert(str.ap.localized(tableName: "test") == "abc")
        assert(str.ap.localized(withComment: "test") == "abc")
    }
    
    func testNSAttributeString() {
        let str = "abc"
        let font = UIFont.systemFont(ofSize: 12)
        let lineSpacing: CGFloat = 2.0
        let color = UIColor.green
        let attr = str.ap.attributedString(withFont: font, lineSpacing: lineSpacing, alignment: .left, textColor: color)
        let dict = attr.attributes(at: 0, effectiveRange: nil)
        assert((dict[.font] as? UIFont) == font)
        assert((dict[.foregroundColor] as? UIColor) == color)
        assert((dict[.paragraphStyle] as? NSMutableParagraphStyle)?.lineSpacing == lineSpacing)
        assert((dict[.paragraphStyle] as? NSMutableParagraphStyle)?.alignment == .left)
        print("".ap.attributedString(withFont: font, lineSpacing: 2))
        print(str.ap.attributedString(withFont: font, lineSpacing: lineSpacing))
    }
    
    func testCalculateHeight() {
        let str = "asjhdflakjhflkajdhfalkjhfdsafh"
        assert(abs(str.ap.calculateHeight(withWidth: 10) - 318.0) < 1)
        assert(abs(str.ap.calculateHeight(withWidth: 20) - 124.0) < 1)
        assert(abs(str.ap.calculateHeight(withWidth: 30) - 83.0) < 1)
        assert(abs(str.ap.calculateHeight(withWidth: 40) - 69.0) < 1)
        assert(abs(str.ap.calculateHeight(withWidth: 50) - 55.0) < 1)
    }

}
