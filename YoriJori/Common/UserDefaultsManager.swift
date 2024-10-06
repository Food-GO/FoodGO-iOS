//
//  UserDefaultsManager.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init () {}
    
    private let userDefaults = UserDefaults.standard
    
    private let isFirstLaunchedKey = "isFirstLaunchedKey"
    var isFirstLaunched: Bool {
        set(newValue) {
            userDefaults.set(newValue, forKey: isFirstLaunchedKey)
        }
        get {
            if userDefaults.object(forKey: isFirstLaunchedKey) == nil {
                // 초기값 설정
                userDefaults.set(true, forKey: isFirstLaunchedKey)
                return true
            } else {
                return userDefaults.bool(forKey: isFirstLaunchedKey)
            }
        }
    }
    
    private let accesstokenKey = "accessTokenKey"
    var accesstoken: String {
        set(newValue) {
            userDefaults.setValue(newValue, forKey: accesstokenKey)
        }
        get {
            if let acesstoken = userDefaults.string(forKey: accesstokenKey) {
                return acesstoken
            } else {
                return ""
            }
        }
    }
    
    private let refreshtokenKey = "refreshtokenKey"
    var refreshtoken: String {
        set(newValue) {
            userDefaults.setValue(newValue, forKey: refreshtokenKey)
        }
        get {
            if let acesstoken = userDefaults.string(forKey: refreshtokenKey) {
                return acesstoken
            } else {
                return ""
            }
        }
    }
    
}
