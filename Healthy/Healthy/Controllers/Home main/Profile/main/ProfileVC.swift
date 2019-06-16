//
//  ProfileVC.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 4/28/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

enum Type {
    case UserName
    case Email
    case Height
    case Weight
    case Pass
    case Answer
}

class ProfileVC: BaseVC {
    // MARK: - Outlets
//    @IBOutlet weak var emailView: UIView!
//    @IBOutlet weak var heightView: UIView!
//    @IBOutlet weak var weightView: UIView!
//    @IBOutlet weak var passView: UIView!
//    @IBOutlet weak var answerView: UIView!
    
    @IBOutlet weak var imgAva: ColorImageView!
    @IBOutlet weak var imgNextEmail: ColorImageView!
    @IBOutlet weak var imgNextUserName: ColorImageView!
    @IBOutlet weak var imgNextHeight: ColorImageView!
    @IBOutlet weak var imgNextWeight: ColorImageView!
    @IBOutlet weak var imgNextPass: ColorImageView!
    @IBOutlet weak var imgNextAnswer: ColorImageView!
    
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbHeight: UILabel!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var lbPass: UILabel!
    @IBOutlet weak var lbAnswer: UILabel!
    
    
    
    @IBOutlet weak var btnLogout: GradientButton!
    
    //MARK: - Variables
    var imagePicker = UIImagePickerController()
    var user: Profile?
    class func newNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: ProfileVC(nibName: "ProfileVC", bundle: nil))
    }
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - setup
    func setUpData() {
        user = RealmManager.shareInstance.getCurrentUser()
        print(user)
    }
    
    func setUpUI() {
        guard let profile = user  else {
            lbEmail.text = ""
            lbUsername.text = ""
            btnLogout.setTitle("Back to Login", for: .normal)
            return
        }
        btnLogout.setTitle("Logout", for: .normal)
        guard let email = profile.email, let username = profile.userName else {
            return
        }
        lbEmail.text = email
        lbUsername.text = username
        
        lbUserName.text = username
        
        
        //setup ava
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgAva.isUserInteractionEnabled = true
        imgAva.addGestureRecognizer(singleTap)
        
        imgAva.layer.masksToBounds = false
        imgAva.layer.cornerRadius = imgAva.frame.height / 2 + 10
        imgAva.clipsToBounds = true
        imgAva.layer.borderWidth = 1
        imgAva.layer.borderColor = UIColor.white.cgColor
        
        if let data = user?.avatar {
            let img = UIImage(data: data)
            imgAva.image = img
        }
        
        //setup action change username
        let actionChangeUsername = UITapGestureRecognizer(target: self, action: #selector(changeUsername))
        lbUserName.isUserInteractionEnabled = true
        lbUserName.addGestureRecognizer(actionChangeUsername)
        //        imgNextEmail.isUserInteractionEnabled = true
        //        imgNextEmail.addGestureRecognizer(actionChangeEmail)
        
        //setup action change email
        let actionChangeEmail = UITapGestureRecognizer(target: self, action: #selector(changeEmail))
        lbEmail.isUserInteractionEnabled = true
        lbEmail.addGestureRecognizer(actionChangeEmail)
//        imgNextEmail.isUserInteractionEnabled = true
//        imgNextEmail.addGestureRecognizer(actionChangeEmail)
        
        //setup action change height
        if let height = user?.height, height != 0.0 {
            lbHeight.text = NSString(format: "%.2f", height) as String
            
        } else {
            lbHeight.text = "Chưa đặt"
        }
        let actionChangeHeight = UITapGestureRecognizer(target: self, action: #selector(changeHeight))
        lbHeight.isUserInteractionEnabled = true
        lbHeight.addGestureRecognizer(actionChangeHeight)
//        imgNextHeight.isUserInteractionEnabled = true
//        imgNextHeight.addGestureRecognizer(actionChangeHeight)
        
        //setup action change weight
        if let weight = user?.weight, weight != 0.0 {
            lbWeight.text = NSString(format: "%.2f", weight) as String
            
        } else {
            lbWeight.text = "Chưa đặt"
        }
        let actionChangeWeight = UITapGestureRecognizer(target: self, action: #selector(changeWeight))
        lbWeight.isUserInteractionEnabled = true
        lbWeight.addGestureRecognizer(actionChangeWeight)
//        imgNextWeight.isUserInteractionEnabled = true
//        imgNextWeight.addGestureRecognizer(actionChangeWeight)
        
        //setup action change pass
        let actionChangePass = UITapGestureRecognizer(target: self, action: #selector(changePass))
        lbPass.isUserInteractionEnabled = true
        lbPass.addGestureRecognizer(actionChangePass)
//        imgNextPass.isUserInteractionEnabled = true
//        imgNextPass.addGestureRecognizer(actionChangePass)
        //setup action change answer
        let actionChangeAnswer = UITapGestureRecognizer(target: self, action: #selector(changeAnswer))
        lbAnswer.isUserInteractionEnabled = true
        lbAnswer.addGestureRecognizer(actionChangeAnswer)
        
    }
 
    //MARK: - actions
    @IBAction func logoutAction(_ sender: UIButton) {
        if let user = RealmManager.shareInstance.getCurrentUser()  {
            let realm = try! Realm()
            try! realm.write {
                user.isLogout = true
            }
        }
 
        UIApplication.shared.keyWindow?.rootViewController = LoginVC.newNavigationController()
        
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
//                self.navigationController.pop
//                self.navigationController!.popToRootViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - method support
    func backToLogin() {
        UIApplication.shared.keyWindow?.rootViewController = LoginVC.newNavigationController()
        
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                self.navigationController!.popToRootViewController(animated: true)
            })
        }
        else {
            self.navigationController!.popToRootViewController(animated: true)
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
    
    @objc func changeUsername() {
        showTextfieldAlert(title: "Thay đổi tân đăng nhập", mess: "Nhập tên đăng nhập mới", type: .UserName)
    }
    
    @objc func changeEmail() {
        showTextfieldAlert(title: "Thay đổi email", mess: "Nhập email mới", type: .Email)
    }
    
    @objc func changeHeight() {
        showTextfieldAlert(title: "Thay đổi chiều cao", mess: "Nhập chiều cao hiện tại của bạn", type: .Height)
    }
    
    @objc func changeWeight() {
        showTextfieldAlert(title: "Thay đổi cân nặng", mess: "Nhập cân nặng hiện tại của bạn", type: .Weight)
    }
    
    @objc func changePass() {
        showTextfieldAlert(title: "Thay đổi mật khẩu", mess: "Nhập mật khẩu mới", type: .Pass)
    }
    
    @objc func changeAnswer() {
//        showTextfieldAlert(title: "Thay đổi câu hỏi bảo mật", mess: "Nhập câu trả lời mới", type: .Answer)
        VCService.push(type: WeekSchedule.self)
    }
    
    func showTextfieldAlert(title: String, mess: String, type: Type) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "enter new info"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            guard let newInfo = textField?.text else { return }
            let realm = try! Realm()
            switch type {
            case .UserName:
                print("change your user name")
                try! realm.write {
                    self.user?.userName = newInfo
                }
                self.lbUserName.text = newInfo
                self.lbUsername.text = newInfo
                
            case .Email:
                print("change your email")
                try! realm.write {
                    self.user?.email = newInfo
                }
                self.lbEmail.text = newInfo
            case .Height:
                print("change your height")
                let height = (newInfo as NSString).floatValue
                try! realm.write {
                    self.user?.height = height
                }
                self.lbHeight.text = newInfo
            case .Weight:
                print("change your weight")
                let weight = (newInfo as NSString).floatValue
                try! realm.write {
                    self.user?.weight = weight
                }
                self.lbWeight.text = newInfo
            case .Pass:
                print("change your pass")
                
                
            case .Answer:
                print("change your answer")
            }
            print("Text field: \(textField!.text)")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("cancel")
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imgUrl = info[.imageURL] as? URL, let imgNSData = NSData(contentsOf: imgUrl) {
            print("------imgURL\(info[.imageURL])")
            let data = Data(referencing: imgNSData)
            let img = UIImage(data: data)
            
            imgAva.image = img
            
            let realm = try! Realm()
            try! realm.write {
                user?.avatar = data
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
