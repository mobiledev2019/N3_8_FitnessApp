//
//  RealmData.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/29/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//
import UIKit
import RealmSwift

class RealmManager {
    private var realm: Realm
    
    static let shareInstance = RealmManager()
    
    private init() {
        realm = try! Realm()
    }
    
    //MARK: - select
    func getCurrentUser() -> Profile? {
        let list = getAllUser()
        guard list.count > 0 else {
            return nil
        }
        for temp in list {
            if !temp.isLogout {
                return temp
            }
        }
        return nil
    }
    
    func getUserProfile(id : String) -> Profile? {
        return realm.object(ofType: Profile.self, forPrimaryKey: id)
    }
    
    func getUserProfile(mail : String) -> Profile? {
        let predicate = NSPredicate(format: "email = %@ ", mail)
        let list = realm.objects(Profile.self).filter(predicate)
        if list.count == 0 {
            return nil
        }
        
        return list[0]
    }
    
    func isUserExisted(mail: String) -> Bool {
        let listPro = getAllUser()
        for temp in listPro {
            if mail == temp.email {
                return true
            }
        }
        
        return false
    }
    
    func getAllUser() -> Results<Profile> {
        return realm.objects(Profile.self)
    }
    
    func getAllExercises(user: Profile) -> [ExercisesClass] {
        
        var list: [ExercisesClass] = []
        for name in user.listExercies {
            let predicate = NSPredicate(format: "name = %@ ", name)
                list.append(realm.objects(ExercisesClass.self).filter(predicate)[0])
        }
        
        return list
    }
    
    func getAllExercises() -> [ExercisesClass] {
        var listRe: [ExercisesClass] = []
        let list = realm.objects(ExercisesClass.self)
        for temp in list {
            listRe.append(temp)
        }
        
        return listRe
    }
    
    func getAllExercise(exes: ExercisesClass) -> [ExerciseClass] {
        
        var list: [ExerciseClass] = [ExerciseClass]()
        for id in exes.listExercise {
            if let ex = getExercise(id: id) {
                list.append(ex)
            }
        }
        
        return list
    }
    
    func getAllExerciseActive(exes: ExercisesClass) -> [ExerciseClass] {
        
        var list: [ExerciseClass] = [ExerciseClass]()
        for index in 0...(exes.listActive.count - 1) {
            if exes.listActive[index], let ex = getExercise(id: exes.listExercise[index]) {
                list.append(ex)
            }
        }
        
        return list
    }
    
    func getAllExercise() -> Results<ExerciseClass> {
        return realm.objects(ExerciseClass.self)
    }
    
    func getExercise(id: Int) -> ExerciseClass? {
        return realm.objects(ExerciseClass.self).filter("id = \(id)")[0]
    }
    
    func getAllResult(mail: String) -> [ResultClass] {
        let predicate = NSPredicate(format: "owner_mail = %@ ", mail)
        let list = realm.objects(ResultClass.self).filter(predicate)
        
        var listRe = [ResultClass]()
        for temp in list {
            listRe.append(temp)
        }
        
        return listRe
    }
    
    //MARK: - insert
    func addNewUser(user: Profile) {
        updateAllUserLogOut()
        try! realm.write {
            realm.add(user)
        }
    }
    
    func addNewExercises(user: Profile, exes: ExercisesClass) {
        if let user = getCurrentUser() {
            try! realm.write {
                if let name = exes.name {
                    user.listExercies.append(name)
                    realm.add(exes)
                }
                
            }
        }
        
    }
    
    func addNewExercises(exes: ExercisesClass) {
        try! realm.write {
            realm.add(exes)
        }
    }
    
    func addNewExercise(ex: ExerciseClass) {
        try! realm.write {
            realm.add(ex)
        }
    }
    
    func addNewResult(re: ResultClass) {
        try! realm.write {
            realm.add(re)
        }
    }
    
    //MARK: update
    func updateUser(user: Profile) {
        
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    func updateExercise(ex: ExerciseClass, name: String) {
        try! realm.write {
            ex.name = name
        }
    }
    
    func updateAllUserLogOut() {
        let list = getAllUser()
        for user in list {
            try! realm.write {
                user.isLogout = true
            }
        }
    }
    
    //MARK: - delete
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func deleteUser(user: Profile) {
        try! realm.write {
            realm.delete(user)
        }
    }
}
