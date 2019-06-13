//
//  TapActionView.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class TapActionView: UIView {

    // MARK: - Closures
    var didTap: (() -> Void)?
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    // MARK: - Action
    @objc private func tapGestureAction(sender: UITapGestureRecognizer) {
        didTap?()
    }

}
