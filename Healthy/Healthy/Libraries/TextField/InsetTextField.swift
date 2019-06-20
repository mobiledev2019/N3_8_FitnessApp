//
//  InsetTextField.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {

    // MARK: - Inspectable
    @IBInspectable var insetTop: CGFloat = 0
    @IBInspectable var insetLeft: CGFloat = 10
    @IBInspectable var insetBottom: CGFloat = 0
    @IBInspectable var insetRight: CGFloat = 10
    
    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
    }
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
