//
//  DeviceInfoRepository.swift
//  ApplepieDemo
//
//  Created by 毛蔚 on 2019/1/30.
//  Copyright © 2019 山天大畜. All rights reserved.
//

import UIKit
import Applepie
import PromiseKit

class DeviceInfoRepository: BaseRepository {
    
    var networkType: APNetWorkType?
    
    func fetchData() -> [DeviceInfoModel] {
        var data = [
        DeviceInfoModel(title: "identifier", detail: APDevice.identifier),
        DeviceInfoModel(title: "diagonal", detail: APDevice.diagonal),
        DeviceInfoModel(title: "screenRatio", detail: APDevice.screenRatio),
        DeviceInfoModel(title: "screenSize", detail: APDevice.screenSize),
        DeviceInfoModel(title: "isPod", detail: APDevice.isPod),
        DeviceInfoModel(title: "isPhone", detail: APDevice.isPhone),
        DeviceInfoModel(title: "isPad", detail: APDevice.isPad),
        DeviceInfoModel(title: "isSimulator", detail: APDevice.isSimulator),
        DeviceInfoModel(title: "isTouchIDCapable", detail: APDevice.isTouchIDCapable),
        DeviceInfoModel(title: "isFaceIDCapable", detail: APDevice.isFaceIDCapable),
        DeviceInfoModel(title: "hasBiometricSensor", detail: APDevice.hasBiometricSensor),
        DeviceInfoModel(title: "name", detail: APDevice.name),
        DeviceInfoModel(title: "systemName", detail: APDevice.systemName),
        DeviceInfoModel(title: "systemVersion", detail: APDevice.systemVersion),
        DeviceInfoModel(title: "model", detail: APDevice.model),
        DeviceInfoModel(title: "localizedModel", detail: APDevice.localizedModel),
        DeviceInfoModel(title: "ppi", detail: String(describing: APDevice.ppi)),
        DeviceInfoModel(title: "isGuidedAccessSessionActive", detail: APDevice.isGuidedAccessSessionActive),
        DeviceInfoModel(title: "screenBrightness", detail: APDevice.screenBrightness),
        DeviceInfoModel(title: "lowPowerMode", detail: APDevice.lowPowerMode),
        DeviceInfoModel(title: "batteryLevel", detail: APDevice.batteryLevel),
        DeviceInfoModel(title: "isBatteryCharging", detail: APDevice.isBatteryCharging),
        DeviceInfoModel(title: "orientationLandscape", detail: APDevice.orientationLandscape),
        DeviceInfoModel(title: "orientationPortrait", detail: APDevice.orientationPortrait),
        DeviceInfoModel(title: "volumeTotalCapacity", detail: String(describing: APDevice.volumeTotalCapacity?.ap.toFormattedBytes)),
        DeviceInfoModel(title: "volumeAvailableCapacity", detail: String(describing: APDevice.volumeAvailableCapacity?.ap.toFormattedBytes))]
        
        if #available(iOS 11.0, *) {
            data.append(DeviceInfoModel(title: "volumeAvailableCapacityForImportantUsage", detail: String(describing: APDevice.volumeAvailableCapacityForImportantUsage?.ap.toFormattedBytes)))
            data.append(DeviceInfoModel(title: "volumeAvailableCapacityForOpportunisticUsage", detail: String(describing: APDevice.volumeAvailableCapacityForOpportunisticUsage?.ap.toFormattedBytes)))
            data.append(DeviceInfoModel(title: "volumes", detail: String(describing: APDevice.volumes)))
        }
        let data2 = [
        DeviceInfoModel(title: "keychainUUID", detail: String(describing: APDevice.keychainUUID)),
        DeviceInfoModel(title: "identifierForVendor", detail: String(describing: APDevice.identifierForVendor)),
        DeviceInfoModel(title: "advertisingIdentifier", detail: String(describing: APDevice.advertisingIdentifier)),
        DeviceInfoModel(title: "isAdvertisingTrackingEnabled", detail: APDevice.isAdvertisingTrackingEnabled),
        DeviceInfoModel(title: "isJailbreak", detail: APDevice.isJailbreak),
        
        
        DeviceInfoModel(title: "carriers", detail: String(describing: APDevice.carriers)),
        DeviceInfoModel(title: "mainCarrierName", detail: String(describing: APDevice.mainCarrierName)),
        DeviceInfoModel(title: "mainMobileCountryCode", detail: String(describing: APDevice.mainMobileCountryCode)),
        DeviceInfoModel(title: "mainMobileNetworkCode", detail: String(describing: APDevice.mainMobileNetworkCode)),
        DeviceInfoModel(title: "mainIsoCountryCode", detail: String(describing: APDevice.mainIsoCountryCode)),
        DeviceInfoModel(title: "mainAllowsVOIP", detail: String(describing: APDevice.mainAllowsVOIP)),
        DeviceInfoModel(title: "currentRadioAccessTechnology", detail: String(describing: APDevice.currentRadioAccessTechnology)),
        DeviceInfoModel(title: "mainCurrentRadioAccessTechnology", detail: String(describing: APDevice.mainCurrentRadioAccessTechnology)),
        
        DeviceInfoModel(title: "networkType", detail: networkType?.rawValue),
        DeviceInfoModel(title: "timezone", detail: String(describing: APDevice.timeZone))]
        
        data = data + data2
        return data
    }
    
    func fetchNetwork() -> Promise<APNetWorkType> {
        return APDevice.networkType.map { [weak self] networkType in
            self?.networkType = networkType
            return networkType
        }
    }
}

struct DeviceInfoModel {
    var title: String
    var detail: Any?
}
