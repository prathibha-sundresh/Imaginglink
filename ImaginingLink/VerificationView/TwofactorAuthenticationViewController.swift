//
//  TwofactorAuthenticationViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/23/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import UIKit

class TwofactorAuthenticationViewController: BaseHamburgerViewController {
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        CoreAPI.sharedManaged.DisableTwoFactorAuthentication(successResponse: {(response) in
            self.navigationController?.popViewController(animated: true)
        }, faliure: {(error) in
            
        })
        
    }
    @IBAction func enableNowButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Verification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MobileVerification") as! MobileVerificationsViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true ,backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kUserName) as! String)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
