//
//  LocationRepository.swift
//  ApplepieDemo
//
//  Created by 山天大畜 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit
import CoreLocation
import CocoaLumberjack
import ReactiveSwift

class LocationRepository: BaseRepository {
    
    var currentLocation: CLLocation? {
        return APLocation.currentLocation
    }
    var gpsLocation: CLLocation?
    var ipLocation: CLLocation?
    var continuesLocation: MutableProperty<CLLocation?> = MutableProperty(nil)
    var address: String?
    
    func fetchData() -> [LocationModel] {
        return [
            LocationModel(title: "Current Location", detail: currentLocation),
            LocationModel(title: "Current Address", detail: address),
            LocationModel(title: "GPS Location", detail: gpsLocation),
            LocationModel(title: "IP Location", detail: ipLocation),
            LocationModel(title: "Continues Location", detail: continuesLocation.value),
        ]
    }
    
    func fetchGPSLocation() -> Promise<CLLocation> {
        return APLocation.currentPosition(timeout: .after(10)).map { [weak self] location in
            self?.gpsLocation = location
            return location
        }
    }
    func fetchIPLocation() -> Promise<CLLocation> {
        return APLocation.currentPosition(usingIP: .ipApi).map { [weak self] location in
            self?.ipLocation = location
            return location
        }
    }
    func fetchContinuesLocation() {
        APLocation.subscribePosition(onUpdate: { [weak self] (location, error) in
            self?.continuesLocation.value = location
            if let error = error {
                DDLogError("[Location] Error: \(error)")
            }
        })
    }
    func fetchAddress() -> Promise<String?> {
        guard currentLocation != nil else {
            return Promise { sink in
                sink.fulfill(nil)
            }
        }
        return APLocation.transferToPlace(location: currentLocation!).map { [weak self] placemarks in
            if let place = placemarks?.first?.addressDictionary {
                self?.address = "\((place["FormattedAddressLines"] as? [String])?.joined(separator: ", ") ?? "")"
            }
            return self?.address
        }
    }
    func stopLocation() {
        APLocation.stop()
    }
    
    deinit {
        stopLocation()
    }

}

struct LocationModel {
    var title: String
    var detail: Any?
}

