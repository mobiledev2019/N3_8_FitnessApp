//
//  ItemExerciseDetailCell.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ItemExerciseDetailCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tfNameEx: UITextView!
    @IBOutlet weak var btnChoose: UIButton!
    
    //MARK: - variables
    var isSelect = true
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - setup
    func setupFirst() {
        btnChoose.setImage(UIImage(named: "ic_add_small"), for: .normal)
    }
    func setup(ex: ExerciseDetail) {
        tfNameEx.text = ex.name
        btnChoose.setImage(UIImage(named: "ic_add_small"), for: .normal)
    }
    
    @IBAction func ChooseAction(_ sender: UIButton) {
        isSelect = !isSelect
        if isSelect {
            sender.setImage(UIImage(named: "ic_add_small"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_remove"), for: .normal)
        }
    }
}
