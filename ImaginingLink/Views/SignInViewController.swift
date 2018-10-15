//
//  SignInViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/27/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    //
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBAction func SignInAction(_ sender: Any) {
        SignInPressed()
    }
    @IBAction func ForgotPasswordPressed(_ sender: Any) {
    }
    
    @IBAction func SignUpPresses(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EmailViewcontroller") as! EmailScreenViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "DashBoard") as! DashBoardViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func SignInPressed() {
         ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Message", MessageToDisplay: "Please wait")
        let username = UserNameTextField.text
        let passWord = PasswordTextField.text
        
        if username?.count != 0 && passWord?.count != 0 {
            CoreAPI.sharedManaged.signIn(userName: username!, password: passWord!, successResponse: {(response) in
                let isEnableTwoFactorAuthentication = UserDefaults.standard.bool(forKey: kTwoFactorAuthentication) as Bool
                if (isEnableTwoFactorAuthentication) {
                    let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DashBoard") as! DashBoardViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                
                let dictResponse = response as! [String:Any]
                if let data : [String:Any] = dictResponse["data"] as? [String : Any]  {
                
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Message", MessageToDisplay: "Successfully Registered" )
//                    let data = dictResponse["data"] as! [String:Any]
                    UserDefaults.standard.set(data["token"] as! String, forKey: kToken)
                    UserDefaults.standard.set(data["email"] as! String, forKey: kAuthenticatedEmailId)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TwoFactorAuthenticationViewcontroller") as!
                    TwoFactorAuthenticationViewcontroller
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
                    
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Error", MessageToDisplay: "Something went wrong while signIn")
            })
        
        }
        
    
    }
    
    
//    @objc func NewInvitePressedAction(sender : UITapGestureRecognizer) -> Void {
//         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EmailViewcontroller") as! EmailScreenViewcontroller
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    

}
