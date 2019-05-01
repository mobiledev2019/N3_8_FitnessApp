//
//  TabbarVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/28/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    
    //instance navigation controller
    class func newNavigationController() -> UINavigationController {
        return TabbarVC.newNavigationControllerFromStoryboard(withStoryboardIdentifier: "TabbarVC", storyboardName: "Main")
    }
    
    //instance view controller
    class func newController() -> TabbarVC {
        if let tabbarViewController = TabbarVC.newControllerFromStoryboard(withStoryboardIdentifier: "TabbarVC", storyboardName: "Main") as? TabbarVC {
            return tabbarViewController
        }
        return TabbarVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNavigationColor(barTintColor: UIColor.white, tintColor: UIColor.black)
        
        //set up Tab bar Item
        setupTabbarItem()
        
        // Register notification
//        NotificationCenter.default.addObserver(self, selector: #selector(shouldEnableTabbar(notification:)), name: Notification.Name(NotificationKey.tabbarEnable), object: nil)
    }
    
    private func setupTabbarItem() {
        
        setupTabbarColor()
        
        let homeVC = HomeVC.newNavigationController()
        homeVC.title = NSLocalizedString("home", comment: "")
        homeVC.tabBarItem.title = NSLocalizedString("home", comment: "")
        homeVC.tabBarItem.image = UIImage(named: "ic_home")
        
        let settingVC = TrackingFitnessVC.newNavigationController()
        settingVC.title = NSLocalizedString("setting", comment: "")
        settingVC.tabBarItem.title = NSLocalizedString("setting", comment: "")
        settingVC.tabBarItem.image = UIImage(named: "ic_calendar")
        
        let profileVC = ProfileVC.newNavigationController()
        profileVC.title = NSLocalizedString("profile", comment: "")
        profileVC.tabBarItem.title = NSLocalizedString("profile", comment: "")
        profileVC.tabBarItem.image = UIImage(named: "ic_setting")
        
        let controllers = [homeVC, settingVC, profileVC]
        self.viewControllers = controllers
    }
    
    private func setupTabbarColor() {
        
        let tabbarApperance = UITabBar.appearance()
        tabbarApperance.tintColor = UIColor.Custom.AppGreen
        tabbarApperance.unselectedItemTintColor = UIColor.Custom.AppGray
        //tabbarApperance.barTintColor = UIColor.Custom.AppRed
        tabbarApperance.isTranslucent = false
    }
    
    @objc func shouldEnableTabbar(notification: Notification) {
        if let isEnable = notification.object as? Bool {
            if let items = self.tabBar.items {
                for item in items {
                    item.isEnabled = isEnable
                }
            }
        }
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name(NotificationKey.tabbarEnable), object: nil)
    }
}


