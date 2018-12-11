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

public struct APLocation {
    // Getting Current Location (one shot)
    public static func currentPosition(accuracy: Accuracy = .city, timeout: TimeInterval) -> Promise<CLLocation> {
        return currentPosition(accuracy: accuracy, timeout: .delayed(timeout))
    }
    public static func currentPosition(accuracy: Accuracy = .city, timeout: Timeout = .delayed(TimeInterval(Int.max))) -> Promise<CLLocation> {
        return Promise { sink in
            Locator.currentPosition(accuracy: accuracy, timeout: timeout, onSuccess: { location in
                sink.fulfill(location)
            }, onFail: { error, _ in
                sink.reject(error)
            })
        }
    }
    // Getting Current Location Without User Authorization (IP based)
    public static func currentPosition(usingIP: IPService, timeout: TimeInterval = TimeInterval(Int.max)) -> Promise<CLLocation> {
        return Promise { sink in
            Locator.currentPosition(usingIP: usingIP, timeout: timeout, onSuccess: { location in
                sink.fulfill(location)
            }, onFail: { error, _ in
                sink.reject(error)
            })
        }
    }
    public static var currentLocation: CLLocation? {
        return Locator.currentLocation
    }
    public static func transferToPlace(location: CLLocation) -> Promise<[CLPlacemark]?> {
        return Promise { sink in
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if let error = error {
                    sink.reject(error)
                    return
                }
                sink.fulfill(placemarks)
            })
        }
    }
    // force the request to complete early, like a manual timeout. It will execute the block (valid only for location requests)
    public static func stop() {
        return Locator.completeAllLocationRequests()
    }
    // Subscribing to continuous location updates
    public static func subscribePosition(accuracy: Accuracy = .house, onUpdate: @escaping (CLLocation?, Error?) -> Void) {
        Locator.subscribePosition(accuracy: accuracy, onUpdate: { location in
            onUpdate(location, nil)
        }) { error, _ in
            onUpdate(nil, error)
        }
    }
}
