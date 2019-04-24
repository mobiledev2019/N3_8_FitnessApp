//
//  UserProfile.swift
//  Fitness_App
//
//  Created by Anh Phuong on 4/20/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation
class UserProfile {
    var UID: String?
    var userName: String?
    var passWord: String?
    var avatar: String?
    var height: Float?
    var weight: Float?
    var answers: [String]?
    var email: String?
    
    init(UID: String?, userName: String?, pass: String?,avatar: String?, height: Float?, weight: Float?, answers: [String]?, email: String? ) {
        self.UID = UID
        self.userName = userName
        self.passWord = pass
        self.avatar = avatar
        self.height = height
        self.answers = answers
        self.email = email
    }
    init(userName: String, pass: String, email: String) {
        self.userName = userName
        self.passWord = pass
        self.email = email
    }
    init() {
        
    }
    
}
