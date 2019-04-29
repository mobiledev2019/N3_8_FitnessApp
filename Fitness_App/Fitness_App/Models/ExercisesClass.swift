//
//  ExercisesClass.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import RealmSwift

class ExercisesClass: Object {
    @objc dynamic var name: String?
    @objc dynamic var cover: String?
    @objc dynamic var listActive: [Bool]?
    @objc dynamic var listExercise: [ExerciseClass]?    
    
}

