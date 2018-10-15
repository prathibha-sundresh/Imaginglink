//
//  ResetPasswordViewContoller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 01/08/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class ResetPasswordViewContoller: UIViewController {
    @IBOutlet weak var ConfirmPasswordTF: UITextField!
    @IBOutlet weak var NewPasswordTextFiels: UITextField!
    var otpValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func SavePressed(_ sender: Any) {
        if ConfirmPasswordTF.text == NewPasswordTextFiels.text {
            let requestValues = ["email" : UserDefaults.standard.value(forKey: kAuthenticatedEmailId)!,"otp_code" : otpValue, "new_password" : NewPasswordTextFiels.text!, "confirm_new_password" : ConfirmPasswordTF.text!] as [String:Any]
            CoreAPI.sharedManaged.requestResetPassword(params: requestValues, successResponse: {(response) in
                let dictValue = response as! [String:Any]
                if dictValue["status"] as! String == "success" {
                    let alertContoller = UIAlertController(title: "Alert", message: dictValue["data"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
                    self.performSegue(withIdentifier: "SignInVC", sender: self)
                })
                alertContoller.addAction(alertAction)
                self.view.addSubview(alertContoller.view)
                }
            }, faliure: {(error) in
                
            })
        } else {
            let alertContoller = UIAlertController(title: "Alert", message: "New password and confirm password should be same", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertContoller.addAction(alertAction)
            self.view.addSubview(alertContoller.view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInVC" {
            let viewcontroller  : SignInViewController = segue.destination as! SignInViewController
        }
    }
}
