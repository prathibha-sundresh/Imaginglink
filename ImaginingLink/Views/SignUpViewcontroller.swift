//
//  SignUpViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/27/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class SignUpViewcontroller: UIViewController,  UITextFieldDelegate, UserTypeDelegate, TapOnLabelDelegate {
    func selectedUserType(userType: String, indexRow: Int) {
        UserTypeTextField.text = userType
        let dic = userTypeResponse![indexRow]
        userTypeId = dic["id"] as! String
    }
    
    @IBAction func UserTypeClickButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = self.userTypeArray
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var SignInLabel: SignInLabel!
    @IBOutlet weak var DisaplyUserTypeLabel: UILabel!
    
    @IBOutlet weak var LastNameTextfield: UITextField!
    
    @IBAction func UserTypeSelectionPressed(_ sender: Any) {
        
    }
    @IBAction func SignUpAction(_ sender: Any) {
        submit()
    }
    @IBAction func IAgreeAction(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
        if sender.isSelected {
            CheckoutBoxClicked.setImage(#imageLiteral(resourceName: "ClickedCheckBox"), for: UIControlState.normal)
        } else {
            CheckoutBoxClicked.setImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControlState.normal)
        }
        
        
    }
    @IBOutlet weak var CheckoutBoxClicked: UIButton!
    @IBOutlet weak var UserTypeTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextfield: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var userTypeArray : [String] = [""]
    var userTypeId : String = ""
    var userTypeResponse : [[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserType()
        SignInLabel.tapDelegate = self
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tapForSignIn() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchUserType() {
        CoreAPI.sharedManaged.requestUserType(successResponse: {(response) in
           
            let responseData = (response as! String).convertToDictionary()
            if let data : [[String:Any]] = responseData!["data"] as? [[String:Any]] {
                self.userTypeResponse = data
                for value in data {
                    self.userTypeArray.append(value["profession"] as! String)
                    self.UserTypeTextField.text = self.userTypeArray[0]
                }
            }
        }, faliure: {(failure) in
            
        })
        
    }
    
    func submit() -> Void {
        if ConfirmPasswordTextfield.text == PasswordTextField.text && EmailTextField.text?.count != 0 && UserTypeTextField.text?.count != 0 {
             ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "SigningUp....")
            CoreAPI.sharedManaged.signUpWithEmailId(firstName: firstnameTextField.text!, lastNAme: LastNameTextfield.text!, email: EmailTextField.text!, password: ConfirmPasswordTextfield.text!, userType: userTypeId, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                let status = dictResponse["status"] as! String
                if status == "success" {
                    UserDefaults.standard.set(false, forKey: kTwoFactorAuthentication)
                    UserDefaults.standard.setValue(self.EmailTextField.text, forKey: kAuthenticatedEmailId)

                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "EmailSuccessViewController") as! EmailSuccessViewController
                    vc.ScreenName = kSignUpScreen
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Some Error While Signing Up....")
            })
        }
    }

}
extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
