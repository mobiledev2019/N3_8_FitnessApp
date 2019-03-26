//
//  ShadowView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView {
    
    // MARK: - IBInspectables
    @IBInspectable var fillColor: UIColor = .white
    @IBInspectable var cornerTopLeft: Bool = true
    @IBInspectable var cornerTopRight: Bool = true
    @IBInspectable var cornerBottomLeft: Bool = true
    @IBInspectable var cornerBottomRight: Bool = true
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowOffset: CGSize = .zero
    @IBInspectable var shadowOpacity: Float = 0
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = .clear
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        backgroundColor = .clear
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var cornerList = UIRectCorner()
        if cornerTopLeft { cornerList.insert(.topLeft) }
        if cornerTopRight { cornerList.insert(.topRight) }
        if cornerBottomLeft { cornerList.insert(.bottomLeft) }
        if cornerBottomRight { cornerList.insert(.bottomRight) }
        let path = UIBezierPath(roundedRect: CGRect(x: borderWidth / 2, y: borderWidth / 2, width: rect.width - borderWidth, height: rect.height - borderWidth), byRoundingCorners: cornerList, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        if !cornerTopLeft {
            path.move(to: CGPoint(x: 0, y: borderWidth / 2))
            path.addLine(to: CGPoint(x: borderWidth / 2, y: borderWidth / 2))
        }
        path.lineWidth = borderWidth
        borderColor.setStroke()
        path.stroke()
        fillColor.setFill()
        path.fill()
        path.close()
        layer.shadowPath = path.cgPath
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.masksToBounds = false
        path.addClip()
    }
    
}
