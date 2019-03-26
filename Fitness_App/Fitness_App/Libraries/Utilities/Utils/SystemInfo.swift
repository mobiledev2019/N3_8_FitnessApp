//
//  SystemInfo.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

// MARK: - Screen information
class SystemInfo {
    static let screenBounds = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenNativeBounds = UIScreen.main.nativeBounds
    static let screenNativeWidth = UIScreen.main.nativeBounds.width
    static let screenNativeHeight = UIScreen.main.nativeBounds.height
    
    static let iphone3point5InchesHeight: CGFloat = 480 // iphone 4s and below
    static let iphone4InchesHeight: CGFloat = 568 // iphone 4s -> iphone 5s || iphone SE
    static let iphone4point7InchesHeight: CGFloat = 667 // iphone 6 & 7 & 8
    static let iphone5point5InchesHeight: CGFloat = 736 // iphone 6+ & 7+ & 8+
    static let iphone5point8InchesHeight: CGFloat = 812 // iphone X
    static let iphone6point5InchesHeight: CGFloat = 896 // iphone XS Max
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static var safeAreaInsetTop: CGFloat {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0
    }
    static var safeAreaInsetBottom: CGFloat {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0
    }
}

// MARK: - App general information
extension SystemInfo {
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let schemeName = ProcessInfo.processInfo.environment["targetName"] ?? ""
    static let osName = UIDevice.current.systemName
    static let osVersion = UIDevice.current.systemVersion
    static var appIdOnAppStore: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    static var appInfoOnAppStoreUrl: URL? {
        if let appId = SystemInfo.appIdOnAppStore {
            let urlStr = String(format: "http://itunes.apple.com/lookup?bundleId=%@", appId)
            return URL(string: urlStr)
        }
        return nil
    }
    // Access app icon value
    class var appIconValue: Int {
        get { return UIApplication.shared.applicationIconBadgeNumber }
        set(value) { UIApplication.shared.applicationIconBadgeNumber = value }
    }
}

// MARK: - Other information
extension SystemInfo {
    static let shiftJISEncoding = String.Encoding.shiftJIS
    static let utf8Encoding = String.Encoding.utf8
}
