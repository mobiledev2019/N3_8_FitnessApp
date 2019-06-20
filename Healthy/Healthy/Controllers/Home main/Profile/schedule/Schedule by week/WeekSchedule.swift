//
//  WeekSchedule.swift
//  Healthy
//
//  Created by phuong on 6/15/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

enum DayOfWeek: String {
    case MonDay = "Thứ 2"
    case TuesDay = "Thứ 3"
    case WedDay = "Thứ 4"
    case ThursDay = "Thứ 5"
    case FriDay = "Thứ 6"
    case SatDay = "Thứ 7"
    case SunDay = "Chủ nhật"
}

class WeekSchedule: BaseVC {
    //MARK: - outlets
    @IBOutlet weak var tableView: BaseTableView!
    
    //MARK: - Variables
    var listSchedule: [[Schedule]?] = []
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        listSchedule.removeAll()

        setupData()
        tableView.reloadData()
    }
    
    //MARK: setup
    func setupData() {
        let user = RealmManager.shareInstance.getCurrentUser()
        guard let us = user, let email = us.email else {
            return
        }
        
        var list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Monday")
        listSchedule.append(list)
        
        list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Tuesday")
        listSchedule.append(list)
        
        list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Wedday")
        listSchedule.append(list)
        
        list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Thursday")
        listSchedule.append(list)
        
        list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Friday")
        listSchedule.append(list)
        
        list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Satday")
        listSchedule.append(list)
        
        list = RealmManager.shareInstance.getScheduleByDay(email: email, day: "Sunday")
        listSchedule.append(list)
        
        print("listtttt: \(listSchedule)")
    }
    
    func setupTable() {
        tableView.registerNibCellFor(type: WeekCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK: - actions
    @IBAction func actionBack(_ sender: UIButton) {
        VCService.pop()
    }
    
    @IBAction func actionAdd(_ sender: UIButton) {
        VCService.push(type: ScheduleVC.self)
    }
}

extension WeekSchedule: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: WeekCell.self, indexPath: indexPath) {
            if let li = listSchedule[indexPath.row] {
                cell.setupUI(day: indexPath.row, number: li.count)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dayVC = DaySchedule()
        dayVC.listSche = listSchedule[indexPath.row]
        dayVC.day = indexPath.row
        VCService.push(controller: dayVC.self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.layer.bounds.height - 20) / 7
        
    }
}
