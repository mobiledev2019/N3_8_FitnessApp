//
//  ScheduleVC.swift
//  Healthy
//
//  Created by phuong on 6/13/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import UserNotifications

class ScheduleVC: BaseVC, UNUserNotificationCenterDelegate {

    //MARK: - outlets
    @IBOutlet weak var pcvExcercise: UIPickerView!
    @IBOutlet weak var pcvMinutes: UIPickerView!
    @IBOutlet weak var pcvHours: UIPickerView!
    @IBOutlet weak var btnCheckMonDay: UIButton!
    @IBOutlet weak var btnCheckTuesDay: UIButton!
    @IBOutlet weak var btnCheckWedDay: UIButton!
    @IBOutlet weak var btnCheckThursDay: UIButton!
    @IBOutlet weak var btnCheckFriDay: UIButton!
    @IBOutlet weak var btnCheckSatDay: UIButton!
    @IBOutlet weak var btnCheckSunDay: UIButton!
    
    //MARK: - Variables
    let listMinutes = [00, 01, 02, 03, 04, 05, 06, 07, 08, 09,
                       10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                       20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
                       30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
                       40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
                       50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    let listHours = [00, 01, 02, 03, 04, 05, 06, 07, 08, 09,
                     10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
                     20, 21, 22, 23]
    var listExer: [ExercisesClass]?
    var listcheckDay = [false, false, false, false, false, false, false]
    let pickerViewRows = 10_000
    var middleMinutes: Int?
    var middleHours: Int?
    
    var user: Profile?
    
    var nameEx: String?
    var hour: Int?
    var minute: Int?

    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        middleMinutes = ((pickerViewRows / listMinutes.count) / 2) * listMinutes.count
        middleHours = ((pickerViewRows / listHours.count) / 2) * listMinutes.count
        setupData()
        setupUI()
        
        //noti
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        //detect app in background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //MARK: - setup
    func setupData() {
        if let user = RealmManager.shareInstance.getCurrentUser() {
            listExer = RealmManager.shareInstance.getAllExercises(user: user)
            self.user = user
        }
    }
    
    func setupUI() {
        pcvExcercise.delegate = self
        pcvExcercise.dataSource = self
        
        pcvMinutes.delegate = self
        pcvMinutes.dataSource = self
        pcvMinutes.selectRow(listMinutes.count / 2, inComponent: 0, animated: false)
        
        pcvHours.delegate = self
        pcvHours.dataSource = self
        pcvMinutes.selectRow(listHours.count / 2, inComponent: 0, animated: false)
    }
    
    //MARK: - actions
    @IBAction func actionChooseDay(_ sender: UIButton) {
        var check = false
        switch sender {
        case btnCheckMonDay:
            listcheckDay[0] = !listcheckDay[0]
            check = listcheckDay[0]
        case btnCheckTuesDay:
            listcheckDay[1] = !listcheckDay[1]
            check = listcheckDay[1]
        case btnCheckWedDay:
            listcheckDay[2] = !listcheckDay[2]
            check = listcheckDay[2]
        case btnCheckThursDay:
            listcheckDay[3] = !listcheckDay[3]
            check = listcheckDay[3]
        case btnCheckFriDay:
            listcheckDay[4] = !listcheckDay[4]
            check = listcheckDay[4]
        case btnCheckSatDay:
            listcheckDay[5] = !listcheckDay[5]
            check = listcheckDay[5]
        default:
            listcheckDay[6] = !listcheckDay[6]
            check = listcheckDay[6]
        }
        
        if check {
            sender.setImage(UIImage(named: "ic_check"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        VCService.pop()
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        print("save")
        
        if let user = user, let name = nameEx, let hour = hour, let minute = minute {
            if listcheckDay[0] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Monday"
                sche.hour = hour
                sche.minute = minute
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 2, hour: hour, minute: minute)
            }
            
            if listcheckDay[1] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Tuesday"
                sche.hour = hour
                sche.minute = minute
                sche.notificationUUID = uuidString
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 3, hour: hour, minute: minute)
            }
            
            if listcheckDay[2] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Wedday"
                sche.hour = hour
                sche.minute = minute
                sche.notificationUUID = uuidString
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 4, hour: hour, minute: minute)
            }
            
            if listcheckDay[3] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Thursday"
                sche.hour = hour
                sche.minute = minute
                sche.notificationUUID = uuidString
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 5, hour: hour, minute: minute)
            }
            
            if listcheckDay[4] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Friday"
                sche.hour = hour
                sche.minute = minute
                sche.notificationUUID = uuidString
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 6, hour: hour, minute: minute)
            }
            
            if listcheckDay[5] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Satday"
                sche.hour = hour
                sche.minute = minute
                sche.notificationUUID = uuidString
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 7, hour: hour, minute: minute)
            }
            
            if listcheckDay[6] {
                let uuidString = UUID().uuidString
                var sche = Schedule()
                sche.onwer_email = user.email
                sche.exers = name
                sche.day = "Sunday"
                sche.hour = hour
                sche.minute = minute
                sche.notificationUUID = uuidString
                RealmManager.shareInstance.addNewSchedule(sche: sche)
                createNotification(notiID: uuidString, day: 1, hour: hour, minute: minute)
            }
            
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Bạn đã lưu lịch thành công", buttons:["OK"])
            
            resetUI()
        }
    }
    
    //MARK: - update UI
    func resetUI() {
        btnCheckMonDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCheckTuesDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCheckWedDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCheckThursDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCheckFriDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCheckSatDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCheckSunDay.setImage(UIImage(named: "ic_uncheck"), for: .normal)
    }
    
    //MARK: - methods support
    func createNotification(notiID: String, day: Int, hour: Int, minute: Int) {
        print("create new notificationat: \(hour): \(minute)")
        let content = UNMutableNotificationContent()
        content.title = "Thời gian luyện tập "
        content.body = "Mỗi ngày lúc \(hour):\(minute)"
        content.sound = UNNotificationSound.defaultCritical
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = day // Tuesday
        dateComponents.hour = hour   // 14:00 hours
        dateComponents.minute = minute
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: notiID,
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.delegate = self
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("---------------app in foreground-----------")
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
//        sendNotification(name: exercise?.name, seconds: total)
    }
}

extension ScheduleVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pcvExcercise:
            guard let list = listExer else { return 0 }
            return list.count
        case pcvMinutes:
            return 60
        default:
            return 24
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pcvMinutes:
            return String(listMinutes[row])
        case pcvHours:
            return String(listHours[row])
        default:
            guard let list = listExer else { return "" }
            return list[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pcvMinutes:
            print("minute: \(listMinutes[row])")
            minute = listMinutes[row]
            let newRow = middleMinutes! + (row % listMinutes.count)
            pickerView.selectRow(newRow, inComponent: 0, animated: false)
        case pcvHours:
            print("hours: \(listHours[row])")
            hour = listHours[row]
            let newRow = middleHours! + (row % listHours.count)
            pickerView.selectRow(newRow, inComponent: 0, animated: false)
        default:
            if let list = listExer {
                print("name exer: \(list[row].name)")
                nameEx = list[row].name
            }
            print("no exer had choose")
        }
    }
    
    
}
