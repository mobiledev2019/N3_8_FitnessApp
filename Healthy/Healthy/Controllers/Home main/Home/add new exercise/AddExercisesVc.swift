//
//  AddExercisesVc.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class AddExercisesVc: BaseVC {

    //MARK: - Outlets
    @IBOutlet weak var tfName: BorderTextField!
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - variables
    var listExercises: [ExercisesClass] = []
    var listExercise: [ExerciseClass] = []
    var orginalArray: [[Bool]] = []
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupTable()
    }
    
    //MARK: setup
    func setupData() {
        listExercises = RealmManager.shareInstance.getAllExercises()
        for i in 0...(listExercises.count - 1) {
            orginalArray.append([])
            let listActive = listExercises[i].listActive
            for j in 0...(listActive.count - 1 ) {
                print(listActive[j])
                orginalArray[i].append(listActive[j])
            }
        }
    }

    func setupTable() {
        tableView.registerNibCellFor(type: ItemExerciseDetailCell.self)
        tableView.registerNibCellFor(type: HeaderCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    //MARK: - Actions
    @IBAction func backAction(_ sender: UIButton) {
        VCService.pop()
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        guard let user = RealmManager.shareInstance.getCurrentUser() else {
            showMess(mess: "Please login to edit")
            return
        }
        guard let name = tfName.text, name != "" else {
            showMess(mess: "You need to enter the name of new exercise")
            return
        }
        let list = getAllNewExercise()
        guard list.count != 0  else {
            showMess(mess: "You need to choose at least one exercise")
            return
        }
       
        let newExes = ExercisesClass()
        
        newExes.name = name
        newExes.isOriginal = false
        for temp in list {
            newExes.listExercise.append(temp)
            newExes.listActive.append(true)
        }
        print("size of list before: \(listExercises)")
        RealmManager.shareInstance.addNewExercises(exes: newExes)
        print("size of list after: \(listExercises)")
        let realm = try! Realm()
        for i in 0...(listExercises.count - 1) {
            let exes = listExercises[i]
            let listActive = listExercises[i].listActive
            for j in 0...(listActive.count - 1) {
                try! realm.write {
                    exes.listActive[j] = orginalArray[i][j]
                }
                
            }
        }
        showMess(mess: "Add new Exercises success!")
        tfName.text = ""
        setupData()
        tableView.reloadData()
        
        try! realm.write {
            user.listExercies.append(name)
        }
        
    }
    
    //MARK: - suporting
    func getAllNewExercise() -> [Int] {
        var list = [Int]()
        for exes in listExercises {
            for index in 0...(exes.listActive.count - 1) {
                if !exes.listActive[index] {
                    list.append(exes.listExercise[index])
                }
            }
        }
        
        return list
    }
    
    func showMess(mess: String) {
        UIAlertController.showSystemAlert(target: self, title: "Message", message: mess, buttons:["OK"])
    }
}

extension AddExercisesVc: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listExercises.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listExercises[section].listExercise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ItemExerciseDetailCell.self) {
            if let temp = RealmManager.shareInstance.getExercise(id: listExercises[indexPath.section].listExercise[indexPath.row]) {
                cell.setup(ex: temp, exes: listExercises[indexPath.section], index: indexPath.row)
            } else {
                cell.setupFirst()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: HeaderCell.self) {
            cell.setUpCell(exes: listExercises[section])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
