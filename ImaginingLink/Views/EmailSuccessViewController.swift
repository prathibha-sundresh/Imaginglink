//
//  EmailSuccessViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 04/06/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailSuccessViewController: UIViewController {
    var ScreenName : String = ""
    var emailId : String = ""
    @IBOutlet weak var TextToDisplayMessageLabel: UILabel!
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (ScreenName == kEmailVerifiedScreen) {
            TextToDisplayMessageLabel.text = "Your email verified successfully"
        } else if (ScreenName == kForgetPasswordScreen) {
            TextToDisplayMessageLabel.text = "We sent you an email with instructions \n on how to reset your password."
        } else if (ScreenName == kSignUpScreen) {
            TextToDisplayMessageLabel.text = "Thank you \nRegistration successfully"
        }
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self,  selector: #selector(callSignUp), userInfo:nil, repeats: true)
    }

    @objc func callSignUp() {
        timer?.invalidate()
        if (ScreenName == kEmailVerifiedScreen) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpViewcontroller") as! SignUpViewcontroller
            vc.emailId = emailId
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (ScreenName == kForgetPasswordScreen) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OTPViewcontroller") as! OTPViewcontroller
            vc.EmailId = emailId
            vc.screenId = kResetPasswordOTP
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (ScreenName == kSignUpScreen) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}
