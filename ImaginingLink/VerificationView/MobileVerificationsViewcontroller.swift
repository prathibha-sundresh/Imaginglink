//
//  MobileVerificationsViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 18/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileVerificationsViewcontroller: UIViewController {

    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBAction func VerifyMobileNumberAction(_ sender: Any) {
        
 
        
        CoreAPI.sharedManaged.VerifyPhonenumber(phoneNumber: "9902019295", countryCode: "91", successResponse: {(response) in
            
             UserDefaults.standard.set(true, forKey: kTwoFactorAuthentication)

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
