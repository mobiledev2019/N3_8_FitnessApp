//
//  ProfileClass.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//
import RealmSwift
class Profile: Object {
    @objc dynamic var UID: String? = nil
    @objc dynamic var profileId = UUID().uuidString
    @objc dynamic var userName: String? = nil
    @objc dynamic var passWord: String? = nil
    @objc dynamic var avatar: Data? = nil
    @objc dynamic var height: Float = 0.0
    @objc dynamic var weight: Float = 0.0
    let answers = List<String>()
    let listExercies = List<String>()
    let listResult = List<String>()
    @objc dynamic var email: String? = nil
    @objc dynamic var isLogout: Bool = false
    @objc dynamic var isRegister = true
    
    override static func primaryKey() -> String? {
        return "profileId"
    }
}
