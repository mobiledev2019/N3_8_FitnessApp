//
//  UIApplication+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//
import UIKit

extension UIApplication {
    var statusBar: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    static func setStatusBar(backgroundColor: UIColor, tintColor: UIColor) {
        guard let statusBar = UIApplication.shared.statusBar else { return }
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = backgroundColor
            statusBar.tintColor = tintColor
        }
    }
    
    static func setStatusBar(backgroundImage: UIImage?, tintColor: UIColor) {
        guard let statusBar = UIApplication.shared.statusBar else { return }
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            let imageView = UIImageView(image: backgroundImage)
            statusBar.tintColor = tintColor
            statusBar.addSubview(imageView)
            imageView.layer.zPosition = -10000
            AutoLayoutHelper.fit(imageView, superView: statusBar)
        }
    }
}

