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
    @objc dynamic var avatar: String? = nil
    let height = RealmOptional<Float>()
    let weight = RealmOptional<Float>()
    let answers = List<String>()
    let listExercies = List<String>()
    let listResult = List<String>()
    @objc dynamic var email: String? = nil
    @objc dynamic var isLogout: Bool = false
    
    override static func primaryKey() -> String? {
        return "profileId"
    }
}
