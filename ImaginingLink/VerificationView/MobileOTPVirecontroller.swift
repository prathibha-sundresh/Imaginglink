//
//  MobileOTPVirecontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 23/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileOTPVirecontroller: UIViewController {
    @IBOutlet weak var OTPTextField: FloatingLabel!
    @IBAction func SubmitPressed(_ sender: Any) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying..")
        CoreAPI.sharedManaged.verifyMobileOTP(verificationCode: OTPTextField.text!, successResponse: {(response) in
            UserDefaults.standard.set(true, forKey: kTwoFactorAuthentication)
            let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoard") as! DashBoardViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
        
    }
    @IBAction func ResendOTPPressed(_ sender: Any) {
        CoreAPI.sharedManaged.reSendMobileOTP( successResponse: {(response) in
            self.OTPTextField.text! = ""
        }, faliure: {(error) in
            
        })

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTPTextField.setUpLabel(WithText: "Enter Verification Code")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
