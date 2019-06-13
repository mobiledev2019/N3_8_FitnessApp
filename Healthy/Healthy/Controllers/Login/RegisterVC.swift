//
//  RegisterVC.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/6/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class RegisterVC: BaseVC {

    //MARK: - Outlets
    @IBOutlet weak var imgAva: ColorImageView!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfUsername: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var tfConfirmPass: SkyFloatingLabelTextField!
    
    //MARK: - Variables
    var imagePicker = UIImagePickerController()
    var ava: Data?
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        //setup
        setUp()
    }
    
    //MARK: - setup
    func setUp() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgAva.isUserInteractionEnabled = true
        imgAva.addGestureRecognizer(singleTap)
        
        imgAva.layer.masksToBounds = false
        imgAva.layer.cornerRadius = imgAva.frame.height / 2
        imgAva.layer.borderWidth = 1
        imgAva.layer.borderColor = UIColor.white.cgColor
        imgAva.clipsToBounds = true
    }
    
    //MARK: - actions
    @IBAction func backAction(_ sender: UIButton) {
        VCService.pop()
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        if register() {
            VCService.push(type: TabbarVC.self)
        } else {
            showMess(mess: "Can not register, please try again")
        }
    }
    
    //MARK: - method support
    func register() -> Bool{
        guard let mail = tfEmail.text, mail != "" else {
            showMess(mess: "Please enter your mail")
            return false
        }
        
        if let _ = RealmManager.shareInstance.getUserProfile(mail: mail) {
            showMess(mess: "Sorry! Your have created account by this mail")
            return false
        }
        
        guard let username = tfUsername.text, username != "" else {
            showMess(mess: "Please enter your username!")
            return false
        }
        
        guard let pass = tfPassword.text, pass != "" else {
            showMess(mess: "Please enter your password")
            return false
        }
        
        guard let confirm = tfConfirmPass.text, confirm != "" else {
            showMess(mess: "Please confirm your password")
            return false
        }
        
        guard pass == confirm else {
            showMess(mess: "Your confirm password not match")
            return false
        }
        
        let user = Profile()
        user.email = mail
        user.userName = username
        user.passWord = pass
        user.isLogout = false
        user.avatar = ava
        let listEx = RealmManager.shareInstance.getAllExercises()
        for temp in listEx {
            if let name = temp.name {
                user.listExercies.append(name)
            }
        }
        RealmManager.shareInstance.addNewUser(user: user)
        
        Auth.auth().createUser(withEmail: mail, password: pass, completion: nil)
        return true
    }
    
    func showMess(mess: String) {
        UIAlertController.showSystemAlert(target: self, title: "Message", message: mess, buttons: ["OK"])
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    @objc func chooseImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
        if let imgURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print("hihihhiih path: \(imgURL)")
        }
        
        if let imgUrl = info[.imageURL] as? URL, let imgNSData = NSData(contentsOf: imgUrl) {
            print("------imgURL\(info[.imageURL])")
            let data = Data(referencing: imgNSData)
            self.ava = data
            let img = UIImage(data: data)
            let imgName = imgUrl.lastPathComponent
            print("name: \(imgName)")
            
            imgAva.image = img
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
