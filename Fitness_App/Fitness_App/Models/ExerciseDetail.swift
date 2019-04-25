//
//  ExerciseDetail.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation
struct ExerciseDetail : Codable {
    let sound : String?
    let gif_pad : String?
    let name : String?
    let body_part : String?
    let calorie : Double?
    let pic : String?
    let custom : Bool?
    let video_link : String?
    let gif_phone : String?
    let id : Int?
    let description : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case sound = "sound"
        case gif_pad = "gif_pad"
        case name = "name"
        case body_part = "body_part"
        case calorie = "calorie"
        case pic = "pic"
        case custom = "custom"
        case video_link = "video_link"
        case gif_phone = "gif_phone"
        case id = "id"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sound = try values.decodeIfPresent(String.self, forKey: .sound)
        gif_pad = try values.decodeIfPresent(String.self, forKey: .gif_pad)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        body_part = try values.decodeIfPresent(String.self, forKey: .body_part)
        calorie = try values.decodeIfPresent(Double.self, forKey: .calorie)
        pic = try values.decodeIfPresent(String.self, forKey: .pic)
        custom = try values.decodeIfPresent(Bool.self, forKey: .custom)
        video_link = try values.decodeIfPresent(String.self, forKey: .video_link)
        gif_phone = try values.decodeIfPresent(String.self, forKey: .gif_phone)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        description = try values.decodeIfPresent([String].self, forKey: .description)
    }
    
}

