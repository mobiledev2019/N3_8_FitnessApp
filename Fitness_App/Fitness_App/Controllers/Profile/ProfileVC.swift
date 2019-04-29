//
//  ProfileVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/28/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {

    class func newNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: ProfileVC(nibName: "ProfileVC", bundle: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
