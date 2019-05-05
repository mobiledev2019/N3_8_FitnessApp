//
//  ExercisesCell.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/25/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ExercisesCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgExercises: UIImageView!
    
    //MARK: - Variables
    var detailClosure: ( () -> Void)?
    
    //MARK: view life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - set up
    func setUpCell(exes: ExercisesClass, detailClosure: @escaping ( () -> Void)) {
        lbName.text = exes.name
        self.detailClosure = detailClosure
    }
    
    // MARK: - Actions
    @IBAction func detailAction(_ sender: UIButton) {
        if let detail = detailClosure {
            detail()
        }
    }
    
}
