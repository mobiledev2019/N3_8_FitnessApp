//
//  LoadingVC.swift
//  PtitMe
//
//  Created by kienpt on 2/26/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import RealmSwift
class LoadingVC: BaseVC {

    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        if !SharedData.isUserAppFirst {
            VCService.push(type: TutorialVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        } else {
            
            if let _ = RealmManager.shareInstance.getCurrentUser() {
                VCService.push(type: TabbarVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
            } else {
                VCService.push(type: LoginVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
            }
        }
//        !SharedData.isUserAppFirst ? VCService.push(type: LoginVC.self, fromController: self, prepare: nil, animated: false, completion: nil) : VCService.push(type: TabbarVC.self, fromController: self, prepare: nil, animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.lockOrientation(.portrait)
    }

}
