//
//  FinalSubmissionViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/21/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class TextCell1: UITableViewCell {
    @IBOutlet weak var cell1Label: UILabel!
    
    func setUI() {
        let strTnC = NSString(string: "All users of Imaginglink are responsible for maintaining patient confidentiality. In general,all patient-specific information in content used on the site must be de-identified or anonymized before any posting to the site. As an author, you play a critical role in making sure that patient confidentiality is always respected on Imaginglink.")
        let attributedString = NSMutableAttributedString(string: strTnC as String)
        attributedString.addAttribute(.font, value: UIFont(name: "GoogleSans-Medium", size: 12.0)!, range: strTnC.range(of: "de-identified or anonymized"))
        cell1Label.attributedText = attributedString
    }
    
}

@objc protocol FinalSubmissionViewControllerDelegate {
	@objc optional func pushToPresentationScreen()
}

enum CellIdentifiers: String {
    case cell1 = "cell1"
    case cell2 = "cell2"
    case cell3 = "cell3"
    case cell4 = "cell4"
}
class FinalSubmissionViewController: UIViewController {
    @IBOutlet weak var checkMarkFooterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    @IBOutlet weak var checkUncheckButton: UIButton!
	var presentationID: String = ""
	var delegate: FinalSubmissionViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = checkMarkFooterView
        let strTnC = NSString(string: "Please check this box to indicate that (a) you have de-identified or anonymized the content that you are about to upload and, (b) you have read and agree to Imaginglink’s “terms and conditions” and “privacy policy.”")
        let attributedString = NSMutableAttributedString(string: strTnC as String, attributes: [
          .font: UIFont(name: "GoogleSans-Regular", size: 12.0)!,
          .foregroundColor: UIColor(white: 74.0 / 255.0, alpha: 1.0),
          .kern: 0.34
        ])
        attributedString.addAttributes([NSAttributedString.Key.link:NSURL(string: termsandconditionUrl)!,NSAttributedString.Key.foregroundColor : UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0),NSAttributedString.Key.font:UIFont(name: "GoogleSans-Medium", size: 12.0)!], range: strTnC.range(of: "“terms and conditions”"))
        attributedString.addAttributes([NSAttributedString.Key.link:NSURL(string: privacyPolicyUrl)! ,NSAttributedString.Key.foregroundColor : UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0),NSAttributedString.Key.font:UIFont(name: "GoogleSans-Medium", size: 12.0)!], range: strTnC.range(of: "“privacy policy.”"))
        termsAndConditionsTextView.attributedText = attributedString
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
		if !checkUncheckButton.isSelected {
            ILUtility.showAlert(message: "Please accept Terms and conditions and Privacy Policy", controller: self)
        }
		else{
			ILUtility.showProgressIndicator(controller: self)
			CoreAPI.sharedManaged.savePresentation(params: ["presentation_id": presentationID, "is_submit_for_review": 1], successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				
				let alert = UIAlertController(title: "Imaginglink", message: "Presentation submitted for review, We will notify you once editor review complete. Please wait redirecting..", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
					self.dismiss(animated: true) {
						self.delegate?.pushToPresentationScreen?()
					}
                }))
				self.present(alert, animated: true, completion: nil)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkUncheckButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            checkUncheckButton.setBackgroundImage(#imageLiteral(resourceName: "ClickedCheckBox"), for: UIControl.State.normal)
        } else {
            checkUncheckButton.setBackgroundImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControl.State.normal)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
extension FinalSubmissionViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if indexPath.row == 0 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell1.rawValue, for: indexPath) as! TextCell1
            cell1.setUI()
            cell = cell1
        }
        else if indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell2.rawValue, for: indexPath)
        }
        else if indexPath.row == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell3.rawValue, for: indexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell4.rawValue, for: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FinalSubmissionViewController: UITextViewDelegate {
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
