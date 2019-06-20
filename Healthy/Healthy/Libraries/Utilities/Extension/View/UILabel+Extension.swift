//
//  UILabel+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//
import UIKit

extension UILabel {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
        
        get {
            if let currentLetterSpace = attributedText?.attribute(.kern,
                                                                  at: 0,
                                                                  effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            return 0
        }
    }

    public func sizeFit(width: CGFloat) -> CGSize {
        self.numberOfLines = Int.max
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth,
                                          height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }
    
    public func sizeFit(height: CGFloat) -> CGSize {
        self.numberOfLines = Int.max
        let fixedHeight = height
        let newSize = sizeThatFits(CGSize(width: .greatestFiniteMagnitude,
                                          height: fixedHeight))
        return CGSize(width: newSize.width, height: fixedHeight)
    }
    
    public func underline() {
        if let text = self.text {
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle ,
                                        value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
    
    public func underlineWidth(count : Int) {
        if let text = self.text {
            let textRange = NSRange(location: 0, length: count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle ,
                                        value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
    
    public func numberOfLines() -> Int {
        var lineCount = 0
        let textSize = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        let rHeight = lroundf(Float(sizeThatFits(textSize).height))
        let charSize = lroundf(Float(font.lineHeight))
        lineCount = rHeight / charSize
        return lineCount
    }
    
    public func set(lineSpacing value: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
