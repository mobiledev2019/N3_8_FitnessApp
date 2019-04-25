//
//  AddExercisesVc.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class AddExercisesVc: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tfName: BorderTextField!
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - variables
    var listWorkOut: [Workout] = []
    var listExercise: [ExerciseDetail] = []
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupTable()
    }
    
    //MARK: setup
    func setupData() {
        do {
            // data we are getting from network request
            let decoder = JSONDecoder()
            let json = Json.workoutJson
            let data = json.data(using: .utf8)
            listWorkOut = try decoder.decode([Workout].self, from: data!)
            
            let jsonex = Json.exerciseJson
            let data2 = jsonex.data(using: .utf8)
            listExercise = try decoder.decode([ExerciseDetail].self, from: data2!)
            print("reponse: \(listExercise[0].name)") //Output - EMT
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
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
