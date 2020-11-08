//
//  PortFolioProfileViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/28/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class PortFolioProfileViewController: UIViewController {
	@IBOutlet weak var titleTF: UITextField!
	@IBOutlet weak var currentRankTF: UITextField!
	@IBOutlet weak var degreeTF: UITextField!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var borderView: UIView!
	var titleDict = [String: Any]()
	var currentPositionDict = [String: Any]()
	var educationDict = [String: Any]()
	@IBOutlet weak var titleEditButton: UIButton!
	@IBOutlet weak var currentRankEditButton: UIButton!
	@IBOutlet weak var degreeEditButton: UIButton!
	@IBOutlet weak var saveButtonH: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
		titleTF.setRightPaddingPoints(30)
		currentRankTF.setRightPaddingPoints(30)
		degreeTF.setRightPaddingPoints(30)
		borderView.layer.borderColor = UIColor(red:0.89, green:0.92, blue:0.93, alpha:1.0).cgColor
		titleTF.isUserInteractionEnabled = false
		currentRankTF.isUserInteractionEnabled = false
		degreeTF.isUserInteractionEnabled = false
		getUserDetails()
		getPortFolioTitle()
		getPortFolioCurrentPosition()
		getPortFolioBasicEducation()
		saveButtonH.constant = 0
        // Do any additional setup after loading the view.
    }
    
	func getUserDetails() {
		ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.getUserDetails(successResponse: { (response) in
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any]{
				self.profileImage.sd_setImage(with: URL(string: dict1["profile_photo"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
				self.emailLabel.text = UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as? String ?? ""
				self.nameLabel.text = UserDefaults.standard.value(forKey: kUserName) as? String ?? ""
				ILUtility.hideProgressIndicator(controller: self)
            }
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
	
	func getPortFolioTitle() {
        
		PortFolioAPI.sharedManaged.getPortFolioBasicDetails(type: kTitleType, successResponse: { (response) in
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any]{
				
				if let tmpDict = dict1["current"] as? [String: Any] {
					self.titleDict = tmpDict
				}
				self.setUI()
            }
        }) { (error) in
            
        }
    }
	
	func getPortFolioCurrentPosition() {
        
		PortFolioAPI.sharedManaged.getPortFolioBasicDetails(type: kCurrentPositionType, successResponse: { (response) in
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any]{
				if let tmpDict = dict1["current_position"] as? [String: Any] {
					self.currentPositionDict = tmpDict
				}
				self.setUI()
            }
        }) { (error) in
            
        }
    }
	
	func getPortFolioBasicEducation() {
        
		PortFolioAPI.sharedManaged.getPortFolioBasicDetails(type: kBasicEducationType, successResponse: { (response) in
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any]{
				if let tmpDict = dict1["basic_education"] as? [String: Any] {
					self.educationDict = tmpDict
				}
				self.setUI()
            }
        }) { (error) in
            
        }
    }
	
	func setUI(){
		titleTF.text = titleDict["data"] as? String ?? ""
		currentRankTF.text = currentPositionDict["data"] as? String ?? ""
		degreeTF.text = educationDict["data"] as? String ?? ""
	}
	
	@IBAction func titleEditAction(_ sender: UIButton) {
		titleTF.isUserInteractionEnabled = true
		titleEditButton.isHidden = true
		saveButtonH.constant = 36
	}
	
	@IBAction func currentPositionEditAction(_ sender: UIButton) {
		currentRankTF.isUserInteractionEnabled = true
		currentRankEditButton.isHidden = true
		saveButtonH.constant = 36
	}
	
	@IBAction func basicEducationEditAction(_ sender: UIButton) {
		degreeTF.isUserInteractionEnabled = true
		degreeEditButton.isHidden = true
		saveButtonH.constant = 36
	}
	
	@IBAction func saveORCancelAction(_ sender: UIButton) {
		titleEditButton.isHidden = false
		currentRankEditButton.isHidden = false
		degreeEditButton.isHidden = false
		titleTF.isUserInteractionEnabled = false
		currentRankTF.isUserInteractionEnabled = false
		degreeTF.isUserInteractionEnabled = false
		saveButtonH.constant = 0
		if sender.tag == 1000 {
			if titleTF.text! != "" && titleDict["data"] as? String ?? "" != titleTF.text! {
				let requestValues = ["type" : kTitleType, "post_data": titleTF.text!] as [String:Any]
				PortFolioAPI.sharedManaged.addPortFolioDetails(requestDict: requestValues, successResponse: { (response) in
					
				}, faliure: { (error) in
					
				})
			}
			
			if currentRankTF.text! != "" && currentPositionDict["data"] as? String ?? "" != currentRankTF.text! {
				let requestValues1 = ["type" : kCurrentPositionType, "post_data": currentRankTF.text!] as [String:Any]
				PortFolioAPI.sharedManaged.addPortFolioDetails(requestDict: requestValues1, successResponse: { (response) in
					
				}, faliure: { (error) in
					
				})
			}
			
			if degreeTF.text! != "" && educationDict["data"] as? String ?? "" != degreeTF.text! {
				let requestValues2 = ["type" : kBasicEducationType, "post_data": degreeTF.text!] as [String:Any]
				PortFolioAPI.sharedManaged.addPortFolioDetails(requestDict: requestValues2, successResponse: { (response) in
					
				}, faliure: { (error) in
					
				})
			}
		}
		else {
			setUI()
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
