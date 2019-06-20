//
//  SharedData.swift
//  PtitMe
//
//  Created by kienpt on 2/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation
import UIKit

class SharedData {
    // Device token
    class var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "AccessToken")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "AccessToken")
        }
    }
    
    class var isUserAppFirst: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IsUserAppFirst")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "IsUserAppFirst")
        }
    }
}

extension UserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    // Note: Store this value in AppDelegate if you have multiple places where you are checking for this flag
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
