//
//  APLocation.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/10.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import SwiftLocation
import PromiseKit
import CoreLocation
import CocoaLumberjack

public struct APLocation {
    // Getting Current Location (one shot)
    public static func currentPosition(accuracy: LocationManager.Accuracy = .city, timeout: TimeInterval) -> Promise<CLLocation> {
        return currentPosition(accuracy: accuracy, timeout: .delayed(timeout))
    }
    public static func currentPosition(accuracy: LocationManager.Accuracy = .city, timeout: Timeout.Mode = .delayed(TimeInterval(Int.max))) -> Promise<CLLocation> {
        DDLogInfo("[APLocaiton] GPS OneShot Start")
        return Promise { sink in
            LocationManager.shared.locateFromGPS(.oneShot, accuracy: accuracy, timeout: timeout) { result in
                DDLogInfo("[APLocaiton] GPS OneShot Data: \(result)")
                switch result {
                case .success(let location):
                    sink.fulfill(location)
                case .failure(let error):
                    sink.reject(error)
                }
            }
        }
    }
    // Getting Current Location Without User Authorization (IP based)
    public static func currentPosition(usingIP: LocationByIPRequest.Service, timeout: Timeout.Mode = .delayed(TimeInterval(Int.max))) -> Promise<IPPlace> {
        DDLogInfo("[APLocaiton] IP Start")
        return Promise { sink in
            LocationManager.shared.locateFromIP(service: usingIP, timeout: timeout) { result in
                DDLogInfo("[APLocaiton] IP Data: \(result)")
                switch result {
                case .success(let place):
                    sink.fulfill(place)
                case .failure(let error):
                    sink.reject(error)
                }
            }
        }
    }
    public static var currentLocation: CLLocation? {
        return LocationManager.shared.lastLocation
    }
    public static func transferToPlace(location: CLLocation) -> Promise<[CLPlacemark]?> {
        return Promise { sink in
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let error = error {
                    sink.reject(error)
                    print("\(error.localizedDescription)")
                    return
                }
                sink.fulfill(placemarks)
            })
        }
    }
    // force the request to complete early, like a manual timeout. It will execute the block (valid only for location requests)
    public static func stop() {
        DDLogInfo("[APLocaiton] Stop")
        return LocationManager.shared.completeAllLocationRequest()
    }
    // Subscribing to continuous location updates
    public static func subscribePosition(accuracy: LocationManager.Accuracy = .house, onUpdate: @escaping (CLLocation?, Error?) -> Void) {
        DDLogInfo("[APLocaiton] GPS Continous Start")
        LocationManager.shared.locateFromGPS(.continous, accuracy: accuracy) { result in
        DDLogInfo("[APLocaiton] GPS Continous Data: \(result)")
            switch result {
            case .success(let location):
                onUpdate(location, nil)
            case .failure(let error):
                onUpdate(nil, error)
            }
        }
    }
}
