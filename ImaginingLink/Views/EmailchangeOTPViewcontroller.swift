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
         ILUtility.showProgressIndicator(controller: self)
        if (oldEmailId != nil) {
            CoreAPI.sharedManaged.requestOldEmailOTP(otpCode: TokenTextField.text!, successResponse: {(response) in
				ILUtility.hideProgressIndicator(controller: self)
				ILUtility.showAlert(title: "Imaginglink", message: "A verification code has been sent to your new email successfully.", controller: self)
				
                let newEmail = kNewEmailChange.replacingOccurrences(of: knewEmail, with: self.newEmailId!)
                let VerificationAttributedText = NSMutableAttributedString(string: newEmail)
                let Verificationrange : NSRange = NSRange(location: kNewEmailLength.count, length: self.newEmailId!.count)
                VerificationAttributedText.addAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: NSRange(location: 0, length: newEmail.count))
                VerificationAttributedText.addAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 18.0)!], range: Verificationrange)
                self.VerificationLabel.attributedText! = VerificationAttributedText
                self.nextOrVerify.setTitle("VERIFY", for: .normal)
                self.CancelPressed.isHidden = true
                self.oldEmailId = nil
                self.TokenTextField.text! = ""
            }, faliure: {(error) in
				 ILUtility.hideProgressIndicator(controller: self)
                 ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else if(oldEmailId == nil) {
			ILUtility.showProgressIndicator(controller: self)
            CoreAPI.sharedManaged.requestNewEmailOTP(otpCode: TokenTextField.text!, successResponse: {(response) in
				ILUtility.hideProgressIndicator(controller: self)
				let alert = UIAlertController(title: "Imaginglink", message: "Your registered Email with Imaginglink has been changed successfully to \(self.newEmailId!).Please login again.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
					CoreAPI.sharedManaged.logOut()
				}))
				self.present(alert, animated: true, completion: nil)
                
            }, faliure: {(error) in
				ILUtility.hideProgressIndicator(controller: self)
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        }
    }
    @IBOutlet weak var TokenTextField: FloatingLabel!
    @IBOutlet weak var VerificationLabel: UILabel!
    @IBOutlet weak var supportTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Change Email Address"
        TokenTextField.setUpLabel(WithText: "Code")
        VerificationLabel.text! = kOldEmailVerificationText
        let newEmail = kNewEmailChange.replacingOccurrences(of: knewEmail, with: oldEmailId!)
        let VerificationAttributedText = NSMutableAttributedString(string: newEmail)
        
        let Verificationrange : NSRange = NSRange(location: kNewEmailLength.count, length: oldEmailId!.count)
        VerificationAttributedText.addAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: NSRange(location: 0, length: newEmail.count))
        VerificationAttributedText.addAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: 18.0)!], range: Verificationrange)
        VerificationLabel.attributedText! = VerificationAttributedText
        
        let str = NSString(string: "If you do not have access to this Email, contact support@imaginglink.com for reset.")
        let attributedString = NSMutableAttributedString(string: str as String)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 17.0 / 255.0, green: 148.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0), range: str.range(of: "support@imaginglink.com"))
        supportTextView.attributedText = attributedString
    }
}
