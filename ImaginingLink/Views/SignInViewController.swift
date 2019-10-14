//
//  SignInViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/27/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var UserNameTextField: FloatingLabel!
    @IBOutlet weak var PasswordTextField: FloatingLabel!
    
    @IBAction func SignInAction(_ sender: Any) {
        SignInPressed()
    }
    
    func setUpTextField() {
        UserNameTextField.setUpLabel(WithText: "Email")
        UserNameTextField.delegate = self
        PasswordTextField.setUpLabel(WithText: "Password")
        PasswordTextField.delegate = self
    }
    
    @IBAction func ForgotPasswordPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as!
        ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func SignUpPresses(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EmailViewcontroller") as! EmailScreenViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let floatingLabelTextField = textField as? FloatingLabel {
            if ((textField.text != nil) && (textField.text?.count)! > 0)
            {
                  return true
            }
            else
            {
               floatingLabelTextField.errorMessage = ""
                return true
            }
        }
        
        return false
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func SignInPressed() {
        let username = UserNameTextField.text
        let passWord = PasswordTextField.text
        
        if username?.count != 0 && passWord?.count != 0 {
            ILUtility.showProgressIndicator(controller: self)
            CoreAPI.sharedManaged.signIn(userName: username!, password: passWord!, successResponse: {(response) in
                ILUtility.hideProgressIndicator(controller: self)
                let dictResponse = response as! [String:Any]
                if let data : [String:Any] = dictResponse["data"] as? [String : Any]  {
                
                    if let usertype : [String:Any] = data["user_type"] as? [String:Any] {
                        UserDefaults.standard.set(usertype["title"] as! String, forKey: kUserType)
                    }
               
                    UserDefaults.standard.set(data["token"] as! String, forKey: kToken)
                    UserDefaults.standard.set(data["email"] as! String, forKey: kAuthenticatedEmailId)
                    let firstName = data["first_name"]as? String ?? ""
                    let lastName = data["last_name"]as? String ?? ""
                    let fullName = "\(firstName) \(lastName)".capitalized
                    UserDefaults.standard.set(firstName, forKey: kFirstName)
                    UserDefaults.standard.set(lastName, forKey: kLastName)
                    UserDefaults.standard.set(fullName, forKey: kUserName)
                    
                    if (data["is_enable_2f_authentication"] as? NSNull) != nil {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "TwoFactorAuthenticationViewcontroller") as!
                        TwoFactorAuthenticationViewcontroller
                        self.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                        let isEnableTwoFactorAuthentication = data["is_enable_2f_authentication"] as! Bool
                        UserDefaults.standard.set(isEnableTwoFactorAuthentication, forKey: kTwoFactorAuthentication)
                        if (!isEnableTwoFactorAuthentication) {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.openDashBoardScreen()
                        } else {
                            
                            CoreAPI.sharedManaged.sendOtpToEnabledUser(successResponse: {(response) in
                                
                                let storyBoard = UIStoryboard(name: "Verification", bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "MobileOTPViewController") as! MobileOTPVirecontroller
                                vc.isFromSignIn = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }, faliure: {(error) in
                                
                            })
                            
                        }
            }
                    
            }, faliure: {(error) in
                ILUtility.hideProgressIndicator(controller: self)
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        
        } else if (username?.count == 0) {
            UserNameTextField.errorMessage = "Please Enter UserName"
//             ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please enter Email")
        } else if (passWord?.count == 0) {
            PasswordTextField.errorMessage = "Please Enter Password"
            // ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please enter password")
        }
    }
}
