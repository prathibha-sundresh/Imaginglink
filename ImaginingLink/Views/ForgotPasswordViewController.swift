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
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPasswordTextField.setUpLabel(WithText: "E-mail address")
        forgotPasswordTextField.delegate = self
        
        setAttributedString()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    fileprivate func setAttributedString() {
        let attributedString = NSMutableAttributedString(string: "Back to Login")
        let s = NSString(string: "Back to Login")
        let range = s.range(of: "Login")
        attributedString.addAttributes([.font: UIFont(name: "SFProDisplay-Semibold", size: 14.0)!, .foregroundColor: UIColor(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)], range: range)
        backButton.setAttributedTitle(attributedString, for: .normal)
    }
    @IBAction func backButtonAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ForgotPasswordSubmitPresses(_ sender: Any) {
        forgotPasswordTextField.resignFirstResponder()
        if (forgotPasswordTextField.text?.count == 0) {
            self.showToast(message: "Please Enter E-mail address",true)
        }
        else if (forgotPasswordTextField.text?.count != 0 && ILUtility.isValidEmail(testStr: forgotPasswordTextField.text!)){
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Resetting...")
            CoreAPI.sharedManaged.requesrForgotPassword(emailId: forgotPasswordTextField.text!, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                let status = dictResponse["status"] as! String
                if status == "success" {
                      UserDefaults.standard.setValue(self.forgotPasswordTextField.text!, forKey: kAuthenticatedEmailId)
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                    vc.ScreenName = kForgetPasswordScreen
                    vc.emailId = self.forgotPasswordTextField.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if status == "Failure" {
                    self.showToast(message: "User not found",true)
                }
            }, faliure: {(error) in
                self.showToast(message: error,true)
            })
        }
        else{
            self.showToast(message: "Please enter Valid Email Address",true)
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
