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
    @IBOutlet weak var enabledOrDisableButton: UIButton!
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        CoreAPI.sharedManaged.DisableTwoFactorAuthentication(successResponse: {(response) in
            self.navigationController?.popViewController(animated: true)
        }, faliure: {(error) in
            
        })
        
    }
    @IBAction func enableNowButtonPressed(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: kTwoFactorAuthentication){
            ILUtility.showProgressIndicator(controller: self)
            CoreAPI.sharedManaged.disable2faToUser(successResponse: {(response) in
                ILUtility.hideProgressIndicator(controller: self)
                UserDefaults.standard.set(false, forKey: kTwoFactorAuthentication)
                let alert  = UIAlertController(title: "ImaginingLink", message: "Two-factor Authentication disabled successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.backAction()
                }))
                self.present(alert, animated: true, completion: nil)
            }, faliure: {(error) in
                ILUtility.hideProgressIndicator(controller: self)
            })
        }
        else{
            let storyboard: UIStoryboard = UIStoryboard(name: "Verification", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MobileVerification") as! MobileVerificationsViewcontroller
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: kTwoFactorAuthentication){
            enabledOrDisableButton.backgroundColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
            enabledOrDisableButton.setTitle("Disable Now", for: .normal)
        }
        else{
            enabledOrDisableButton.backgroundColor = UIColor(red:1.00, green:0.60, blue:0.00, alpha:1.0)
            enabledOrDisableButton.setTitle("Enable Now", for: .normal)
        }
        addSlideMenuButton(showBackButton: true ,backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
