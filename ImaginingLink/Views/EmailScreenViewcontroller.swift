//
//  EmailScreenViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/28/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailScreenViewcontroller: UIViewController {
    
    @IBOutlet weak var RequestInviteLabel: UILabel!
    @IBOutlet weak var NextButtonPressed: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    let status = dictResponse["status"] as! String
                        if status == "Success" {
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "OTPViewcontroller") as! OTPViewcontroller
                            vc.EmailId = (self.EmailTextField.text)!
                            vc.screenId = kEmailOTP
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                }, faliure: {(error) in
                    
            })
        }
        
    }
}

