//
//  BasePicker.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//

import UIKit

class BasePicker: UIViewController {
    var configBeforeShow: (() -> Void)?
    var configBeforeHide: (() -> Void)?
    var configWhenShow: (() -> Void)?
    var configWhenHide: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showWithAnimation(completion: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        configBeforeShow?()
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.configWhenShow?()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
    
    func hideWithAnimation(completion: (() -> Void)? = nil) {
        view.layoutIfNeeded()
        configBeforeHide?()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.configWhenHide?()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }
}
