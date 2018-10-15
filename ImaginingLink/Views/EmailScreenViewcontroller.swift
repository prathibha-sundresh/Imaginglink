//
//  EmailScreenViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/28/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailScreenViewcontroller: UIViewController, TapOnLabelDelegate {
    
    @IBOutlet weak var RequestInviteLabel: SignInLabel!
    @IBOutlet weak var NextButtonPressed: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestInviteLabel.tapDelegate = self
    
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
        if EmailTextField?.text?.count != 0 {
            CoreAPI.sharedManaged.RegisterEmail(Email: EmailTextField.text!, successResponse: {(response) in
                let dictResponse = response as! [String:Any]
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "", MessageToDisplay: "" )
                if dictResponse["message"] != nil {
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "OTPViewcontroller") as! OTPViewcontroller
                            vc.EmailId = (self.EmailTextField.text)!
                            vc.screenId = kEmailOTP
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Message", MessageToDisplay: dictResponse["message"] as! String )
                }
                }, faliure: {(error) in
                    
            })
        }
        
    }
}

