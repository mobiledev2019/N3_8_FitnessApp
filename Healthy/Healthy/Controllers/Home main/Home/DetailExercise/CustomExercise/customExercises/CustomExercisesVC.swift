//
//  CustomExercisesVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 5/5/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class CustomExercisesVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - Variables
    var exes: ExercisesClass?
    var listEx = [ExerciseClass]()
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpData()
        setUpTable()
        setUpUI()
        
    }
    
    //MARK: - setup
    func  setUpData() {
        guard let exes = exes else {
            return
        }
        listEx = RealmManager.shareInstance.getAllExercise(exes: exes)
    }
    
    func setUpTable() {
        tableView.registerNibCellFor(type: ItemExerciseDetailCell.self)
        tableView.registerNibCellFor(type: HeaderCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setUpUI() {
        lbName.text = exes?.name
    }
    
    //MARK: - actions
    @IBAction func backAction(_ sender: UIButton) {
        VCService.pop()
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        UIAlertController.showSystemAlert(target: self, title: "Message", message: "Save successful", buttons: ["OK"])
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension CustomExercisesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEx.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: HeaderCell.self), let exes = exes {
            cell.setUpCell(exes: exes)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ItemExerciseDetailCell.self), let exes = exes {
            cell.setup(ex: listEx[indexPath.row], exes: exes, index: indexPath.row)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
