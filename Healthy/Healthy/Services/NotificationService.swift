//
//  NotificationService.swift
//  PtitMe
//
//  Created by kienpt on 10/30/18.
//  Copyright © 2018 Mobileteam. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON

class NotificationService: NSObject {
    
    // MARK: - Singleton
    static var instance = NotificationService()
    
    // Cache push notification data to show (when app is killed or not being opened)
    var launchRemoteData: [AnyHashable : Any]?
    
    // MARK: - Register push notification
    func registerPushNotification(application: UIApplication = UIApplication.shared, completion: (() -> Void)? = nil) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
                DispatchQueue.main.async { completion?() }
            })
        })
        application.registerForRemoteNotifications()
    }
    
    // MARK: - Supporting methods
    func didRegisterPushNotification() -> Bool {
        let notificationType = UIApplication.shared.currentUserNotificationSettings?.types
        return !(notificationType == [])
    }
    
    func getPendingLocalNotificationsCount(completion: @escaping ((_ count: Int) -> Void)) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                DispatchQueue.main.async {
                    completion(requests.count)
                }
            })
        } else {
            let count = (UIApplication.shared.scheduledLocalNotifications ?? []).count
            completion(count)
        }
    }
    
    func removeAllLocalNotifications(removeDelivered: Bool = false, completion: @escaping (() -> Void)) {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                DispatchQueue.main.async {
                    let removeIds = requests.map({ $0.identifier })
                    center.removePendingNotificationRequests(withIdentifiers: removeIds)
                    print("[Local Notification] Removed all ! (iOS >= 10)")
                    completion()
                }
            })
            if removeDelivered {
                center.getDeliveredNotifications(completionHandler: { notifications in
                    DispatchQueue.main.async {
                        let removeIds = notifications.map { $0.request.identifier }
                        center.removeDeliveredNotifications(withIdentifiers: removeIds)
                    }
                })
            }
        } else {
            if let localNotis = application.scheduledLocalNotifications {
                localNotis.forEach {
                    application.cancelLocalNotification($0)
                }
                print("[Local Notification] Removed all ! (iOS < 10)")
            }
            completion()
        }
    }
    
    func removeLocalNotificationsWith(identifier: String,
                                      removeDelivered: Bool = false,
                                      completion: @escaping (() -> Void)) {
        let application = UIApplication.shared
        let identifierKey = "Identifier"
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            func removeDeliveredIfNeeded() {
                if removeDelivered {
                    center.getDeliveredNotifications(completionHandler: { notifications in
                        DispatchQueue.main.async {
                            var removeIds = [String]()
                            for noti in notifications {
                                let request = noti.request
                                if let id = request.content.userInfo[identifierKey] as? String, id == identifier {
                                    removeIds.append(request.identifier)
                                }
                            }
                            center.removeDeliveredNotifications(withIdentifiers: removeIds)
                            completion()
                        }
                    })
                } else { completion() }
            }
            center.getPendingNotificationRequests(completionHandler: { requests in
                DispatchQueue.main.async {
                    let removeIds = requests.filter({
                        if let id = $0.content.userInfo[identifierKey] as? String {
                            return id == identifier
                        }
                        return false
                    }).map({ $0.identifier })
                    center.removePendingNotificationRequests(withIdentifiers: removeIds)
                    print("[Local Notification][Type: \(identifier)] Removed all ! (iOS >= 10)")
                    if removeDelivered { removeDeliveredIfNeeded() }
                    else { completion() }
                }
            })
        } else {
            if let localNotifications = application.scheduledLocalNotifications {
                let targetList = localNotifications.filter({
                    if let id = $0.userInfo?[identifierKey] as? String {
                        return id == identifier
                    }
                    return false
                })
                targetList.forEach {
                    application.cancelLocalNotification($0)
                }
                print("[Local Notification][Type: \(identifier)] Removed all ! (iOS < 10)")
            }
            completion()
        }
    }
}

