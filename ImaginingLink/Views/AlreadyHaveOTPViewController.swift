//
//  AlreadyHaveOTPViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 19/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class AlreadyHaveOTPViewController: UIViewController, TapOnLabelDelegate, UITextFieldDelegate {
//    Enter the CODE sent  to your E-mail
    @IBOutlet weak var OTPTextField: FloatingLabel!
    @IBOutlet weak var EmailTextField: FloatingLabel!
    @IBOutlet weak var resentLabel: UILabel!
    var EmailId : String = ""
    @IBOutlet weak var alreadySignInLabel: SignInLabel!
    @IBAction func VerifyOTPPressed(_ sender: Any) {
        if (OTPTextField!.text!.count == 0) {
             OTPTextField.errorMessage = "Please enter OTP"
        } else {
            self.OTPTextField.errorMessage = ""
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying...")
            CoreAPI.sharedManaged.requestOTPWithEmail(Email: EmailTextField.text!, OTP: OTPTextField!.text!, successResponse: {(response) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying OTP...")
                UserDefaults.standard.setValue(self.EmailTextField.text!, forKey: kAuthenticatedEmailId)
                let dictResponse = response as! [String:Any]
                let status = dictResponse["status"] as! String
                if status == "success" {
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Successfully verified otp..")
                    UserDefaults.standard.set(self.OTPTextField.text, forKey: OTP_Value)
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                    vc.emailId = self.EmailId
                    vc.ScreenName = kEmailVerifiedScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, faliure: {(error) in
                self.showToast(message: error)
//                self.OTPTextField.errorMessage = error
            })
        }
    }
    @IBOutlet weak var VerifyOTPPressed: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        alreadySignInLabel.tapDelegate = self
        
        EmailTextField.setUpLabel(WithText: "Email")
        EmailTextField.text = EmailId
        EmailTextField.delegate = self
        
        OTPTextField.setUpLabel(WithText: "Enter the CODE sent  to your E-mail")
        OTPTextField.delegate = self
        
        resendLabelAttribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tapForSignIn() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resendLabelAttribute() {
        let string : String = "We sent CODE to your E-mail if not received. Resend"
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            .font: UIFont(name: "Helvetica Neue", size: 14)!,
            .foregroundColor: UIColor.black,
            .kern: 0.5
            ])
        attributedString.addAttributes([
            .foregroundColor: UIColor(red: 0.0 / 255.0, green: 145.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: string.count - "Resend".count, length: "Resend".count))
        resentLabel.attributedText = attributedString
        resentLabel.isUserInteractionEnabled = true
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResend))
        resentLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapResend() {
        CoreAPI.sharedManaged.RegisterEmail(Email: EmailTextField.text!, successResponse: {(response) in
            let dictResponse = response as! [String:Any]
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictResponse["message"] as! String)
            
        }, faliure: {(error) in
            if (error == "Email already Registered") {
                self.showToast(message: error)
//                self.OTPTextField.errorMessage = error
            }
        })
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
    
}
