//
//  MobileVerificationsViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 18/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileVerificationsViewcontroller: UIViewController {
    @IBOutlet weak var PasswordTextFields: UITextField!
    @IBOutlet weak var MobileNumberTextFiels: UITextField!
    @IBAction func VerifyMobileNumberAction(_ sender: Any) {
        
 
        
        CoreAPI.sharedManaged.VerifyPhonenumber(phoneNumber: MobileNumberTextFiels.text!, countryCode: PasswordTextFields.text!, successResponse: {(response) in

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
