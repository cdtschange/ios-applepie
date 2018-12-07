//
//  APDevice.swift
//  Applepie
//
//  Created by 山天大畜 on 2018/12/6.
//  Copyright © 2018 山天大畜. All rights reserved.
//

import Foundation
import AdSupport
import AudioToolbox
import CoreTelephony
import DeviceKit
import Alamofire
import PromiseKit

public enum APNetWorkType {
    case none // 没有网络
    case cell2G // 2G
    case cell3G // 3G
    case cell4G // 4G
    case wifi // WIFI
    case unknown
    
    public static func from(technology: String) -> APNetWorkType {
        
        let typeStrings2G = [CTRadioAccessTechnologyEdge,
                             CTRadioAccessTechnologyGPRS,
                             CTRadioAccessTechnologyCDMA1x]
        
        let typeStrings3G = [CTRadioAccessTechnologyHSDPA,
                             CTRadioAccessTechnologyWCDMA,
                             CTRadioAccessTechnologyHSUPA,
                             CTRadioAccessTechnologyCDMAEVDORev0,
                             CTRadioAccessTechnologyCDMAEVDORevA,
                             CTRadioAccessTechnologyCDMAEVDORevB,
                             CTRadioAccessTechnologyeHRPD]
        
        let typeStrings4G = [CTRadioAccessTechnologyLTE]
        
        if typeStrings4G.contains(technology) {
            return .cell4G
        } else if typeStrings3G.contains(technology) {
            return .cell3G
        } else if typeStrings2G.contains(technology) {
            return .cell2G
        }
        return .unknown
    }
}

public struct APDevice {
    
    /// Gets the identifier from the system, such as "iPhone7,1".
    public static var identifier: String {
        return Device.identifier
    }
    public static var currentDevice: Device {
        return Device.mapToDevice(identifier: identifier)
    }
    public static var diagonal: Double {
        return currentDevice.diagonal
    }
    public static var screenRatio: (width: Double, height: Double) {
        return currentDevice.screenRatio
    }
    public static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    public static var isPod: Bool {
        return currentDevice.isPod
    }
    public static var isPhone: Bool {
        return currentDevice.isPhone
    }
    public static var isPad: Bool {
        return currentDevice.isPad
    }
    public static var isSimulator: Bool {
        return currentDevice.isSimulator
    }
    public static var isTouchIDCapable: Bool {
        return currentDevice.isTouchIDCapable
    }
    public static var isFaceIDCapable: Bool {
        return currentDevice.isFaceIDCapable
    }
    public static var hasBiometricSensor: Bool {
        return currentDevice.hasBiometricSensor
    }
    
    /// The name identifying the device (e.g. "Dennis' iPhone").
    public static var name: String {
        return currentDevice.name
    }
    /// The name of the operating system running on the device represented by the receiver (e.g. "iOS" or "tvOS").
    public static var systemName: String {
        return currentDevice.systemName
    }
    /// The current version of the operating system (e.g. 8.4 or 9.2).
    public static var systemVersion: String {
        return currentDevice.systemVersion
    }
    /// The model of the device (e.g. "iPhone" or "iPod Touch").
    public static var model: String {
        return currentDevice.model
    }
    /// The model of the device as a localized string.
    public static var localizedModel: String {
        return currentDevice.localizedModel
    }
    /// PPI (Pixels per Inch) on the current device's screen (if applicable). When the device is not applicable this property returns nil.
    public static var ppi: Int? {
        return currentDevice.ppi
    }
    /// True when a Guided Access session is currently active; otherwise, false.
    public static var isGuidedAccessSessionActive: Bool {
        return currentDevice.isGuidedAccessSessionActive
    }
    /// The brightness level of the screen.
    public static var screenBrightness: Int {
        return currentDevice.screenBrightness
    }
    /// The user enabled Low Power mode
    public static var lowPowerMode: Bool {
        return currentDevice.batteryState.lowPowerMode
    }
    /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
    public static var batteryLevel: Int {
        return currentDevice.batteryLevel
    }
    /// The device is plugged into power and the battery is less than 100% charged.
    public static var isBatteryCharging: Bool {
        return currentDevice.batteryState == .charging(batteryLevel)
    }
    /// Landscape: The device is in Landscape Orientation
    public static var orientationLandscape: Bool {
        return currentDevice.orientation == .landscape
    }
    /// Portrait: The device is in Portrait Orientation
    public static var orientationPortrait: Bool {
        return currentDevice.orientation == .portrait
    }
    /// The volume’s total capacity in bytes.
    public static var volumeTotalCapacity: Int? {
        return Device.volumeTotalCapacity
    }
    /// The volume’s available capacity in bytes.
    public static var volumeAvailableCapacity: Int? {
        return Device.volumeAvailableCapacity
    }
    /// The volume’s available capacity in bytes for storing important resources.
    @available(iOS 11.0, *)
    public static var volumeAvailableCapacityForImportantUsage: Int64? {
        return Device.volumeAvailableCapacityForImportantUsage
    }
    /// The volume’s available capacity in bytes for storing nonessential resources.
    @available(iOS 11.0, *)
    public static var volumeAvailableCapacityForOpportunisticUsage: Int64? {
        return Device.volumeAvailableCapacityForOpportunisticUsage
    }
    /// All volumes capacity information in bytes.
    @available(iOS 11.0, *)
    public static var volumes: [URLResourceKey: Int64]? {
        return Device.volumes
    }
    
