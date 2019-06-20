//
//  BaseVC.swift
//  PtitMe
//
//  Created by kienpt on 02/18/19.
//  Copyright © 2019 Mobileteam. All rights reserved.
//
import UIKit

class BaseVC: UIViewController {

    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfig()
    }

    // MARK: - Setup
    func baseConfig() {
        edgesForExtendedLayout = []
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utils.lockOrientation(.all)
    }
    
    func checkIsLandscape() -> Bool {
        return UIDevice.current.orientation.isLandscape
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
