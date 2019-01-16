//
//  APBaseListViewModelTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2019/1/16.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import PromiseKit

class APBaseListViewModelTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModel() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let viewModel = APBaseListViewModel()
        assert(viewModel.dataArray.count == 0)
        viewModel.appendDataArray([1, 2, 3])
        viewModel.dataIndex += 1
        assert(viewModel.dataArray.count == 3)
        viewModel.appendDataArray([4, 5])
        viewModel.dataIndex += 1
        assert(viewModel.dataArray.count == 5)
        
        viewModel.dataIndex = 0
        viewModel.appendDataArray([6, 7])
        assert(viewModel.dataArray.count == 2)
        viewModel.dataIndex = 0
        viewModel.appendDataArray(nil)
        assert(viewModel.dataArray.count == 0)
        
    }

}
