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
    
    @IBOutlet weak var passwordToolTipImage: UIImageView!
    @IBOutlet weak var confirmTextFieldY: NSLayoutConstraint!
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
    @IBAction func privacyPolicyPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "PrivacyPolicyID", sender: nil)
    }
    @IBAction func termsAndConditionsPolicyPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "TermsAndConditionsPolicyID", sender: nil)
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
        PasswordTextField.setRightPaddingPoints(30)
        showHiddedToolTipMessageAndImage(isBool: true)
    }
    
    func setUpTextFields() {
        
        firstnameTextField.setUpLabel(WithText: "First name *")
        firstnameTextField.delegate = self
        
        LastNameTextfield.setUpLabel(WithText: "Last name *")
        LastNameTextfield.delegate = self
        
        ConfirmPasswordTextfield.setUpLabel(WithText: "Confirm password *")
        ConfirmPasswordTextfield.delegate = self
        
        PasswordTextField.setUpLabel(WithText: "Create password *")
        PasswordTextField.delegate = self
        
        EmailTextField.setUpLabel(WithText: "Email *")
        EmailTextField.delegate = self
        //EmailTextField.text = "psundresh@mailinator.com"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func textDidChange(_ textField: UITextField){
        if textField == PasswordTextField{
            if !ILUtility.isValidPassword(PasswordTextField.text!){
                passwordValidator.textColor = UIColor.red
                showHiddedToolTipMessageAndImage(isBool: false)
            }
            else{
                passwordValidator.textColor = UIColor.black
                showHiddedToolTipMessageAndImage(isBool: true)
            }
        }
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
        self.acceptTextView.delegate = self
        self.acceptTextView.attributedText = attributedString
        
    }
    func showHiddedToolTipMessageAndImage(isBool: Bool){
        passwordValidator.isHidden = isBool
        passwordToolTipImage.isHidden = isBool
        confirmTextFieldY.constant = isBool ? 0: 15
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComingSoon"{
            //Terms And Conditions
            let vc: TermsAndCondtionsAndPrivacyViewController = segue.destination as! TermsAndCondtionsAndPrivacyViewController
            if sender as? String == ""{
                vc.isClickedFrom = "Terms And Conditions"
            }
            else{
                vc.isClickedFrom = "Privacy Policy"
            }
        }
    }
    func submit(){
        if firstnameTextField.text?.count == 0 {
            ILUtility.showAlert(message: "please enter First name", controller: self)
        } else if LastNameTextfield.text?.count == 0 {
            ILUtility.showAlert(message: "please enter Last name", controller: self)
        }
        else if PasswordTextField.text?.count == 0{
            ILUtility.showAlert(message: "please enter new password", controller: self)
        }
        else if ConfirmPasswordTextfield.text?.count == 0{
            ILUtility.showAlert(message: "please enter confirm password", controller: self)
        }
        else if (PasswordTextField.text?.count == 0 || !ILUtility.isValidPassword(PasswordTextField.text!)){
            passwordValidator.textColor = UIColor.red
        }else if PasswordTextField.text != ConfirmPasswordTextfield.text{
            ILUtility.showAlert(message: "New password and confirm password should be same", controller: self)
        }
        else if UserTypeTextField.text?.count == 0 {
            ILUtility.showAlert(message: "please select User Type", controller: self)
        } else if !CheckoutBoxClicked.isSelected {
            ILUtility.showAlert(message: "Please accept Terms and conditions and Privacy Policy", controller: self)
        } 
        else if ConfirmPasswordTextfield.text == PasswordTextField.text && EmailTextField.text?.count != 0 && UserTypeTextField.text?.count != 0 && firstnameTextField.text?.count != 0 && LastNameTextfield.text?.count != 0 && CheckoutBoxClicked.isSelected {
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
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension SignUpViewcontroller: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
        if URL.absoluteString == termsandconditionUrl{
            self.navigationItem.title = "Terms & Condition"
            self.performSegue(withIdentifier: "TermsAndConditionsPolicyID", sender: "Terms & Condition")
        }
        else{
            self.navigationItem.title = "Privacy Policy"
            self.performSegue(withIdentifier: "TermsAndConditionsPolicyID", sender: "Privacy Policy")
        }
        return false
    }
}
