//
//  SignUpViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/27/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class SignUpViewcontroller: UIViewController,  UITextFieldDelegate, UserTypeDelegate {
    func selectedUserType(userType: String) {
        UserTypeTextField.text = userType
    }
    
    @IBAction func UserTypeClickButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = kUserTypes
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var DisaplyUserTypeLabel: UILabel!
    
    @IBOutlet weak var LastNameTextfield: UITextField!
    
    @IBAction func UserTypeSelectionPressed(_ sender: Any) {
    }
    @IBAction func SignUpAction(_ sender: Any) {
        submit()
    }
    @IBAction func IAgreeAction(_ sender: Any) {
        
    }
    @IBOutlet weak var UserTypeTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextfield: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var userTypeArray : [String] = [""]
    override func viewDidLoad() {
        super.viewDidLoad()

         userTypeArray = kUserTypes
        UserTypeTextField.text = kUserTypes[0]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func submit() -> Void {
        if ConfirmPasswordTextfield.text == PasswordTextField.text && EmailTextField.text?.count != 0 && UserTypeTextField.text?.count != 0 {
            CoreAPI.sharedManaged.signUpWithEmailId(firstName: firstnameTextField.text!, lastNAme: LastNameTextfield.text!, email: EmailTextField.text!, password: ConfirmPasswordTextfield.text!, userType: UserTypeTextField.text!, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                let status = dictResponse["status"] as! String
                if status == "Success" {
                    UserDefaults.standard.setValue(self.EmailTextField.text, forKey: kAuthenticatedEmailId)
//                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "TwoFactorAuthenticationViewcontroller") as!
//                    TwoFactorAuthenticationViewcontroller
//                    self.navigationController?.pushViewController(vc, animated: true)
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    //        vc.EmailId = (self.EmailTextField.text)!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, faliure: {(error) in
                
            })
        }
    }
    
    
    //MARK: UserType list call
    func UserTypeList() {
        
    }
    

}
