//
//  RegisterVC.swift
//  Fitness_App
//
//  Created by Anh Phuong on 4/18/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import Firebase
class RegisterVC: UIViewController {

    @IBOutlet weak var confirmPassTf: BorderTextField!
    @IBOutlet weak var passTf: BorderTextField!
    @IBOutlet weak var emailTf: BorderTextField!
    @IBOutlet weak var nameTf: BorderTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func registerAction(_ sender: Any) {
        guard let user = checkInfor() else { return }
        guard let email = user.email, let pass = user.passWord, let name = user.userName else { return }
        Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
            if let _ = error {
                UIAlertController.showSystemAlert(target: self, title: "Message", message: "Email nay da ton tai", buttons: ["Cancel"]) { (_, _) in
                }
                return
            }
            guard let uid = result?.user.uid else {
                return
            }
            DB.saveUser(uid: uid, name: name, email: email)
            VCService.present(type: HomeVC.self)
            
        }
        
    }
    private func checkInfor() -> UserProfile? {
        var user = UserProfile()
        guard let name = nameTf.text, name != "" else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Vui long nhap ten nguoi dung ", buttons: ["Cancel"]) { (_, _) in
            }
            return user
        }
        guard let email = emailTf.text, email != "" else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Vui long nhap email", buttons: ["Cancel"]) { (_, _) in
            }
            return user
        }
        guard let pass = passTf.text, pass != "" else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Vui long nhap mat khau", buttons: ["Cancel"]) { (_, _) in
            }
            return user
        }
        guard pass.count >= 8 else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Mat khau can co it nhat 8 ki tu ", buttons: ["Cancel"]) { (_, _) in
            }
            return user
        }
        guard let passConfirm = confirmPassTf.text, passConfirm != "" else {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Vui long nhap lai  mat khau", buttons: ["Cancel"]) { (_, _) in
            }
            return user
        }
        if  pass != passConfirm {
            UIAlertController.showSystemAlert(target: self, title: "Message", message: "Mat khau khong trung khop", buttons: ["Cancel"]) { (_, _) in
            }
            return user
        } else {
            user = UserProfile(userName: name, pass: pass, email: email)
            return user
        }
      
    }
  
}
