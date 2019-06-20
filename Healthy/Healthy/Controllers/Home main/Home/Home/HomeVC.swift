//
//  HomeVC.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/7/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
 
    //MARK: - outlets
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - Variables
    var listExercises: [ExercisesClass] = []
    
    //instance navigation controller
    class func newNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil))
    }
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpTable()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpData()
        tableView.reloadData()
    }
    
    //MARK: - setup
    func setUpData() {
        listExercises.removeAll()
        
        if let  user = RealmManager.shareInstance.getCurrentUser() {
            listExercises = RealmManager.shareInstance.getAllExercises(user: user)
        } else {
            listExercises = RealmManager.shareInstance.getAllExercises()
        }
    }
    
    func setUpTable() {
        tableView.registerNibCellFor(type: HomeCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - action
    @IBAction func addNewExerciseAction(_ sender: UIButton) {
        if let user = RealmManager.shareInstance.getCurrentUser() {
            VCService.push(type: AddExercisesVc.self)
        } else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Can not add new because you skiped login", buttons: ["OK"])
        }
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: HomeCell.self, indexPath: indexPath) {
            cell.setUpCell(exes: listExercises[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exDetail = ExercisesDetailVC()
        exDetail.exes = listExercises[indexPath.row]
        VCService.push(controller: exDetail.self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
