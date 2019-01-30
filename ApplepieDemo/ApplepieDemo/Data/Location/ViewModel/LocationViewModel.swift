//
//  LocationViewModel.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit
import CoreLocation
import ReactiveSwift

class LocationViewModel: BaseListViewModel {
    private var _repository = LocationRepository()
    override var repository: APBaseRepository? {
        return _repository
    }
    
    var continuesLocation: MutableProperty<CLLocation?> {
        return _repository.continuesLocation
    }
    
    override func fetchData() -> Promise<Any> {
        return Promise { sink in
            sink.fulfill(_repository.fetchData())
            }.map { [weak self] data in
                self?.appendDataArray(data)
                return data
        }
    }
    func fetchGPSLocation() -> Promise<CLLocation> {
        return _repository.fetchGPSLocation()
    }
    func fetchIPLocation() -> Promise<CLLocation> {
        return _repository.fetchIPLocation()
    }
    func fetchContinuesLocation() {
        _repository.fetchContinuesLocation()
    }
    func fetchAddress() -> Promise<String?> {
        return _repository.fetchAddress()
    }
}
