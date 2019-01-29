//
//  ListTypeViewModel.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/29.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit

class ListTypeViewModel: BaseListViewModel {

    private var _repository = ListTypeRepository()
    override var repository: APBaseRepository? {
        return _repository
    }
    
    override func fetchData() -> Promise<Any> {
        return _repository.fetchData(index: Int(dataIndex * listLoadNumber), size: Int(listLoadNumber)).map { [weak self] data in
            self?.appendDataArray(data)
            return data
        }
    }
}
