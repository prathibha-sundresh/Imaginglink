//
//  MobileOTPVirecontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 23/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileOTPVirecontroller: BaseHamburgerViewController {
    var isFromSignIn: Bool = false
    @IBOutlet weak var OTPTextField: FloatingLabel!
    @IBAction func SubmitPressed(_ sender: Any) {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.verifyMobileOTP(verificationCode: OTPTextField.text!, successResponse: {(response) in
            ILUtility.hideProgressIndicator(controller: self)
            if self.isFromSignIn{
                UserDefaults.standard.set(true, forKey: kTwoFactorAuthentication)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openDashBoardScreen()
            }
            else{
                CoreAPI.sharedManaged.logOut()
            }
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
        
    }
    @IBAction func ResendOTPPressed(_ sender: Any) {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.reSendMobileOTP( successResponse: {(response) in
            self.OTPTextField.text! = ""
            ILUtility.hideProgressIndicator(controller: self)
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if !self.isFromSignIn{
            addSlideMenuButton(showBackButton: true ,backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        OTPTextField.setUpLabel(WithText: "Enter Verification Code")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
