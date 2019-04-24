//
//  Database.swift
//  Fitness_App
//
//  Created by Anh Phuong on 4/23/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation
import Firebase
class DB {
    static func saveUser(uid: String, name: String, email: String) {
        let ref = Database.database().reference(fromURL: "https://fitness-c72e0.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        let values = ["name": name, "email": email]
        userReference.setValue(values, withCompletionBlock: { (err, ref) in
            if let _ = err {
                return
            }
        })
    }
}
