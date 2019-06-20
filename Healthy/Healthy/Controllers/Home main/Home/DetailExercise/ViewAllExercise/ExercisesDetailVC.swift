//
//  ExercisesDetailVC.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/8/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ExercisesDetailVC: BaseVC {

    //MARK: - Outlets
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - Variables
    var exes: ExercisesClass?
    var listEx: [ExerciseClass] = []
    var currentIndex: Int = 0
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = exes?.name
        setUpData()
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpData()
        tableView.reloadData()
    }
    
    //MARK: - setup
    func setUpData() {
        listEx.removeAll()
        guard let exes = exes else {
            return
        }
        if let _ = RealmManager.shareInstance.getCurrentUser() {
            listEx = RealmManager.shareInstance.getAllExerciseActive(exes: exes)
        } else {
            listEx = RealmManager.shareInstance.getAllExercise(exes: exes)
        }
    }
    
    func setUpTable() {
        
        tableView.registerNibCellFor(type: ExercisesDetailCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - actions
    @IBAction func backAction(_ sender: UIButton) {
        VCService.pop()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        if let user = RealmManager.shareInstance.getCurrentUser() {
            let customVc = CustomExercisesVC()
            customVc.exes = exes
            VCService.push(controller: customVc.self)
        } else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Can not edit because you did skip login", buttons: ["OK"])
        }
    }
}

extension ExercisesDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEx.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        currentIndex = indexPath.row
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ExercisesDetailCell.self) {
            cell.setUpUI(ex: listEx[indexPath.row], ordinal: indexPath.row, full: listEx.count)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doExer = DoExerciseVC()
        doExer.exercise = listEx[indexPath.row]
        doExer.delegate = self
        VCService.push(controller: doExer.self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ExercisesDetailVC: DoExerciseDelegate {
    func changeExercise(jump: Int, vc: DoExerciseVC) {
        currentIndex += jump
        if currentIndex < 0 {
            currentIndex = listEx.count - 1
        }
        
        if currentIndex >= listEx.count {
            currentIndex = 0
        }
        
        vc.changeExercise(ex: listEx[currentIndex])
    }
}
