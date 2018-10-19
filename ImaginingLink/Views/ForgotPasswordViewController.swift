//
//  ForgotPasswordViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 31/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var ForgotPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func ForgotPasswordSubmitPresses(_ sender: Any) {
        if ForgotPasswordTextField.text?.count != 0 {
            CoreAPI.sharedManaged.requesrForgotPassword(emailId: ForgotPasswordTextField.text!, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                let status = dictResponse["status"] as! String
                if status == "success" {
                      UserDefaults.standard.setValue(self.ForgotPasswordTextField.text!, forKey: kAuthenticatedEmailId)
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                    vc.ScreenName = kForgetPasswordScreen
                    vc.emailId = self.ForgotPasswordTextField.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if status == "Failure" {
                    let alertContoller = UIAlertController(title: "Alert", message: "User not found", preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    self.view.addSubview(alertContoller.view)
                }
            }, faliure: {(error) in
                
            })
        }
    }
}
