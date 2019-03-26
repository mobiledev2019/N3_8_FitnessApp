//
//  UIAlertController+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation
import UIKit

typealias SystemAlertButtonData = (title: String, style: UIAlertAction.Style, handler: (() -> Void)?)

// Extension for system alert view
extension UIAlertController {
    static func showQuickSystemAlert(target: UIViewController? = UIViewController.topViewController(),
                               title: String? = nil,
                               message: String? = nil,
                               cancelButtonTitle: String = "close".localized,
                               handler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            handler?()
        }))
        target?.present(alertVC, animated: true, completion: nil)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.topViewController(),
                          title: String? = nil,
                          message: String? = nil,
                          buttons: [String],
                          handler: ((_ index: Int, _ title: String) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                handler?(button.offset, button.element)
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true, completion: nil)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.topViewController(),
                          title: String? = nil,
                          message: String? = nil,
                          buttons: [SystemAlertButtonData]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach { button in
            let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
                button.handler?()
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true, completion: nil)
    }
    
    static func showSystemActionSheet(target: UIViewController? = UIViewController.topViewController(),
                                title: String? = nil,
                                message: String? = nil,
                                optionButtons: [SystemAlertButtonData],
                                cancelButton: SystemAlertButtonData) {
        let viewBG = UIView(frame: UIScreen.main.bounds)
        let backgroundColor = UIColor.black.withAlphaComponent(0.6)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        optionButtons.forEach { (button) in
            alert.addAction(UIAlertAction(title: button.title, style: button.style, handler: { (_) in
                viewBG.removeFromSuperview()
                button.handler?()
            }))
        }
        let cancelAction = UIAlertAction(title: cancelButton.title, style: UIAlertAction.Style.cancel, handler: { (_) in
            viewBG.removeFromSuperview()
            cancelButton.handler?()
        })
        alert.addAction(cancelAction)
        viewBG.backgroundColor = backgroundColor
        target?.view.addSubview(viewBG)
        target?.present(alert, animated: true, completion: nil)
    }
}
