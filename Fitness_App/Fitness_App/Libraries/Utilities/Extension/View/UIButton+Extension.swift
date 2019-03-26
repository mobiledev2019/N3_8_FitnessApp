//
//  UIButton+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedTitle(for: .normal) {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                setTitle(.none, for: .normal)
            }
            attributedString.addAttribute(.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            setAttributedTitle(attributedString, for: .normal)
        }
        get {
            if let currentLetterSpace = attributedTitle(for: .normal)?.attribute(.kern,
                                                                                 at: 0,
                                                                                 effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            return 0
        }
    }
    
    func alignVertical(spacing: CGFloat = 6.0) {
        let buttonSize = frame.size
        if let titleLabel = titleLabel, let imageView = imageView {
            if let buttonTitle = titleLabel.text, let image = imageView.image {
                let titleString: NSString = NSString(string: buttonTitle)
                let titleSize = titleString.size(withAttributes: [.font: titleLabel.font])
                let buttonImageSize = image.size
                let topImageOffset = (buttonSize.height - (titleSize.height + buttonImageSize.height + spacing)) / 2
                let leftImageOffset = (buttonSize.width - buttonImageSize.width) / 2
                imageEdgeInsets = UIEdgeInsets(top: topImageOffset, left: leftImageOffset, bottom: 0, right: 0)
                let topTitleOffset = topImageOffset + spacing + buttonImageSize.height
                let leftTitleOffset = (buttonSize.width - titleSize.width) / 2 - image.size.width
                titleEdgeInsets = UIEdgeInsets(top: topTitleOffset, left: leftTitleOffset, bottom: 0, right: 0)
            }
        }
    }
    
    func setNormalButton(borderCorlor: UIColor, bgColor: UIColor){
        self.layer.borderColor = borderCorlor.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = bgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.setTitleColor(borderCorlor, for: .normal)
        
    }
    func setSelectedButon(bgColor : UIColor){
        self.backgroundColor = bgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setTextUnderline(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func alignTextBelowImage(spacing: CGFloat = 15.0, fixedTitleBottom: CGFloat? = nil, verticalAlign: CGFloat = 0.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            let labelString = NSString(string: self.titleLabel?.text ?? "")
            let titleSize = labelString.size(withAttributes: [.font: self.titleLabel!.font])
            let titleBottom = fixedTitleBottom ?? (self.frame.height - (imageSize.height + titleSize.height + spacing)) / 2
            let titleInsetBottom = -((self.frame.height / 2) - titleBottom + titleSize.height)
            let imageInsetBottom = spacing
            self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleInsetBottom, right: verticalAlign)
            self.imageEdgeInsets = UIEdgeInsets(top: -spacing, left: 0.0, bottom: imageInsetBottom, right: -titleSize.width)
        }
    }
    
    func alignImageToRightOfText(fixedRightBoundSpace: CGFloat? = nil, fixedRightOfTextSpace: CGFloat? = nil, verticalAlign: CGFloat = 0.0) {
        guard let imageView = imageView else { return }
        if let fixedRightBoundSpace = fixedRightBoundSpace {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - fixedRightBoundSpace - imageView.frame.width), bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageView.frame.width + verticalAlign)
        } else if let fixedRightOfTextSpace = fixedRightOfTextSpace {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: verticalAlign)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: ((titleLabel?.frame.maxX ?? 0) + fixedRightOfTextSpace), bottom: 0, right: 0)
        }
    }
}
