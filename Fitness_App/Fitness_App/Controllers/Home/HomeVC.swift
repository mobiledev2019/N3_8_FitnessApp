//
//  HomeVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    //MARK: - Outlets
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - variables
    var listWorkout: [Workout] = []
    
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
    
    //MARK: - setup
    func setUpData() {
        do {
            // data we are getting from network request
            let decoder = JSONDecoder()
            let json = Json.workoutJson
            let data = json.data(using: .utf8)
            listWorkout = try decoder.decode([Workout].self, from: data!)
            print("reponse: \(listWorkout[0].brief)") //Output - EMT
        } catch { print(error) }
    
    }
    
    func setUpTable() {
        tableView.registerNibCellFor(type: ExercisesCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: - actions
    @IBAction func addExercisesAction(_ sender: UIButton) {
        // to do
        print("action button")
        VCService.present(type: AddExercisesVc.self)
//        VCService.push(type: AddExercisesVc.self)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWorkout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: ExercisesCell.self, indexPath: indexPath) {
            cell.setUpCell(workout: listWorkout[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VCService.present(type: ExerciseVC.self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
