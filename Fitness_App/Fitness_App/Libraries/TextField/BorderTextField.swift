//
//  BorderTextField.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BorderTextField: UITextField {
    
    // MARK: - Inspectable
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clear
    @IBInspectable var borderWidth: CGFloat = 0.0
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    // MARK: - UI
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}
