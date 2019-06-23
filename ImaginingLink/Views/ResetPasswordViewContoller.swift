//
//  ResetPasswordViewContoller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 01/08/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

enum MessageBanner {
    case InAppNotificationRed
    case InAppNotificationYellow
    case InAppNotificationBlue
}

class ResetPasswordViewContoller: UIViewController, TapOnLabelDelegate {
    func tapForSignIn() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var NewPasswordTextField: FloatingLabel!
    @IBOutlet weak var ConfirmPasswordTF: FloatingLabel!
    @IBOutlet weak var passwordValidator: UILabel!
    
    @IBOutlet weak var signInLabel: SignInLabel!
    var otpValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInLabel.tapDelegate = self
        NewPasswordTextField.setUpLabel(WithText: "New password")
        ConfirmPasswordTF.setUpLabel(WithText: "confirm Password")
        NewPasswordTextField.setRightPaddingPoints(30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func SavePressed(_ sender: Any) {
        if ((ConfirmPasswordTF.text! == NewPasswordTextField.text!) && (ILUtility.isValidPassword(ConfirmPasswordTF.text!)) && (ILUtility.isValidPassword(NewPasswordTextField.text!))) {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Resetting...")
            let requestValues = ["email" : UserDefaults.standard.value(forKey: kAuthenticatedEmailId)!,"otp_code" : otpValue, "new_password" : NewPasswordTextField.text!, "confirm_new_password" : ConfirmPasswordTF.text!] as [String:Any]
            CoreAPI.sharedManaged.requestForgetPassword(params: requestValues, successResponse: {(response) in
                let dictValue = response as! [String:Any]
                if dictValue["status"] as! String == "success" {
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictValue["message"] as! String)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as!
                        SignInViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }, faliure: {(error) in
                self.showToast(message: error)
//                ILUtility.showInAppNotification(withTitle: error)
//                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else {
            self.showToast(message: "Enter valid password")
//            ILUtility.showInAppNotification(withTitle: "Enter valid password")
        
        }
    }
    
    @IBAction func textDidChange(_ textField: UITextField){
        if textField == NewPasswordTextField{
            if !ILUtility.isValidPassword(NewPasswordTextField.text!){
                passwordValidator.textColor = UIColor.red
            }
            else{
                passwordValidator.textColor = UIColor.black
            }
        }
    }
}
