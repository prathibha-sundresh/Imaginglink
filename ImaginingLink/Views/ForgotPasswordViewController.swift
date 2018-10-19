//
//  ForgotPasswordViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 31/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var forgotPasswordTextField: FloatingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPasswordTextField.setUpLabel(WithText: "E-mail address")
        forgotPasswordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func ForgotPasswordSubmitPresses(_ sender: Any) {
        if (forgotPasswordTextField.text?.count == 0) {
            self.showToast(message: "Please Enter E-mail address")
        }
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Resetting...")
        if (forgotPasswordTextField.text?.count != 0 && ILUtility.isValidEmail(testStr: forgotPasswordTextField.text!)){
            CoreAPI.sharedManaged.requesrForgotPassword(emailId: forgotPasswordTextField.text!, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                let status = dictResponse["status"] as! String
                if status == "success" {
                    self.showToast(message: "successfully changed")
                      UserDefaults.standard.setValue(self.forgotPasswordTextField.text!, forKey: kAuthenticatedEmailId)
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                    vc.ScreenName = kForgetPasswordScreen
                    vc.emailId = self.forgotPasswordTextField.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if status == "Failure" {
                    self.showToast(message: "User not found")
                }
            }, faliure: {(error) in
                self.showToast(message: error)
            })
        }
    }
    
    // This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let floatingLabelTextField = textField as? FloatingLabel {
            if ((textField.text?.count)! > 3) && ((textField.text?.contains("@"))!)
            {
                floatingLabelTextField.errorMessage = ""
                return true
            }
            else
            {
                floatingLabelTextField.errorMessage = "Please enter Valid Email Address"
                return true
            }
        }
        
        return false
        
        
    }
}
