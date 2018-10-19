//
//  AlreadyHaveOTPViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 19/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class AlreadyHaveOTPViewController: UIViewController, TapOnLabelDelegate {
    
    var EmailId : String = ""
    @IBOutlet weak var alreadySignInLabel: SignInLabel!
    @IBAction func VerifyOTPPressed(_ sender: Any) {
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
                vc.ScreenName = kEmailVerifiedScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, faliure: {(error) in
            
        })
    }
    @IBOutlet weak var VerifyOTPPressed: UIButton!
    @IBOutlet weak var OTPTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.text! = EmailId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tapForSignIn() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
