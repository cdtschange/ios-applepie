//
//  MenuListViewModel.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/14.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit
import Applepie

class MenuListViewModel: BaseListViewModel {
    var type: MenuType = .none
    
    private var _repository = MenuListRepository()
    override var repository: APBaseRepository? {
        return _repository
    }
    
    override func fetchData() -> Promise<Any> {
        return _repository.fetchMenus(type: type).map { [weak self] data in
            self?.appendDataArray(data)
            return data
        }
    }
}
