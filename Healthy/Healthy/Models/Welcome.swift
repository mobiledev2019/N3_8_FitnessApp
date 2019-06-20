//
//  Welcome.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation

typealias Welcome = [WelcomeElement]

class WelcomeElement: Codable {
    let sound, gifPad, name: String
    let bodyPart: BodyPart
    let calorie: Double
    let pic: String
    let custom: Bool
    let videoLink: String
    let gifPhone: String
    let id: Int
    let description: [String]
    
    enum CodingKeys: String, CodingKey {
        case sound
        case gifPad = "gif_pad"
        case name
        case bodyPart = "body_part"
        case calorie, pic, custom
        case videoLink = "video_link"
        case gifPhone = "gif_phone"
        case id, description
    }
    
    init(sound: String, gifPad: String, name: String, bodyPart: BodyPart, calorie: Double, pic: String, custom: Bool, videoLink: String, gifPhone: String, id: Int, description: [String]) {
        self.sound = sound
        self.gifPad = gifPad
        self.name = name
        self.bodyPart = bodyPart
        self.calorie = calorie
        self.pic = pic
        self.custom = custom
        self.videoLink = videoLink
        self.gifPhone = gifPhone
        self.id = id
        self.description = description
    }
}

enum BodyPart: String, Codable {
    case core = "CORE"
    case lowerBody = "LOWER BODY"
    case tbd = "TBD"
    case totalBody = "TOTAL BODY"
    case upperBody = "UPPER BODY"
}

