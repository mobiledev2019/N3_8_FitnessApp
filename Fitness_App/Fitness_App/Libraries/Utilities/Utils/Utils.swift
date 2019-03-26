//
//  Utils.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    // Check sandbox enviroment or not
    #if DEVELOP || STAGING
    static let isSandboxEnviroment: Bool = true
    #else
    static let isSandboxEnviroment: Bool = false
    #endif
    
    // Sleep app with input time interval
    static func sleep(_ second: TimeInterval, completion: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
            completion()
        })
    }
    
    // Run code in main queue
    static func mainQueue(closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    // Do animation for constraint values
    static func animateForConstraint(fromView: UIView, duration: TimeInterval, action: @escaping (() -> Void), completion: (() -> Void)? = nil) {
        fromView.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            action()
            fromView.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}
