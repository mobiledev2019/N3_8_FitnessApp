//
//  ExerciseCell.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/27/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lbOrdinal: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    // MARK: - View life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Set up
    func setUpCell(ex: ExerciseClass, ordinal: String) {
        lbName.text = ex.name
        lbOrdinal.text = ordinal
    }
    
}
