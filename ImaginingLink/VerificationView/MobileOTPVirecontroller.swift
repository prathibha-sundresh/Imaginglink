//
//  MobileOTPVirecontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 23/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileOTPVirecontroller: UIViewController {
    @IBOutlet weak var OTPTextField: UITextField!
    @IBAction func SubmitPressed(_ sender: Any) {
        CoreAPI.sharedManaged.verifyMobileOTP(verificationCode: OTPTextField.text!, successResponse: {(response) in
            UserDefaults.standard.set(true, forKey: kTwoFactorAuthentication)
            let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoard") as! DashBoardViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }, faliure: {(error) in
            
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
