//
//  ChangeEmailViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/17/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import UIKit

class ChangeEmailViewController: BaseHamburgerViewController {
    
    
    @IBAction func CancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func changeEmailButtonPressed(_ sender: UIButton) {
        if (currentEmailIdTextField.text == newEmailTextField.text){
            ILUtility.showAlert(message: "Current email and new email should not be same", controller: self)
        }
        else if (newEmailTextField.text?.count == 0 || !ILUtility.isValidEmail(testStr: newEmailTextField.text!)){
            ILUtility.showAlert(message: "Please Enter valid new email Id", controller: self)
        }
        else if (newEmailTextField.text != confirmNewEmailTextField.text){
            ILUtility.showAlert(message: "New email and confirm email should be same", controller: self)
        }
        else{
            ILUtility.showProgressIndicator(controller: self)
            CoreAPI.sharedManaged.requestToUpdateEmail(params: ["current_email" : currentEmailIdTextField.text!, "new_email" : newEmailTextField.text!, "confirm_new_email" : confirmNewEmailTextField.text!], successResponse: {(response) in
                ILUtility.hideProgressIndicator(controller: self)
				let alert = UIAlertController(title: "Imaginglink", message: "A verification code has been sent to your current registered email.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
					let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
					let vc = storyboard.instantiateViewController(withIdentifier: "EmailchangeOTPViewcontroller") as! EmailchangeOTPViewcontroller
					vc.isnewEmailId = false
					vc.isOldEmailId = true
					vc.oldEmailId = self.currentEmailIdTextField.text!
					vc.newEmailId = self.newEmailTextField.text!
					self.navigationController?.pushViewController(vc, animated: true)
				}))
				self.present(alert, animated: true, completion: nil)
            }, faliure: {(error) in
				ILUtility.hideProgressIndicator(controller: self)
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay:error)
            })
        }
    }
    @IBOutlet weak var confirmNewEmailTextField: FloatingLabel!
    @IBOutlet weak var newEmailTextField: FloatingLabel!
    @IBOutlet weak var currentEmailIdTextField: FloatingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        confirmNewEmailTextField.setUpLabel(WithText: "Confirm New Email")
        currentEmailIdTextField.setUpLabel(WithText: "Current Email")
        newEmailTextField.setUpLabel(WithText: "Enter New EMail")
        currentEmailIdTextField.text = "\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)"
        currentEmailIdTextField.isUserInteractionEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
