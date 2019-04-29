//
//  LoadingVC.swift
//  PtitMe
//
//  Created by kienpt on 2/26/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class LoadingVC: BaseVC {

    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpData()
        
//        VCService.present(type: TabbarVC.self)
//        VCService.present(type: HomeVC.self)
//        VCService.push(type: LoginVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        
        if !SharedData.isUserAppFirst {
            VCService.push(type: TutorialVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        } else {
            
        }
//        !SharedData.isUserAppFirst ? VCService.push(type: LoginVC.self, fromController: self, prepare: nil, animated: false, completion: nil) : VCService.push(type: TabbarVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.lockOrientation(.portrait)
    }
    
    //MARK: - setup
    func setUpData() {
        print("in set up Loading VC")
        
        if SharedData.isUserAppFirst {
            UserDefaults.standard.set(true, forKey: "IsUserAppFirst")
        } 
        
    }

}
