//
//  UITextField+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPlaceholderInfo(font: UIFont? = nil, color: UIColor? = nil) {
        if font == nil && color == nil { return }
        let placeholderText = self.placeholder ?? ""
        let attr = NSMutableAttributedString(string: placeholderText)
        if let font = font {
            attr.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: placeholderText.count))
        }
        if let color = color {
            attr.addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSRange(location: 0, length: placeholderText.count))
        }
        attributedPlaceholder = attr
    }
}
