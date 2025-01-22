//
//  RECCore.swift
//  Recommend
//
//  Created by Dmytrii Golovanov on 07.12.2021.
//  Copyright © 2022 Recommend OÜ. All rights reserved.
//

import Foundation
import UIKit.UIDevice

final class RECCore {
    public static let keychainAccount: String = "Recommend_keychain_account"
    public static let keychainService: String = "Recommend_keychain_service"
    let device: UIDevice = .current
    let accountId: String
    let userDefaults: UserDefaults
    let customerInfo: RECCustomerInfo
    let apiClient: RECAPIClient
    
    // MARK: Init
    
    init(configuration: RECConfiguration) {
        do {
            guard configuration.accountId.isEmpty == false else {
                throw RECInvalidAccountIdError()
            }
            self.accountId = configuration.accountId
            
            guard let userDefaults = UserDefaults(suiteName: "Recommend") else {
                throw RECInvalidUserDefaultsError()
            }
            self.userDefaults = userDefaults
            
            self.customerInfo = RECCustomerInfo(userDefaults: userDefaults)
            
            let apiConfiguration = RECAPIConfiguration(host: configuration.apiHost)
            self.apiClient = RECAPIClient(configuration: apiConfiguration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: Customer Info
    
    func clearCustomerInfo() {
        customerInfo.clear()
    }
    
    // MARK: Device Id
    
    func getDeviceId() throws -> String {
        let device = UIDevice.current
        var deviceId: String?
        let storedKeychainDeviceId = RECKeychainService.getItem(service: Self.keychainService, account: Self.keychainAccount)
        let storedDefaultsDeviceId = userDefaults.deviceId
        
        if let storedDefaultsDeviceId,
           !storedDefaultsDeviceId.isEmpty {
            deviceId = storedDefaultsDeviceId
        } else if let storedKeychainDeviceId,
                  !storedKeychainDeviceId.isEmpty {
            deviceId = storedKeychainDeviceId
        } else {
            print("failed: get any prev deviceID, generating new....")
            deviceId = device.identifierForVendor?.uuidString ?? UUID().uuidString
        }
        
        guard let deviceId,
              deviceId.isEmpty == false else {
            throw RECInvalidDeviceIdError(deviceId: deviceId)
        }
        
        userDefaults.deviceId = deviceId
        if storedKeychainDeviceId != nil {
            RECKeychainService.updateItem(service: Self.keychainService, account: Self.keychainAccount, data: deviceId)
        } else {
            RECKeychainService.saveItem(service: Self.keychainService, account: Self.keychainAccount, data: deviceId)
        }
        
        return deviceId
    }
    
    // MARK: First Launch
    
    private(set) lazy var isFirstLaunch: Bool = {
        var isFirstLaunch: Bool!
        var newValue: Bool?
        
        if let value = userDefaults.isFirstLaunch {
            isFirstLaunch = value
        }
        
        if isFirstLaunch == nil {
            newValue = true
        } else if isFirstLaunch == true {
            newValue = false
        }
        
        if let newValue = newValue {
            isFirstLaunch = newValue
            userDefaults.isFirstLaunch = newValue
        }
        
        return isFirstLaunch
    }()
}

// MARK: - UserDefaults

fileprivate extension UserDefaults {
    private static let deviceIdKey = "DEVICE_ID"
    var deviceId: String? {
        get {
            string(forKey: Self.deviceIdKey)
        }
        set {
            set(newValue, forKey: Self.deviceIdKey)
        }
    }
    
    private static let isFirstLaunchKey = "IS_FIRST_LAUNCH"
    var isFirstLaunch: Bool? {
        get {
            value(forKey: Self.isFirstLaunchKey) as? Bool
        }
        set {
            set(newValue, forKey: Self.isFirstLaunchKey)
        }
    }
}
