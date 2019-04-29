//
//  ProfileClass.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//
import RealmSwift
class Profile: Object {
    @objc dynamic var UID: String?
    @objc dynamic var userName: String?
    @objc dynamic var passWord: String?
    @objc dynamic var avatar: String?
    @objc dynamic var height: float = 1.5
    @objc dynamic var weight: float = 
    @objc dynamic var answers: [String]?
    @objc dynamic var email: String?
    @objc dynamic var isLogout: Bool = false
}
