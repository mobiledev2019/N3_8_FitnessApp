//
//  TutorialVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class TutorialVC: UIViewController {

    var listWorkout: [Workout] = []
    var listExercise: [ExerciseDetail] = []
    var list: [ExerciseClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - setup
    func setUpData(){
        RealmManager.shareInstance.deleteAll()
        
        // data exercise
        do {
            // data we are getting from network request
            print("setupdata")
            let decoder = JSONDecoder()

            //listexercise
            let jsonex = Json.exJson
            let data2 = jsonex.data(using: .utf8)
            listExercise = try decoder.decode([ExerciseDetail].self, from: data2!)
            for ex in listExercise {
                let exClass = ExerciseClass()
                if let id = ex.id {
                    exClass.id = id
                }
                exClass.name = ex.name
                exClass.body_part = ex.body_part
                exClass.sound = ex.sound
                if let calo = ex.calorie {
                    exClass.calorie = calo
                }
                if let arr = ex.description {
                    exClass.des = convertArrayToString(arr: arr)
                }
                exClass.gif_phone = ex.gif_phone
                exClass.gif_pad = ex.gif_pad

                RealmManager.shareInstance.addNewExercise(ex: exClass)
            }

            // listExercises
            let json = Json.workoutJson
            let data = json.data(using: .utf8)
            listWorkout = try decoder.decode([Workout].self, from: data!)
            for temp in listWorkout {
                print("temp of wwork out")
                let exes = ExercisesClass()
                exes.cover = temp.pic_pad
                exes.isOriginal = true
                exes.name = temp.name
                if let listEx = temp.exercises {
                    for temp2 in listEx {
                        exes.listActive.append(true)
                        if let id = temp2.id {
                            exes.listExercise.append(id)
                        } else {
                            exes.listExercise.append(-1)
                        }

                    }
                }

                RealmManager.shareInstance.addNewExercises(exes: exes)

            }
        } catch { print(error) }
    }

    //MARK: - actions
    @IBAction func nextAction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "IsUserAppFirst")
        VCService.push(type: LoginVC.self)
    }
    
    //MARK: - method support
    func convertArrayToString(arr: [String]) -> String {
        var re = ""
        for str in arr {
            re = re + "\(str)"
        }
        return re
    }
    
}
