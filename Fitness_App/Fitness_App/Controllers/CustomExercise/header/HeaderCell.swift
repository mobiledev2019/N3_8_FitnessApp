//
//  HeaderCell.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNumberEx: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - setup
    func setUpCell(workout: Workout) {
        lbTitle.text = workout.name
        lbNumberEx.text = "\(workout.exercises?.count)"
    }
    
}
