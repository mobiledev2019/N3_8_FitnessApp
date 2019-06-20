//
//  DaySchedule.swift
//  Healthy
//
//  Created by phuong on 6/16/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import UserNotifications

class DaySchedule: BaseVC {

    //MARK: - outlets
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var tableview: BaseTableView!
    
    //MARK: - Variables
    var listSche: [Schedule]?
    var day: Int?
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        setupUI()
    }
    
    //MARK: - setup
    func setupTable() {
        tableview.registerNibCellFor(type: DayCell.self)
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func setupUI() {
        switch day {
        case 0:
            lbDay.text = "Thứ 2"
        case 1:
            lbDay.text = "Thứ 3"
        case 2:
            lbDay.text = "Thứ 4"
        case 3:
            lbDay.text = "Thứ 5"
        case 4:
            lbDay.text = "Thứ 6"
        case 5:
            lbDay.text = "Thứ 7"
        default:
            lbDay.text = "Chủ nhật"
        }
    }
    
    //MARK: - actions
    @IBAction func actionBack(_ sender: UIButton) {
        VCService.pop()
    }
}

extension DaySchedule: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = listSche {
            return list.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let table = tableView as? BaseTableView, let cell = table.reusableCell(type: DayCell.self, indexPath: indexPath) {
            if var list = listSche {
                cell.setupUI(sche: list[indexPath.row]) { () in
                    let sch = list[indexPath.row]
                    let notiId = sch.notificationUUID
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [notiId])
                    self.listSche?.remove(at: indexPath.row)
                    RealmManager.shareInstance.deleteSchedule(sche: sch)
                    tableView.reloadData()
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
