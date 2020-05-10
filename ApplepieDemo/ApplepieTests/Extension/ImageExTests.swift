//
//  ImageExTests.swift
//  ApplepieTests
//
//  Created by 毛蔚 on 2020/5/10.
//  Copyright © 2020 山天大畜. All rights reserved.
//

import XCTest
import Applepie

class ImageExTests: BaseTestCase {
    func testBase64() throws {
        let code = APImages.arrowLeft.image!.ap.toBase64()
        let _ = code.ap.base64ToImage()!.ap.toBase64()
    }

}
