//
//  IndicatorViewModel.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit
import Applepie

class IndicatorViewModel: BaseListViewModel {

    private var _repository = IndicatorRepository()
    override var repository: APBaseRepository? {
        return _repository
    }
    
    override func fetchData() -> Promise<Any> {
        return _repository.fetchData().map { [weak self] data in
            self?.appendDataArray(data)
            return data
        }
    }
}
