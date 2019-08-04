//
//  EmailchangeOTPViewcontroller.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 31/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailchangeOTPViewcontroller : UIViewController {
    @IBAction func CancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var CancelPressed: UIButton!
    @IBOutlet weak var nextOrVerify: UIButton!
    var oldEmailId : String? = nil
    var isOldEmailId : Bool? = nil
    var isnewEmailId : Bool? = nil
    var newEmailId : String? = nil
    @IBAction func VerifyPressed(_ sender: Any) {
         ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying...")
        if (oldEmailId != nil) {
            CoreAPI.sharedManaged.requestOldEmailOTP(otpCode: TokenTextField.text!, successResponse: {(response) in
                let data : [String : Any] = response as! [String : Any]
                
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: (data["message"] as! String))
                let newEmail = kNewEmailChange.replacingOccurrences(of: knewEmail, with: self.newEmailId!)
                let VerificationAttributedText = NSMutableAttributedString(string: newEmail)
                
                let Verificationrange : NSRange = NSRange(location: kNewEmailLenght.count, length: self.newEmailId!.count)
                VerificationAttributedText.addAttributes([NSAttributedStringKey.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: NSRange(location: 0, length: newEmail.count))
                VerificationAttributedText.addAttributes([NSAttributedStringKey.font : UIFont(name: "SFProDisplay-Regular", size: 18.0)!], range: Verificationrange)
                self.VerificationLabel.attributedText! = VerificationAttributedText
                self.nextOrVerify.setTitle("VERIFY", for: .normal)
                self.CancelPressed.isHidden = true
                self.oldEmailId = nil
                self.TokenTextField.text! = ""
            }, faliure: {(error) in
                 ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else if(oldEmailId == nil) {
            CoreAPI.sharedManaged.requestNewEmailOTP(otpCode: TokenTextField.text!, successResponse: {(response) in
                let data : [String : Any] = response as! [String : Any]
                
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: (data["message"] as! String))
                CoreAPI.sharedManaged.requestLogout(successResponse: {(response) in
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }, faliure: {(error) in
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
                })
//                let storyboard = UIStoryboard.init(name: "DashBoard", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "FinalLoginViewController") as! FinalLoginViewController
//                self.navigationController?.pushViewController(vc, animated: true)
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        }
       
        
    }
    @IBOutlet weak var TokenTextField: FloatingLabel!
    @IBOutlet weak var VerificationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        TokenTextField.setUpLabel(WithText: "Token")
        VerificationLabel.text! = kOldEmailVerificationText
        
        let newEmail = kNewEmailChange.replacingOccurrences(of: knewEmail, with: oldEmailId!)
        let VerificationAttributedText = NSMutableAttributedString(string: newEmail)
        
        let Verificationrange : NSRange = NSRange(location: kNewEmailLenght.count, length: oldEmailId!.count)
        VerificationAttributedText.addAttributes([NSAttributedStringKey.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: NSRange(location: 0, length: newEmail.count))
        VerificationAttributedText.addAttributes([NSAttributedStringKey.font : UIFont(name: "SFProDisplay-Regular", size: 18.0)!], range: Verificationrange)
        VerificationLabel.attributedText! = VerificationAttributedText
    }
    
    
    

}
