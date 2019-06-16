//
//  ScheduleClass.swift
//  Healthy
//
//  Created by phuong on 6/16/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import RealmSwift

class Schedule: Object {
    @objc dynamic var onwer_email: String?
    @objc dynamic var exers: String?
    @objc dynamic var day: String?
    @objc dynamic var hour: Int = -1
    @objc dynamic var minute: Int = -1
    @objc dynamic var notificationUUID: String = ""
}
