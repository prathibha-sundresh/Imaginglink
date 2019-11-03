//
//  EmailchangeOTPViewcontroller.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 31/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailchangeOTPViewcontroller : BaseHamburgerViewController {
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
                CoreAPI.sharedManaged.logOut()
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        }
       
        
    }
    @IBOutlet weak var TokenTextField: FloatingLabel!
    @IBOutlet weak var VerificationLabel: UILabel!
    @IBOutlet weak var supportTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change E-mail Address"
        TokenTextField.setUpLabel(WithText: "Code")
        VerificationLabel.text! = kOldEmailVerificationText
        
        let newEmail = kNewEmailChange.replacingOccurrences(of: knewEmail, with: oldEmailId!)
        let VerificationAttributedText = NSMutableAttributedString(string: newEmail)
        
        let Verificationrange : NSRange = NSRange(location: kNewEmailLenght.count, length: oldEmailId!.count)
        VerificationAttributedText.addAttributes([NSAttributedStringKey.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: NSRange(location: 0, length: newEmail.count))
        VerificationAttributedText.addAttributes([NSAttributedStringKey.font : UIFont(name: "SFProDisplay-Regular", size: 18.0)!], range: Verificationrange)
        VerificationLabel.attributedText! = VerificationAttributedText
        
        let str = NSString(string: "If you do not have access to this E-mail, contact support@imaginglink.com for reset.")
        let attributedString = NSMutableAttributedString(string: str as String)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 17.0 / 255.0, green: 148.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0), range: str.range(of: "support@imaginglink.com"))
        supportTextView.attributedText = attributedString
    }
    
    
    

}
