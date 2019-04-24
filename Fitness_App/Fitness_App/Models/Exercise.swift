//
//  Exercise.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/27/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation
class Exercise: NSObject {
    var name: String
    var pathVideo: String
    
    init(name: String, pathVideo: String) {
        self.name = name
        self.pathVideo = pathVideo
    }
}
