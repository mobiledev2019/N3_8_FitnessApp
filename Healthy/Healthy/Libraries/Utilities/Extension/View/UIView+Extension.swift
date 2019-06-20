//
//  UIView+Extension.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: - Static functions
    static func getNameFor<T: UIView>(type: T.Type) -> String {
        let typeName = NSStringFromClass(type)
        let returnName = typeName.split { $0 == "." }.map { String($0) }.last ?? typeName
        return returnName
    }
    
    // MARK: - Class functions
    struct UIViewExternalLayerStruct {
        static let externalBorderName = "UIViewExternalLayerStructBorderName"
    }
    
    func addExternalBorder(layerWidth: CGFloat?, layerHeight: CGFloat?, borderWidth: CGFloat = 7.0, borderColor: UIColor = .black) {
        self.removeExternalBorder()
        
        let externalBorder = CALayer()
        let width = layerWidth ?? self.frame.size.width
        let height = layerHeight ?? self.frame.size.height
        
        externalBorder.frame = CGRect(x: -borderWidth, y: -borderWidth, width: width + (2 * borderWidth), height: height + (2 * borderWidth))
        externalBorder.borderColor = borderColor.cgColor
        externalBorder.borderWidth = borderWidth
        externalBorder.name = UIViewExternalLayerStruct.externalBorderName
        
        layer.insertSublayer(externalBorder, at: 0)
        layer.masksToBounds = false
    }
    
    func removeExternalBorder() {
        layer.sublayers?.filter { $0.name == UIViewExternalLayerStruct.externalBorderName }.forEach {
            $0.removeFromSuperlayer()
        }
    }
    
    func rotate360Degrees(_ duration: CFTimeInterval = 0.5 , clockwise: Bool = true, completionDelegate: CAAnimationDelegate? = nil) {
        self.layer.removeAllAnimations()
        print("rotating ...")
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = clockwise ? CGFloat(Double.pi * 2.0) : -CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.repeatCount = HUGE
        if let delegate: CAAnimationDelegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: "rotationAnimation")
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = gradientDirection.draw().x
        gradientLayer.endPoint = gradientDirection.draw().y
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorder(_ width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
    
    func set(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        setCorner(cornerRadius)
        setBorder(borderWidth, color: borderColor)
    }
    
    func setShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func setOuterShadow(viewRadius: CGFloat, shadowRadius: CGFloat, alpha: CGFloat, color: UIColor, opacity: Float = 1, offSet: CGSize = .zero, scale: Bool = true) {
        // Setup main view
        layer.cornerRadius = viewRadius
        layer.masksToBounds = true
        // Create shadow view below this view
        let shadowView = UIView()
        shadowView.layer.shadowColor = color.alpha(alpha).cgColor
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowOffset = offSet
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.cornerRadius = viewRadius
        shadowView.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        shadowView.clipsToBounds = false
        shadowView.backgroundColor = UIColor.white.alpha(0.1)
        superview?.insertSubview(shadowView, belowSubview: self)
        let constraints = [
            NSLayoutConstraint(item: shadowView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: shadowView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: shadowView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: shadowView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
            ]
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints(constraints)
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    func parentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.parentViewController()
        } else {
            return nil
        }
    }
}

// Extension about cutting & masking layers
extension UIView {
    func cut(hole: CGRect) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(self.bounds)
        p.addRect(hole)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
    
    func cut(path: CGPath) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(self.bounds)
        p.addPath(path)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
    
    func globalPointWithEntireScreen() -> CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    func globalFrameWithEntireScreen() -> CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}

