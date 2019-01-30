//
//  NetworkViewModel.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import PromiseKit
import Applepie

class NetworkViewModel: BaseViewModel {
    
    private var _repository = NetworkRepository()
    override var repository: APBaseRepository? {
        return _repository
    }

    func fetchData(_ method: NetworkType) -> Promise<[String: Any]?> {
        return _repository.fetchData(method).map { api in
            api.result
        }
    }
}
