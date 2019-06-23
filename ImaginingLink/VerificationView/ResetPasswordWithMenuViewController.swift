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
    
    @IBOutlet weak var passwordValidator: UILabel!
    @IBOutlet weak var newPasswordTextField: FloatingLabel!
    @IBOutlet weak var currentPasswordTextField: FloatingLabel!
    @IBAction func CancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if currentPasswordTextField.text?.count == 0{
            ILUtility.showAlert(title: "Imaginglink", message: "please enter current password", controller: self)
        }
        else if (newPasswordTextField.text?.count == 0 || !ILUtility.isValidPassword(newPasswordTextField.text!)){
            passwordValidator.textColor = UIColor.red
        }
        else if confirmNewPasswordTextField.text == newPasswordTextField.text {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Changing..")
            let requestValues = ["current_password" : currentPasswordTextField.text!,"new_password" : newPasswordTextField.text!, "confirm_new_password" : confirmNewPasswordTextField.text!] as [String:Any]
            CoreAPI.sharedManaged.requestResetPassword(params: requestValues, successResponse: {(response) in
                let dictValue = response as! [String:Any]
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictValue["message"] as! String)
                self.navigationController?.popViewController(animated: true)
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else {
            ILUtility.showAlert(title: "Imaginglink", message: "New password and confirm password should be same", controller: self)
        }
    }
    @IBOutlet weak var confirmNewPasswordTextField: FloatingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        
        newPasswordTextField.setUpLabel(WithText: "New password")
        confirmNewPasswordTextField.setUpLabel(WithText: "confirm Password")
        currentPasswordTextField.setUpLabel(WithText: "current Password")
        newPasswordTextField.setRightPaddingPoints(30)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func textDidChange(_ textField: UITextField){
        if textField == newPasswordTextField{
            if !ILUtility.isValidPassword(newPasswordTextField.text!){
                passwordValidator.textColor = UIColor.red
            }
            else{
                passwordValidator.textColor = UIColor.black
            }
        }
    }
}

