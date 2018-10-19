//
//  TwoFactorAuthenticationViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 04/06/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class TwoFactorAuthenticationViewcontroller: UIViewController {
    
    @IBAction func EnableNowSelected(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Verification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MobileVerification") as! MobileVerificationsViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
       
    }

    @IBAction func EnableLaterSelected(_ sender: Any) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Disabling..")
        CoreAPI.sharedManaged.DisableTwoFactorAuthentication(successResponse: {(response) in
            let storyboard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ILTabViewController") as! ILTabViewController
            vc.selectedIndex = 2
            self.navigationController?.present(vc, animated: true, completion: nil)
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
       
        
    }
    @IBOutlet weak var EnableLater: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
