//
//  APDeviceTests.swift
//  ApplepieTests
//
//  Created by 山天大畜 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import XCTest
import Applepie
import CoreTelephony

class APDeviceTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        APDevice.removeKeychainUUID()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        APDevice.removeKeychainUUID()
    }

    func testDevice() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("identifier: \(APDevice.identifier)")
        print("diagonal: \(APDevice.diagonal)")
        print("screenRatio: \(APDevice.screenRatio)")
        print("screenSize: \(APDevice.screenSize)")
        print("isPod: \(APDevice.isPod)")
        print("isPhone: \(APDevice.isPhone)")
        print("isPad: \(APDevice.isPad)")
        print("isSimulator: \(APDevice.isSimulator)")
        print("isTouchIDCapable: \(APDevice.isTouchIDCapable)")
        print("isFaceIDCapable: \(APDevice.isFaceIDCapable)")
        print("hasBiometricSensor: \(APDevice.hasBiometricSensor)")
        print("name: \(APDevice.name)")
        print("systemName: \(APDevice.systemName)")
        print("systemVersion: \(APDevice.systemVersion)")
        print("model: \(APDevice.model)")
        print("localizedModel: \(APDevice.localizedModel)")
        print("ppi: \(String(describing: APDevice.ppi))")
        print("isGuidedAccessSessionActive: \(APDevice.isGuidedAccessSessionActive)")
        print("screenBrightness: \(APDevice.screenBrightness)")
        print("lowPowerMode: \(APDevice.lowPowerMode)")
        print("batteryLevel: \(APDevice.batteryLevel)")
        print("isBatteryCharging: \(APDevice.isBatteryCharging)")
        print("orientationLandscape: \(APDevice.orientationLandscape)")
        print("orientationPortrait: \(APDevice.orientationPortrait)")
        print("volumeTotalCapacity: \(String(describing: APDevice.volumeTotalCapacity?.ap.toFormattedBytes))")
        print("volumeAvailableCapacity: \(String(describing: APDevice.volumeAvailableCapacity?.ap.toFormattedBytes))")
        if #available(iOS 11.0, *) {
            print("volumeAvailableCapacityForImportantUsage: \(String(describing: APDevice.volumeAvailableCapacityForImportantUsage?.ap.toFormattedBytes))")
            print("volumeAvailableCapacityForOpportunisticUsage: \(String(describing: APDevice.volumeAvailableCapacityForOpportunisticUsage?.ap.toFormattedBytes))")
            print("volumes: \(String(describing: APDevice.volumes))")
        }
        
        let keychainUUID = APDevice.keychainUUID
        print("keychainUUID: \(String(describing: APDevice.keychainUUID))")
        assert(keychainUUID == APDevice.keychainUUID)
        APDevice.removeKeychainUUID()
        print("keychainUUID2: \(String(describing: APDevice.keychainUUID))")
        assert(keychainUUID != APDevice.keychainUUID)
        let identifierForVendor = APDevice.identifierForVendor
        assert(identifierForVendor == APDevice.identifierForVendor)
        print("identifierForVendor: \(String(describing: APDevice.identifierForVendor))")
        let advertisingIdentifier = APDevice.advertisingIdentifier
        assert(advertisingIdentifier == APDevice.advertisingIdentifier)
        print("advertisingIdentifier: \(String(describing: APDevice.advertisingIdentifier))")
        print("isAdvertisingTrackingEnabled: \(APDevice.isAdvertisingTrackingEnabled)")
        print("isJailbreak: \(APDevice.isJailbreak)")
        
        
        print("carriers: \(String(describing: APDevice.carriers))")
        print("mainCarrierName: \(String(describing: APDevice.mainCarrierName))")
        print("mainMobileCountryCode: \(String(describing: APDevice.mainMobileCountryCode))")
        print("mainMobileNetworkCode: \(String(describing: APDevice.mainMobileNetworkCode))")
        print("mainIsoCountryCode: \(String(describing: APDevice.mainIsoCountryCode))")
        print("mainAllowsVOIP: \(String(describing: APDevice.mainAllowsVOIP))")
        print("currentRadioAccessTechnology: \(String(describing: APDevice.currentRadioAccessTechnology))")
        print("mainCurrentRadioAccessTechnology: \(String(describing: APDevice.mainCurrentRadioAccessTechnology))")
        
        assert(APDevice.getNetworkType(fromStatus: .notReachable) == .none)
        assert(APDevice.getNetworkType(fromStatus: .unknown) == .unknown)
        assert(APDevice.getNetworkType(fromStatus: .reachable(.ethernetOrWiFi)) == .wifi)
        print(APDevice.getNetworkType(fromStatus: .reachable(.wwan)))
        
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyEdge) == .cell2G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyGPRS) == .cell2G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyCDMA1x) == .cell2G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyHSDPA) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyWCDMA) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyHSUPA) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyCDMAEVDORev0) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyCDMAEVDORevA) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyCDMAEVDORevB) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyeHRPD) == .cell3G)
        assert(APNetWorkType.from(technology: CTRadioAccessTechnologyLTE) == .cell4G)
        
        let expectation = XCTestExpectation(description: "Complete")

        APDevice.networkType.done { networkType in
            print("networkType: \(String(describing: networkType))")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)

        print("timezone: \(String(describing: APDevice.timeZone))")

        print("description: \(APDevice.description)")
    }

}
