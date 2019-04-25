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
    var exer = Exercise(name: "Arm", pathVideo: "5_f")
    var isPlaying = false
    var listExercise: [ExerciseDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        
    }
    
    // MARK: - setup
    func setUpTable() {
        tableExercise.registerNibCellFor(type: DoExerciseCell.self)
        tableExercise.registerNibCellFor(type: ExerciseCell.self)
        tableExercise.dataSource = self
        tableExercise.delegate = self
    }
        
}

extension ExerciseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: DoExerciseCell.self, indexPath: indexPath) {
                cell.setUpCell(exercise: exer, isPlaying: isPlaying, resizeCellClosure: { isPlay in
                    self.isPlaying = isPlay
                    tableView.beginUpdates()
                    cell.updateCell(isPlaying: isPlay)
                    tableView.endUpdates()
                } )
                cell.animate(imageView: cell.imgGuide, images: cell.listImage)
                
                return cell
            }
        }
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ExerciseCell.self, indexPath: indexPath) {
            cell.setUpCell(ex: exer)
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0, let cell = cell as? DoExerciseCell {
            cell.updateCell(isPlaying: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return isPlaying ? self.view.safeAreaLayoutGuide.layoutFrame.size.height: (self.view.safeAreaLayoutGuide.layoutFrame.size.height - 170)
        }
        return 80
    }
    
}
