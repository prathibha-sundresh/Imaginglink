//
//  resetPasswordViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/24/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import UIKit
class ResetPasswordWithMenuViewController: BaseHamburgerViewController{
    
    @IBOutlet weak var newPasswordTextField: FloatingLabel!
    @IBOutlet weak var currentPasswordTextField: FloatingLabel!
    @IBAction func CancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Changing..")
        if confirmNewPasswordTextField.text == newPasswordTextField.text {
            let requestValues = ["current_password" : currentPasswordTextField.text!,"new_password" : newPasswordTextField.text!, "confirm_new_password" : confirmNewPasswordTextField.text!] as [String:Any]
            CoreAPI.sharedManaged.requestResetPassword(params: requestValues, successResponse: {(response) in
                let dictValue = response as! [String:Any]
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictValue["message"] as! String)
                self.navigationController?.popViewController(animated: true)
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else {
            let alertContoller = UIAlertController(title: "Alert", message: "New password and confirm password should be same", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertContoller.addAction(alertAction)
            self.view.addSubview(alertContoller.view)
        }
    }
    @IBOutlet weak var confirmNewPasswordTextField: FloatingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        
        newPasswordTextField.setUpLabel(WithText: "New password")
        confirmNewPasswordTextField.setUpLabel(WithText: "confirm Password")
        currentPasswordTextField.setUpLabel(WithText: "current Password")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

