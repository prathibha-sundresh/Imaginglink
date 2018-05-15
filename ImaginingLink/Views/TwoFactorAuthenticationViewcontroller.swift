//
//  TwoFactorAuthenticationViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 04/06/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class TwoFactorAuthenticationViewcontroller: UIViewController {
    @IBOutlet weak var EnableNow: UISwitch!
    
    @IBAction func EnableNowSelected(_ sender: UISwitch) {
        EnableLater.isOn = !EnableNow.isOn
        CoreAPI.sharedManaged.getPublicUserPresentation(successResponse: {(response) in
            
        }, faliure: {(error) in
            
        })
        let storyboard: UIStoryboard = UIStoryboard(name: "Verification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MobileVerification") as! MobileVerificationsViewcontroller
        //        vc.EmailId = (self.EmailTextField.text)!
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    @IBAction func EnableLaterSelected(_ sender: UISwitch) {
        EnableNow.isOn = !EnableLater.isOn
        
        
    }
    @IBOutlet weak var EnableLater: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        EnableLater.isOn = false
        EnableNow.isOn = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
