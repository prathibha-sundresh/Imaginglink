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
    
    
    @IBOutlet weak var acceptTextView: UITextView!
    @IBAction func UserTypeClickButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = self.userTypeArray
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var SignInLabel: SignInLabel!
    @IBOutlet weak var DisaplyUserTypeLabel: UILabel!
    
    @IBOutlet weak var LastNameTextfield: FloatingLabel!
    
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
    @IBOutlet weak var passwordValidator: UILabel!
    @IBOutlet weak var UserTypeTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextfield: FloatingLabel!
    @IBOutlet weak var PasswordTextField: FloatingLabel!
    @IBOutlet weak var EmailTextField: FloatingLabel!
    @IBOutlet weak var firstnameTextField: FloatingLabel!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var userTypeArray : [String] = [""]
    var userTypeId : String = ""
    var emailId : String = ""
    var userTypeResponse : [[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserType()
        setUpTextFields()
        SignInLabel.tapDelegate = self
        EmailTextField?.text = emailId
        setUpTermsAndCondition()
       
        
    }
    
    func setUpTextFields() {
        
        firstnameTextField.setUpLabel(WithText: "FirstName *")
        firstnameTextField.delegate = self
        
        LastNameTextfield.setUpLabel(WithText: "LastName *")
        LastNameTextfield.delegate = self
        
        ConfirmPasswordTextfield.setUpLabel(WithText: "ConfirmPassword *")
        ConfirmPasswordTextfield.delegate = self
        
        PasswordTextField.setUpLabel(WithText: "Password *")
        PasswordTextField.delegate = self
        
        EmailTextField.setUpLabel(WithText: "Email *")
        EmailTextField.delegate = self
        EmailTextField.text = "psundresh@mailinator.com"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpTermsAndCondition() {
        acceptTextView.isSelectable = true
        acceptTextView.isEditable = false
        acceptTextView.textColor = UIColor.black
        let strTnC : String = "I accept the Terms and conditions & Privacy policy"
        let attributedString = NSMutableAttributedString(string: strTnC)
        let foundRange = NSRange(location: "I accept the ".count, length: "Terms and conditions".count)
        attributedString.addAttributes([NSAttributedStringKey.link:NSURL(string: termsandconditionUrl)!,NSAttributedStringKey.foregroundColor : UIColor(red: 17.0/255.0, green: 148.0/255.0, blue: 246.0/255.0, alpha: 1.0),NSAttributedStringKey.font:UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: foundRange)
        let legaltermsrange = NSRange(location: "I accept the Terms and conditions & ".count, length: "Privacy policy".count)
        attributedString.addAttributes([NSAttributedStringKey.link:NSURL(string: privacyPolicyUrl)! ,NSAttributedStringKey.foregroundColor : UIColor(red: 17.0/255.0, green: 148.0/255.0, blue: 246.0/255.0, alpha: 1.0),NSAttributedStringKey.font:UIFont(name: "SFProDisplay-Regular", size: 14.0)!], range: legaltermsrange)
    
        self.acceptTextView.attributedText = attributedString
        
    }
    
//    @objc func tapOnLabel(tap : UITapGestureRecognizer) {
//         let foundRange = NSRange(location: "I accept the ".count, length: "Terms and conditions".count)
//         let legaltermsrange = NSRange(location: "I accept the Terms and conditions & ".count, length: "Privacy policy".count)
//        if tap.didTapAttributedTextInLabel(label: self.acceptTextView, inRange: foundRange) {
//            print("Tapped targetRange1")
//        } else if tap.didTapAttributedTextInLabel(label: self.acceptTextView, inRange: legaltermsrange) {
//            print("Tapped targetRange2")
//        }
//    }
    
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
        if firstnameTextField.text?.count == 0 {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "please enter FirstName")
        } else if LastNameTextfield.text?.count == 0 {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "please enter LastName")
        } else if (ConfirmPasswordTextfield.text?.count == 0 || !ILUtility.isValidPassword(ConfirmPasswordTextfield.text!)){
            passwordValidator.textColor = UIColor.red
        } else if (PasswordTextField.text?.count == 0 || !ILUtility.isValidPassword(PasswordTextField.text!)){
            passwordValidator.textColor = UIColor.red
           // ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Password must be 8 or more characters and must contain at least one special character")
        } else if UserTypeTextField.text?.count == 0 {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "please select usertype")
        } else if !CheckoutBoxClicked.isSelected {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "please click terms and condition")
        } else if !((EmailTextField.text?.isValidEmail())!) {
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "please enter valid email")
        } else if ConfirmPasswordTextfield.text == PasswordTextField.text && EmailTextField.text?.count != 0 && UserTypeTextField.text?.count != 0 && firstnameTextField.text?.count != 0 && LastNameTextfield.text?.count != 0 && CheckoutBoxClicked.isSelected {
            passwordValidator.textColor = UIColor.black
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
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
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

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x, y:locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
