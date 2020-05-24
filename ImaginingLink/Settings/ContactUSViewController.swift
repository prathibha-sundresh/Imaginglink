//
//  ContactUSViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 5/21/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class ContactUSViewController: BaseHamburgerViewController {
	@IBOutlet weak var contactView: UIView!
	@IBOutlet weak var addressView: UIView!
	@IBOutlet weak var shareView: UIView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var nameTF: UITextField!
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var mobileTF: UITextField!
	@IBOutlet weak var msgTF: UITextField!
	@IBOutlet weak var countryCodeButton: UIButton!
	var listOfData = [[String:Any]]()
	var countryCode : [String] = []
    var countryName : [String] = []
	var selectedCountryCode = ""
    var selectedCountryName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
		sendButton.isEnabled = false
		sendButton.alpha = 0.5
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Contact Us")
		addBorders(view: contactView)
		addBorders(view: addressView)
		addBorders(view: shareView)
		CoreAPI.sharedManaged.getCountryList(successResponse: {(response) in
            let responseData = (response as! String).convertToDictionary()
            if let data : [[String:Any]] = responseData!["data"] as? [[String:Any]] {
                self.listOfData = data
                self.parseDataToFetchPhoneNumber(data: data)
            }
        }, faliure: {(error) in

        })
        // Do any additional setup after loading the view.
    }
	
    func parseDataToFetchPhoneNumber(data: [[String:Any]]) {
        for value in data {
            countryCode.append(value["code"] as! String)
            countryName.append(value["name"] as! String)
        }
    }
	
	func addBorders(view: UIView) {
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		view.layer.cornerRadius = 4.0
		view.clipsToBounds = true
	}
	
	@IBAction func textDidChange(_ textfield: UITextField){
		if nameTF.text != "" && emailTF.text != "" && mobileTF.text != "" && msgTF.text != "" {
			sendButton.isEnabled = true
			sendButton.alpha = 1.0
		}
		else {
			sendButton.isEnabled = false
			sendButton.alpha = 0.5
		}
	}
	
	@IBAction func sendButtonAction(_ sender: UIButton){
		
		if emailTF.text?.isValidEmail() == false  {
			ILUtility.showAlert(message: "Please Enter valid E-mail", controller: self)
			return
		}
		ILUtility.showProgressIndicator(controller: self)
		let requestDetails = ["name" : nameTF.text!, "email":  emailTF.text!,"phone": (countryCodeButton.titleLabel?.text)! + mobileTF.text!,"message": msgTF.text! ]  as [String:Any]
		CoreAPI.sharedManaged.sendContactUsDetails(requestDict: requestDetails, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let alert = UIAlertController(title: "Imaginglink", message: "We will get back to you as soon as possible.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
				self.backAction()
			}))
			self.present(alert, animated: true, completion: nil)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
		
	}
	
	@IBAction func chooseCountryButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = countryName
        VC.filteredArray = countryName
        VC.selectedIndexValue = selectedCountryName
        self.present(VC, animated: true, completion: nil)
    }
	
	@IBAction func openMailButtonAction(_ sender: UIButton){
		if let url = URL(string: "mailto:support@imaginglink.com") {
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func calButtonAction(_ sender: UIButton){
		if let url = URL(string: "tel://" + "+1-844-464-5465") {
			UIApplication.shared.open(url)
		}
	}
	
	@IBAction func shareButtonAction(_ sender: UIButton){
		if sender.tag == 100 {
			if let url = URL(string: "https://www.facebook.com/imaginglink/") {
				UIApplication.shared.open(url)
			}
		}
		else if sender.tag == 101 {
			if let url = URL(string: "https://twitter.com/imaginglink?lang=en") {
				UIApplication.shared.open(url)
			}
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

}
extension ContactUSViewController: UserTypeDelegate {
	func selectedUserType(userType: String, indexRow: Int) {
        let filterArray = listOfData.filter { (dict) -> Bool in
            return dict["name"] as? String ?? "" == userType
        }
        if filterArray.count > 0{
            selectedCountryCode = filterArray[0]["m_code"] as? String ?? ""
            selectedCountryName = filterArray[0]["name"] as? String ?? ""
			countryCodeButton.setTitle(selectedCountryCode, for: .normal)
        }
    }
}
