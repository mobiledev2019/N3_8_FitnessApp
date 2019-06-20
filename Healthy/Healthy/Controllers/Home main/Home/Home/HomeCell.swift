//
//  HomeCell.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/7/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    //MARK: - outlets
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(exes: ExercisesClass) {
        lbName.text = exes.name
        var dem = 0
        for temp in exes.listActive {
            if temp {
                dem += 1
            }
        }
        lbNumber.text = "\(dem) part"
    }
    
}
