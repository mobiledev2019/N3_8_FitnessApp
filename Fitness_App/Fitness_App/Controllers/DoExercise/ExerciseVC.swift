//
//  ExerciseVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/22/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ExerciseVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var tableExercise: BaseTableView!
    
    // MARK: - Variables
    var exer: ExercisesClass?
    var currentIndex = 0
    var isBig = false
    var listExercise: [ExerciseClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpTable()
        
    }
    
    // MARK: - setup
    func setUpData() {
        guard let exes = exer else {
            return
        }
        listExercise = RealmManager.shareInstance.getAllExerciseActive(exes: exes)
    }
    
    func setUpTable() {
        tableExercise.registerNibCellFor(type: DoExerciseCell.self)
        tableExercise.registerNibCellFor(type: ExerciseCell.self)
        tableExercise.dataSource = self
        tableExercise.delegate = self
    }
        
}

extension ExerciseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listExercise.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: DoExerciseCell.self, indexPath: indexPath) {
                cell.delegate = self
                cell.exercise = listExercise[currentIndex]
                cell.setUpFirstUI()
                
                return cell
            }
        }
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ExerciseCell.self, indexPath: indexPath) {
            cell.setUpCell(ex: listExercise[indexPath.row], ordinal: "\(indexPath.row + 1) of \(listExercise.count)")
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0, let cell = cell as? DoExerciseCell {
            cell.updateCell(isPlaying: false)
        } 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            currentIndex = indexPath.row
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("update height of row in table")
        if indexPath.row == 0 {
            return isBig ? self.view.safeAreaLayoutGuide.layoutFrame.size.height: (self.view.safeAreaLayoutGuide.layoutFrame.size.height - 170)
        }
        return 80
    }
}

extension ExerciseVC: DoExerciseDelegate {
    func changeExercise(jump: Int) {
        currentIndex += jump
        if currentIndex >= listExercise.count {
            currentIndex = 0
        }
        
        if currentIndex < 0 {
            currentIndex = listExercise.count - 1
        }
        tableExercise.reloadCellAt(row: 0)
    }
    
    func resizeCell(isBig: Bool) {
        self.isBig = isBig
        tableExercise.beginUpdates()
        tableExercise.endUpdates()
    }
    
    func backClosure() {
        dismiss(animated: true, completion: nil)
    }
}
