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
    var listExercises: [ExercisesClass] = []
    var listExercise: [ExerciseClass] = []
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupTable()
    }
    
    //MARK: setup
    func setupData() {
//        if let user = RealmData.getUserProfile(mail: "phuong123@gmail.com") {
//            listExercises = RealmData.getAllExercises(user: user)
//        }
//        listExercise = RealmData.getAllExercise()
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
            let isActive = listExercises[indexPath.section].listActive.shuffled()[indexPath.row]
            let id = listExercises[indexPath.section].listExercise.shuffled()[indexPath.row]
//            if let ex = RealmData.getExercise(id: id){
//                cell.setup(ex: ex, isActive: isActive)
//            }
            
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
