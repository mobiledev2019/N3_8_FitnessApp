//
//  SystemBoots.swift
//  PtitMe
//
//  Created by kienpt on 10/30/18.
//  Copyright © 2018 Mobileteam. All rights reserved.
//

import UIKit

class SystemBoots {
    
    // MARK: - Singleton
    static let instance = SystemBoots()
    
    // MARK: - Variables
    weak var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - Actions
    func changeRoot(window: inout UIWindow?, rootController: UIViewController) {
        // Setup app's window
        guard window == nil else {
            window?.rootViewController = rootController
            window?.makeKeyAndVisible()
            return
        }
        window = UIWindow(frame: SystemInfo.screenBounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
}
