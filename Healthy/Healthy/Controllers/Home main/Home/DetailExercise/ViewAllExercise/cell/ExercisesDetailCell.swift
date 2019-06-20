//
//  ExercisesDetailCell.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/8/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ExercisesDetailCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imgCover: ColorImageView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbOrdinal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpUI(ex: ExerciseClass, ordinal: Int, full: Int) {
        lbName.text = ex.name
        lbOrdinal.text = "\(ordinal) of \(full)"
    }
    
}
