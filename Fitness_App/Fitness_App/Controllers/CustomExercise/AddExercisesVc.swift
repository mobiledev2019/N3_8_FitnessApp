//
//  AddExercisesVc.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class AddExercisesVc: BaseVC {

    //MARK: - Outlets
    @IBOutlet weak var tfName: BorderTextField!
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - variables
    var listWorkOut: [Workout] = []
    var listExercise: [ExerciseDetail] = []
    var list: [ExerciseClass] = []
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupTable()
    }
    
    //MARK: setup
    func setupData() {
        print("setupdata")
        do {
            // data we are getting from network request
            print("setupdata")
            let decoder = JSONDecoder()
            let json = Json.workoutJson
            let data = json.data(using: .utf8)
            listWorkOut = try decoder.decode([Workout].self, from: data!)
            print("list workout: \(listWorkOut.count)")
            
            let jsonex = Json.exJson
            let data2 = jsonex.data(using: .utf8)
            listExercise = try decoder.decode([ExerciseDetail].self, from: data2!)
            print("list exercise: \(listExercise.count)")
            
            for ex in listExercise {
                var exClass = ExerciseClass()
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
                list.append(exClass)
            }
            print("list exercise: \(list.count)")
        } catch { print(error) }
    }

    func setupTable() {
        tableView.registerNibCellFor(type: ItemExerciseDetailCell.self)
        tableView.registerNibCellFor(type: HeaderCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    //MARK: - Actions
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveAction(_ sender: UIButton) {
        
    }
    
    //MARK: - suporting
    func getExerciseDetail(id: Int) -> ExerciseDetail? {
        for ex in listExercise {
            if ex.id == id {
                return ex
            }
        }
        return nil
    }
    
    func convertArrayToString(arr: [String]) -> String {
        var re = ""
        for str in arr {
            re = re + "\(str)"
        }
        return re
    }
}

extension AddExercisesVc: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return listWorkOut.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let row = listWorkOut[section].exercises?.count {
            return row
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ItemExerciseDetailCell.self) {
            cell.setupFirst()
            if let ex = listWorkOut[indexPath.section].exercises?[indexPath.row], let exDetail = getExerciseDetail(id: ex.id!) {
                cell.setup(ex: exDetail)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: HeaderCell.self) {
            cell.setUpCell(workout: listWorkOut[section])
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
