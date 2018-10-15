//
//  OTPViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/27/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class OTPViewcontroller : UIViewController, TapOnLabelDelegate{
    
    @IBOutlet weak var SignInLabel: SignInLabel!
    var EmailId = ""
     var screenId = ""
    @IBAction func OTPPressed(_ sender: Any) {
        if OTPTextField?.text?.count != 0 {
            if screenId == kEmailOTP {
                CoreAPI.sharedManaged.requestOTPWithEmail(Email: EmailId, OTP: OTPTextField!.text!, successResponse: {(response) in
                    UserDefaults.standard.setValue(self.EmailId, forKey: kAuthenticatedEmailId)
                    let dictResponse = response as! [String:Any]
                    let status = dictResponse["status"] as! String
                    if status == "success" {
                        UserDefaults.standard.set(self.OTPTextField.text, forKey: OTP_Value)
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }, faliure: {(error) in
                    
                })
            } else if screenId == kResetPasswordOTP {
                CoreAPI.sharedManaged.requestOTPForResetPassword(Email: UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String, OTP: OTPTextField!.text!, successResponse: {(response) in
                    let dictResponse = response as! [String:Any]
                    let status = dictResponse["status"] as! String
                    if status == "success" {
                        UserDefaults.standard.set(self.OTPTextField.text, forKey: OTP_Value)
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewContoller") as! ResetPasswordViewContoller
                        vc.otpValue = self.OTPTextField.text!
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }, faliure: {(error) in
                    
                })
            }
            
        }
    }
    @IBOutlet weak var OTPTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInLabel.tapDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tapForSignIn() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
