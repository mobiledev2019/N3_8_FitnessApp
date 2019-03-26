//
//  UIViewController+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func isModal() -> Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func set(view: UIView, toTopLayoutGuide topLayout: Bool, andBottomLayoutGuide bottomLayout: Bool) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        if topLayout {
            if let oldTop = self.view.constraints.filter({ $0.firstAttribute == .top && ($0.firstItem as? UIView) == view && ($0.secondItem as? UIView) == self.view }).first {
                self.view.removeConstraint(oldTop)
            }
            let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
            constraints.append(topConstraint)
        } else {
            if let oldBottom = self.view.constraints.filter({ $0.firstAttribute == .bottom && ($0.firstItem as? UIView) == self.view && ($0.secondItem as? UIView) == view }).first {
                self.view.removeConstraint(oldBottom)
            }
            let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
            constraints.append(bottomConstraint)
        }
        guard constraints.count > 0 else { return }
        self.view.addConstraints(constraints)
    }
}
