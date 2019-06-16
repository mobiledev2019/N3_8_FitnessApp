//
//  DayCell.swift
//  Healthy
//
//  Created by phuong on 6/16/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    //MARK: - outlets
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTime: UILabel!

    //MARK: - Variables
    var sche: Schedule?
    var removeClosure: (() -> Void)?
    
    //MARK: - view life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - setup
    func setupUI(sche: Schedule,removeClosure: @escaping ( () -> Void)) {
        lbName.text = sche.exers
        lbTime.text = "\(sche.hour):\(sche.minute)"
        
        self.removeClosure = removeClosure
    }
    
    //MARK: - actions
    @IBAction func actionRemove(_ sender: UIButton) {
        
        if let remove = removeClosure {
            remove()
        }
    }
    
    
}
