//
//  LoadingVC.swift
//  PtitMe
//
//  Created by kienpt on 2/26/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit

class LoadingVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        VCService.present(type: HomeVC.self)
//        VCService.push(type: LoginVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        
//        !SharedData.isUserAppFirst ? VCService.push(type: TutorialVC.self, fromController: self, prepare: nil, animated: false, completion: nil) : VCService.push(type: LoginVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.lockOrientation(.portrait)
    }

}
