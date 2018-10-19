//
//  EmailScreenViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/28/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailScreenViewcontroller: UIViewController, TapOnLabelDelegate {
    
    @IBAction func AlreadyHaveOTPPressed(_ sender: Any) {
        if EmailTextField?.text?.count != 0 && (EmailTextField.text?.isValidEmail())!  {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlreadyHaveOTPViewController") as! AlreadyHaveOTPViewController
            vc.EmailId = (self.EmailTextField.text)!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
             ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please Enter valid Email Id")
        }
    }
    @IBOutlet weak var AlreadyHaveOTPPressed: UIButton!
    @IBOutlet weak var AlreadyHaveEmailLabel: UILabel!
    @IBOutlet weak var RequestInviteLabel: SignInLabel!
    @IBOutlet weak var NextButtonPressed: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestInviteLabel.tapDelegate = self
        self.AlreadyHaveEmailLabel.isHidden = true
    
    }
    func tapForSignIn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func RequestOTP(_ sender: Any) {
        self.AlreadyHaveEmailLabel.isHidden = true
        if EmailTextField?.text?.count != 0 {
            if (EmailTextField.text?.isValidEmail())! {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Requesting..")
            CoreAPI.sharedManaged.RegisterEmail(Email: EmailTextField.text!, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "")
                if dictResponse["message"] != nil {
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "OTPViewcontroller") as! OTPViewcontroller
                            vc.EmailId = (self.EmailTextField.text)!
                            vc.screenId = kEmailOTP
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: dictResponse["message"] as! String)
                }
                }, faliure: {(error) in
                    
                    if (error == "Email already Registered") {
                        self.AlreadyHaveEmailLabel.isHidden = false
                    }
            })
            } else {
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please Enter valid Email Id")
            }
        } else {
             ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please Enter Email Id")
        }
        
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

