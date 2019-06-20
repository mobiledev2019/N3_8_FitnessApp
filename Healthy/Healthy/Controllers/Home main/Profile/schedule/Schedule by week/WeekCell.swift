//
//  WeekCell.swift
//  Healthy
//
//  Created by phuong on 6/15/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit


class WeekCell: UITableViewCell {
    
    //MARK: - outlets
    @IBOutlet weak var imgDay: UIImageView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbSchedule: UILabel!
    

    //MARK: - view life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: setup
    func setupUI(day: Int, number: Int) {
        var dayWeek = ""
        var img = ""
        switch day {
        case 0:
            dayWeek = "Thứ 2"
            img = "ic_Monday"
        case 1:
            dayWeek = "Thứ 3"
            img = "ic_Tuesday"
        case 2:
            dayWeek = "Thứ 4"
            img = "ic_Wedday"
        case 3:
            dayWeek = "Thứ 5"
            img = "ic_Thursday"
        case 4:
            dayWeek = "Thứ 6"
            img = "ic_Friday"
        case 5:
            dayWeek = "Thứ 7"
            img = "ic_Satday"
        default:
            dayWeek = "Chủ nhât"
            img = "ic_Sunday"
        }
        
        lbDay.text = dayWeek
        imgDay.image = UIImage(named: img)
        print("------lich tap------\(number)")
        lbSchedule.text = "\(number) lịch tập"
    }
}
