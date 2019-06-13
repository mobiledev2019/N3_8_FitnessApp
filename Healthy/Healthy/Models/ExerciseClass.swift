//
//  ExerciseClass.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//
import RealmSwift

class ExerciseClass: Object {
    @objc dynamic var id = -1
    @objc dynamic var name: String?
    @objc dynamic var body_part: String?
    @objc dynamic var sound: String?
    @objc dynamic var des: String?
    @objc dynamic var gif_pad: String?
    @objc dynamic var video_link: String?
    @objc dynamic var pic: String?
    @objc dynamic var calorie: Double = 0.6
    @objc dynamic var gif_phone: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
