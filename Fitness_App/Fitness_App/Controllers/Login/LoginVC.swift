//
//  LoginVC.swift
//  Fitness_App
//
//  Created by Anh Phuong on 4/18/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
class LoginVC: BaseVC , GIDSignInUIDelegate{

    @IBOutlet weak var fbViewContant: UIView!
    @IBOutlet weak var ggViewContant: UIView!
    @IBOutlet weak var passTf: BorderTextField!
    
    @IBOutlet weak var emailTf: BorderTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    func setupView() {
        fbViewContant.layer.cornerRadius = 25
        ggViewContant.layer.cornerRadius = 25
    }
    
    @IBAction func loginWithFbAction(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if let _ = error {
                UIAlertController.showSystemAlert(target: self, title: "Message", message: "Login Facebook failed", buttons: ["Cancel"]) { (_, _) in
                }
                return
            }
           // print("Succed!")
            self.signIntoFirebase()
        }
    }
    
    @IBAction func loginWithGgAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func registerAction(_ sender: Any) {
//        VCService.push(type: RegisterVC.self)
        VCService.present(type: RegisterVC.self)
    }
    
    @IBAction func singIn(_ sender: Any) {
        guard let email = emailTf.text, let pass = passTf.text else {return}
        Auth.auth().signIn(withEmail: email , password: pass) { (result, error) in
            if let _ = error {
                return
            }
            VCService.present(type: HomeVC.self)
        }
    }
    private func signIntoFirebase() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let _ = error {
                return
            }
            VCService.present(type: HomeVC.self)
        }
    
    
    }
}
