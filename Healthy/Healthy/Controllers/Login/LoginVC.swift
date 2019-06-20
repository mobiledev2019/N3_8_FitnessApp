//
//  LoginVC.swift
//  Healthy
//
//  Created by Phuong_Nguyen on 5/5/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import SkyFloatingLabelTextField
import RealmSwift

class LoginVC: BaseVC  {
    
    //MARK: - Outlets
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextField!
    
    //instance navigation controller
    class func newNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: LoginVC(nibName: "LoginVC", bundle: nil))
    }
    
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    //MARK: - actions
    @IBAction func loginFacebookAction(_ sender: UIButton) {
        if self.facebooklogin() {
            VCService.push(type: TabbarVC.self)
        }
    }
    
    @IBAction func loginGoogleAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let mail = tfEmail.text
        let pass = tfPassword.text
        if checkAccount(mail: mail, pass: pass) {
            VCService.push(type: TabbarVC.self)
        }
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        VCService.push(type: RegisterVC.self)
    }
    
    @IBAction func skipLoginAction(_ sender: UIButton) {
//        showMess(mess: "Warning!: is you skip login, you will can not edit all exercise")
//        VCService.push(type: TabbarVC.self)
//        VCService.present(type: TabbarVC.self)
        
        UIAlertController.showSystemAlert(target: self, title: "Message", message: "You   skip login, so you can not edit or create exercise", buttons: ["OK"], handler: { ( _, _ ) in
            
            VCService.push(type: TabbarVC.self)
        })
    }
    
    //MARK: - methods support
    func addNewUserFromGoogle(mail: String?, username: String?) {
        guard let mail = mail else {
            return
        }
        
        if let user = RealmManager.shareInstance.getUserProfile(mail: mail) {
            let realm = try! Realm()
            try! realm.write {
                user.isLogout = false
            }
            return
        }
        
        let user = Profile()
        user.email = mail
        user.userName = username
        user.isRegister = false
        user.isLogout = false
        addListExercisesToUser(newuser: user)
        RealmManager.shareInstance.addNewUser(user: user)
        
    }
    func addListExercisesToUser(newuser: Profile) {
        let listEx = RealmManager.shareInstance.getAllExercises()
        for temp in listEx {
            if let name = temp.name {
                newuser.listExercies.append(name)
            }
        }
    }
    
    func checkAccount(mail: String?, pass: String?) -> Bool{
        guard let mail = mail, mail != "",  let pass = pass, pass != "" else {
            showMess(mess: "You need to enter your mail and pass")
            return false
        }
        guard let user = RealmManager.shareInstance.getUserProfile(mail: mail) else {
            showMess(mess: "Wrong Email!")
            return false
        }
        
        guard user.isRegister else {
            showMess(mess: "Sorry! You did login with facebook or google. Please try with FB or GG and don't forget check your network.")
            return false
        }
        
        if user.passWord != pass {
            showMess(mess: "Wrong password!")
            return false
        }
        
        let realm = try! Realm()
        try! realm.write {
            user.isLogout = false
        }
        
        return true
        
    }
    func showMess(mess: String) {
        UIAlertController.showSystemAlert(target: self, title: "Message", message: mess, buttons: ["OK"])
    }
    
    func facebooklogin() -> Bool{
        var re = false
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], handler: { (result, error) -> Void in
            
            if (error == nil) {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                   return
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                    re = true
                    print("login fb success")
                }
            }
        })
        
        return re
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                
            }
            else
            {
                let resultDic = result as! NSDictionary
                print("\n\n  fetched user: \(result)")
                let username = resultDic.value(forKey:"name")! as! String as NSString?
                let mail = resultDic.value(forKey:"email")! as! String as NSString?
                guard let mailStr = mail else {
                    return
                }
                self.addNewUserFromGoogle(mail: mailStr as String, username: username as! String)
                
                    VCService.push(type: TabbarVC.self)
                
                
                print("---------------------------------------------------")
            }
        })
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
}

extension LoginVC: GIDSignInUIDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
        if let error = error {
            print("Erroerrrrrrrrrrrrrrrrrrrr")
            print(error.localizedDescription)
            return
        }
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        // When user is signed in
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            //savedata into realm
            self.addNewUserFromGoogle(mail: user?.email, username: user?.displayName)
            
            VCService.push(type: TabbarVC.self)
            
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
        })
    }
    // Start Google OAuth2 Authentication
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
        
        // Showing OAuth2 authentication window
        if let aController = viewController {
            present(aController, animated: true) {() -> Void in }
        }
    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        dismiss(animated: true) {() -> Void in }
    }
}
