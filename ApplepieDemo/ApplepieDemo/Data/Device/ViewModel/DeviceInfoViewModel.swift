//
//  DeviceInfoViewModel.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit

class DeviceInfoViewModel: BaseListViewModel {
    private var _repository = DeviceInfoRepository()
    override var repository: APBaseRepository? {
        return _repository
    }
    
    override func fetchData() -> Promise<Any> {
        return Promise { sink in
            sink.fulfill(_repository.fetchData())
            }.map { [weak self] data in
                self?.appendDataArray(data)
                return data
        }
    }
    func fetchNetwork() -> Promise<APNetWorkType> {
        return _repository.fetchNetwork()
    }
}
