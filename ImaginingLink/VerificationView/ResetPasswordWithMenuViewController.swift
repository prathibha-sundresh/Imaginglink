//
//  resetPasswordViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/24/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import UIKit
class ResetPasswordWithMenuViewController: BaseHamburgerViewController,UITextFieldDelegate{
    
    @IBOutlet weak var passwordValidator: UILabel!
    @IBOutlet weak var newPasswordTextField: FloatingLabel!
    @IBOutlet weak var currentPasswordTextField: FloatingLabel!
    @IBOutlet weak var passwordToolTipImage: UIImageView!
    @IBOutlet weak var confirmTextFieldY: NSLayoutConstraint!
    @IBAction func CancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if currentPasswordTextField.text?.count == 0{
            ILUtility.showAlert(message: "please enter current password", controller: self)
        }
        else if newPasswordTextField.text?.count == 0{
            ILUtility.showAlert(message: "please enter new password", controller: self)
        }
        else if confirmNewPasswordTextField.text?.count == 0{
            ILUtility.showAlert(message: "please enter confirm password", controller: self)
        }
        else if newPasswordTextField.text! != confirmNewPasswordTextField.text!{
            ILUtility.showAlert(message: "New password and confirm password should be same", controller: self)
        }
        else if (newPasswordTextField.text?.count == 0 || !ILUtility.isValidPassword(newPasswordTextField.text!)){
            passwordValidator.textColor = UIColor.red
            showHiddedToolTipMessageAndImage(isBool: false)
        }
        else if confirmNewPasswordTextField.text == newPasswordTextField.text {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Changing..")
            let requestValues = ["current_password" : currentPasswordTextField.text!,"new_password" : newPasswordTextField.text!, "confirm_new_password" : confirmNewPasswordTextField.text!] as [String:Any]
            CoreAPI.sharedManaged.requestResetPassword(params: requestValues, successResponse: {(response) in
                let dictValue = response as! [String:Any]
                let alert = UIAlertController(title: "Imaginglink", message: "Your password is changed successfully. Please login again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    CoreAPI.sharedManaged.logOut()
                }))
                self.present(alert, animated: true, completion: nil)
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        }
    }
    @IBOutlet weak var confirmNewPasswordTextField: FloatingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        
        newPasswordTextField.setUpLabel(WithText: "New password")
        confirmNewPasswordTextField.setUpLabel(WithText: "Confirm new Password")
        currentPasswordTextField.setUpLabel(WithText: "Current Password")
        newPasswordTextField.setRightPaddingPoints(30)
        showHiddedToolTipMessageAndImage(isBool: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func textDidChange(_ textField: UITextField){
        if textField == newPasswordTextField{
            if !ILUtility.isValidPassword(newPasswordTextField.text!){
                passwordValidator.textColor = UIColor.red
                showHiddedToolTipMessageAndImage(isBool: false)
            }
            else{
                passwordValidator.textColor = UIColor.black
                showHiddedToolTipMessageAndImage(isBool: true)
            }
        }
    }
    func showHiddedToolTipMessageAndImage(isBool: Bool){
        passwordValidator.isHidden = isBool
        passwordToolTipImage.isHidden = isBool
        confirmTextFieldY.constant = isBool ? -15 : 20
    }
}

