//
//  Checkbox.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

@IBDesignable class CheckBox: UIButton {
    
    // MARK: - Inspectable
    @IBInspectable var checkedImage : UIImage?
    @IBInspectable var uncheckedImage : UIImage?
    @IBInspectable var isChecked: Bool = false {
        didSet {
            let image = isChecked ? checkedImage : uncheckedImage
            setBackgroundImage(image, for: .normal)
        }
    }
    
    // MARK: - Closure
    var didCheck: ((_ isChecked: Bool) -> Void)?
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        isChecked = false
    }
    
    // MARK: - Action
    @objc private func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            didCheck?(isChecked)
        }
    }
}
