//
//  Resultclass.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import RealmSwift

class ResultClass: Object {
    @objc dynamic var owner_mail: String?
    @objc dynamic var date: Date?
    @objc dynamic var complete: Double = 0.0
}
