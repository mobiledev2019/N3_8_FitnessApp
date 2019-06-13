//
//  ColorImageView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

@IBDesignable class ColorImageView: UIImageView {

    // MARK: - Inspectables
    @IBInspectable var color: UIColor = .clear {
        didSet {
            image = image?.renderTemplate()
            tintColor = color
        }
    }
    
    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        // Do nothing
    }
}