    private static var keychain = APKeychain(identifier: "com.cdts.applepie")
    
    public static func removeKeychainUUID() {
        keychain.removeObject(forKey: "KeychainUUID")
    }
    
    public static var keychainUUID: String? {
        if let uuid = keychain.string(forKey: "KeychainUUID"), uuid.count > 0 {
            return uuid
        }
        let uuid = UUID().uuidString
        keychain.set(string: uuid, forKey: "KeychainUUID")
        return uuid
    }
    //获取标识符供应商 The value in this property remains the same while the app (or another app from the same vendor) is installed on the iOS device. The value changes when the user deletes all of that vendor’s apps from the device and subsequently reinstalls one or more of them.
    public static var identifierForVendor: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    //获取应用广告标识符 An alphanumeric string unique to each device, used only for serving advertisements.
    public static var advertisingIdentifier: String? {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    //A Boolean value that indicates whether the user has limited ad tracking.
    public static var isAdvertisingTrackingEnabled: Bool {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled
    }
    
    public static var isJailbreak: Bool {
        let cydiaPath = "/Applications/Cydia.app"
        let aptPath = "/private/var/lib/apt"
        return FileManager.default.fileExists(atPath: cydiaPath) || FileManager.default.fileExists(atPath: aptPath)
    }
    
    // 运营商
    public static var carriers: [String: CTCarrier]? {
        var map: [String: CTCarrier]? = nil
        
        if #available(iOS 12.0, *) {
            map = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders
        }
        return map
    }
    // 运营商名
    public static var mainCarrierName: String? {
        return carriers?.first?.value.carrierName
    }
    // 移动国家码(MCC)
    public static var mainMobileCountryCode: String? {
        return carriers?.first?.value.mobileCountryCode
    }
    // 移动网络码(MNC)
    public static var mainMobileNetworkCode: String? {
        return carriers?.first?.value.mobileNetworkCode
    }
    // ISO国家代码
    public static var mainIsoCountryCode: String? {
        return carriers?.first?.value.isoCountryCode
    }
    // 是否允许VoIP
    public static var mainAllowsVOIP: Bool? {
        return carriers?.first?.value.allowsVOIP
    }
    
    // 网络制式
    public static var currentRadioAccessTechnology: [String: String]? {
        var map: [String: String]? = nil
        
        if #available(iOS 12.0, *) {
            map = CTTelephonyNetworkInfo().serviceCurrentRadioAccessTechnology
        }
        return map
    }
    // 网络制式
    public static var mainCurrentRadioAccessTechnology: String? {
        return currentRadioAccessTechnology?.first?.value
    }
    
    public static var networkType: Guarantee<APNetWorkType> {
        return APNetClient.getNetworkStatus().map { status in
            return getNetworkType(fromStatus: status)
        }
    }
    
    public static func getNetworkType(fromStatus status: NetworkReachabilityManager.NetworkReachabilityStatus) -> APNetWorkType {
        switch(status) {
        case .notReachable:
            return .none
        case .reachable(.ethernetOrWiFi):
            return .wifi
        case .reachable(.wwan):
            return APNetWorkType.from(technology: mainCurrentRadioAccessTechnology ?? "")
        case .unknown:
            return .unknown
        }
    }
    
    
    public static var timeZone: String? {
        return TimeZone.current.abbreviation()
    }
    
    
    
    
    /// A textual representation of the device.
    public static var description: String {
        return currentDevice.description
    }
}
