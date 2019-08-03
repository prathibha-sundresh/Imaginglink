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
    @IBOutlet weak var passwordToolTipImage: UIImageView!
    @IBOutlet weak var confirmTextFieldY: NSLayoutConstraint!
    @IBOutlet weak var signInLabel: SignInLabel!
    var otpValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInLabel.tapDelegate = self
        NewPasswordTextField.setUpLabel(WithText: "New password")
        ConfirmPasswordTF.setUpLabel(WithText: "Confirm new password")
        NewPasswordTextField.setRightPaddingPoints(30)
        showHiddedToolTipMessageAndImage(isBool: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func SavePressed(_ sender: Any) {
        if NewPasswordTextField.text?.count == 0{
            ILUtility.showAlert(message: "please enter new password", controller: self)
        }
        else if ConfirmPasswordTF.text?.count == 0{
            ILUtility.showAlert(message: "please enter confirm password", controller: self)
        }
        else if ConfirmPasswordTF.text! != NewPasswordTextField.text!{
            ILUtility.showAlert(message: "New password and confirm password should be same", controller: self)
        }
        else if ILUtility.isValidPassword(ConfirmPasswordTF.text!) && ILUtility.isValidPassword(NewPasswordTextField.text!) {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Resetting...")
            let requestValues = ["email" : UserDefaults.standard.value(forKey: kAuthenticatedEmailId)!,"otp_code" : otpValue, "new_password" : NewPasswordTextField.text!, "confirm_new_password" : ConfirmPasswordTF.text!] as [String:Any]
            CoreAPI.sharedManaged.requestForgetPassword(params: requestValues, successResponse: {[unowned self](response) in
                let dictValue = response as! [String:Any]
                if dictValue["status"] as! String == "success" {
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictValue["message"] as! String)
                    self.perform(#selector(self.moveToSignInAfterDelay), with: nil, afterDelay: 1.0)
                }
            }, faliure: {(error) in
                self.showToast(message: error,true,90)
//                ILUtility.showInAppNotification(withTitle: error)
//                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else {
            self.showToast(message: "Enter valid password",true,90)
//            ILUtility.showInAppNotification(withTitle: "Enter valid password")
        }
    }
    @objc func moveToSignInAfterDelay(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as!
        SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func textDidChange(_ textField: UITextField){
        if textField == NewPasswordTextField{
            if !ILUtility.isValidPassword(NewPasswordTextField.text!){
                passwordValidator.textColor = UIColor.red
                showHiddedToolTipMessageAndImage(isBool: false)
            }
            else{
                passwordValidator.textColor = UIColor.black
                showHiddedToolTipMessageAndImage(isBool: true)
            }
        }
    }
    func showHiddedToolTipMessageAndImage(isBool: Bool){
        passwordValidator.isHidden = isBool
        passwordToolTipImage.isHidden = isBool
        confirmTextFieldY.constant = isBool ? -17: 17
    }
}
