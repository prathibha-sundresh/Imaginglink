//
//  OTPViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/27/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class OTPViewcontroller : UIViewController, TapOnLabelDelegate{
    @IBOutlet weak var resendOtpLabel: UILabel!
    
    //pragma mark - Serp Header View Methods
    @IBOutlet weak var SignInLabel: SignInLabel!
    var EmailId = ""
     var screenId = ""
    @IBAction func OTPPressed(_ sender: Any) {
        if OTPTextField?.text?.count != 0 {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying...")
            if screenId == kEmailOTP {
                CoreAPI.sharedManaged.requestOTPWithEmail(Email: EmailId, OTP: OTPTextField!.text!, successResponse: {(response) in
                     ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying Email...")
                    UserDefaults.standard.setValue(self.EmailId, forKey: kAuthenticatedEmailId)
                    let dictResponse = response as! [String:Any]
                    let status = dictResponse["status"] as! String
                    if status == "success" {
                        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "successfully Verified")
                        UserDefaults.standard.set(self.OTPTextField.text, forKey: OTP_Value)
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                        vc.emailId = self.EmailId
                        vc.ScreenName = kEmailVerifiedScreen
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }, faliure: {(error) in
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
                })
            } else if screenId == kResetPasswordOTP {
                 ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Resetting password...")
                CoreAPI.sharedManaged.requestOTPForResetPassword(Email: UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String, OTP: OTPTextField!.text!, successResponse: {[unowned self](response) in
                    let dictResponse = response as! [String:Any]
                    let status = dictResponse["status"] as! String
                    if status == "success" {
                        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Successfully Resetted the password.")
                        self.perform(#selector(self.moveToResetPasswordAfterDelay), with: nil, afterDelay: 1.0)
                    }
                }, faliure: {(error) in
                    //ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
                    self.showToast(message: error, true,90)
                })
            }
            
        }
    }
    @IBOutlet weak var OTPTextField: FloatingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInLabel.tapDelegate = self
        OTPTextField.setUpLabel(WithText: "Enter Otp")
//        OTPTextField.text = EmailId
//        if screenId == kResetPasswordOTP {
            resendLabelAttribute()
//            resendOtpLabel.isHidden = false
//        } else {
//            resendOtpLabel.isHidden = true
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @objc func moveToResetPasswordAfterDelay(){
        UserDefaults.standard.set(self.OTPTextField.text, forKey: OTP_Value)
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewContoller") as! ResetPasswordViewContoller
        vc.otpValue = self.OTPTextField.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tapForSignIn() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resendLabelAttribute() {
        let string : String = "If CODE is not received in 3 minutes, you may request new CODE, Generate CODE >>"
        let attributedString = NSMutableAttributedString(string: string, attributes: [
            .font: UIFont(name: "Helvetica Neue", size: 14)!,
            .foregroundColor: UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.5),
            .kern: 0.5
            ])
        attributedString.addAttributes([
            .foregroundColor: UIColor(red: 0.0 / 255.0, green: 145.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: string.count - "Generate CODE >>".count, length: "Generate CODE >>".count))
        resendOtpLabel.attributedText = attributedString
        resendOtpLabel.isUserInteractionEnabled = true
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResend))
        resendOtpLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapResend() {
        
        if screenId == kResetPasswordOTP{
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Resending...")
            CoreAPI.sharedManaged.requesrForgotPassword(emailId: EmailId, successResponse: { (response) in
               self.showToast(message: "successfully sent",false,90)
            }) { (error) in
                self.showToast(message: error,true,90)
            }
        }
        else{
            CoreAPI.sharedManaged.RegisterEmail(Email: EmailId, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictResponse["message"] as! String)
                
            }, faliure: {(error) in
                
                if (error == "Email already Registered") {
                    self.resendOtpLabel.isHidden = false
                }
            })
        }
    }
}
