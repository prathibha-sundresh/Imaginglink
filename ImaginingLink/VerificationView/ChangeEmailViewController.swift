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
         ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "changing..")
        CoreAPI.sharedManaged.requestToUpdateEmail(params: ["current_email" : currentEmailIdTextField.text!, "new_email" : newEmailTextField.text!, "confirm_new_email" : confirmNewEmailTextField.text!], successResponse: {(response) in
            
            let data : [String : Any] = response as! [String : Any]
            
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: (data["message"] as! String))
            
            let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EmailchangeOTPViewcontroller") as! EmailchangeOTPViewcontroller
            vc.isnewEmailId = false
            vc.isOldEmailId = true
            vc.oldEmailId = self.currentEmailIdTextField.text!
            vc.newEmailId = self.newEmailTextField.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay:error)
        })
        
    }
    @IBOutlet weak var confirmNewEmailTextField: FloatingLabel!
    @IBOutlet weak var newEmailTextField: FloatingLabel!
    @IBOutlet weak var currentEmailIdTextField: FloatingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        confirmNewEmailTextField.setUpLabel(WithText: "Confirm New E-mail")
        currentEmailIdTextField.setUpLabel(WithText: "Current E-mail")
        newEmailTextField.setUpLabel(WithText: "new E-Mail")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
