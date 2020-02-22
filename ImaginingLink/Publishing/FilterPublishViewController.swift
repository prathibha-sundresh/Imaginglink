//
//  FilterPublishViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/25/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

@objc protocol FilterPublishViewControllerDelegte {
	@objc func UpdatedFilterResults(result: String)
}

class FilterPublishViewController: BaseHamburgerViewController {
	@IBOutlet weak var sectionsView: UIView!
	@IBOutlet weak var presentationTypeButton: UIButton!
	@IBOutlet weak var sortByButton: UIButton!
	@IBOutlet weak var sectionButton: UIButton!
	@IBOutlet weak var subSectionButton: UIButton!
	@IBOutlet weak var applyButton: UIButton!
	@IBOutlet weak var subSectionTextView: UITextView!
	var sections: [[String: Any]] = []
	var myPresentationsArray: [[String: Any]] = []
	var delegate: FilterPublishViewControllerDelegte?
    var subSections: [String: Any] = [:]
	let publishTypeArray = ["Published Presentations","My Presentation"]
	let sortByArrayForPublishPresentations = ["Recent","Top Viewed","Top Shared","New To Old","Old To New"]
	let sortByArrayForMyPresentations: [[String: Any]] = [[
		"title": "All",
		"value": "ALL"
	],
	[
		"title": "Draft",
		"value": "DRAFT"
	],
	[
		"title": "Editor Modified",
		"value": "REVIEW_EDITED"
	],
	[
		"title": "Published",
		"value": "PUBLISHED"
	],
	[
		"title": "Pending Review",
		"value": "REVIEW"
	],
	[
		"title": "Need Modification",
		"value": "NEED MODIFICATION"
	],
	[
		"title": "Rejected",
		"value": "REJECTED"
	],
	[
		"title": "Co-Authored",
		"value": "CO-AUTHORED"
	]]
	var isApplyButtonEnabled = false {
		didSet {
			applyButton.isEnabled = isApplyButtonEnabled
			applyButton.alpha = isApplyButtonEnabled ? 1 : 0.5
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		sectionsView.isHidden = true
		addBorders(presentationTypeButton)
		addBorders(sortByButton)
		addBorders(sectionButton)
		addBorders(subSectionButton)
		getSections()
		isApplyButtonEnabled = false
		
        // Do any additional setup after loading the view.
    }
    
	override func viewWillAppear(_ animated: Bool) {
		self.tabBarController?.tabBar.isHidden = true
		self.navigationController?.isNavigationBarHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.tabBarController?.tabBar.isHidden = false
	}
	
	func addBorders(_ btn: UIButton){
		btn.layer.cornerRadius = 4.0
		btn.clipsToBounds = true
		btn.layer.borderWidth = 1.0
		btn.layer.borderColor = UIColor(red:0.73, green:0.80, blue:0.83, alpha:1.0).cgColor
		btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.view.frame.width - 65, bottom: 0, right: 0)
	}
	
	@IBAction func resetButtonAction(_ sender: UIButton){
		presentationTypeButton.setTitle("", for: .normal)
		sortByButton.setTitle("", for: .normal)
		sectionButton.setTitle("", for: .normal)
		isApplyButtonEnabled = false
	}
	
	@IBAction func applyFilterButtonAction(_ sender: UIButton){
		
		if presentationTypeButton.title(for: .normal) ?? "" == "Published Presentations" {
			let sortby = sortByButton.title(for: .normal) ?? ""
			let section = sectionButton.title(for: .normal) ?? ""
			let subsections = subSectionTextView.text!
			let requestDict = ["sortby": sortby, "section": section, "subsections": subsections]
			ILUtility.showProgressIndicator(controller: self)
			CoreAPI.sharedManaged.filterPublishPresentation(params: requestDict, successResponse: { (response) in
				self.delegate?.UpdatedFilterResults(result: response as! String)
				ILUtility.hideProgressIndicator(controller: self)
				self.backAction()
				
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		else{
			let title = (sortByButton.title(for: .normal) ?? "")
			let arry = sortByArrayForMyPresentations.filter { $0["title"] as? String ?? "" == title }
			var selectedSortString = ""
			if arry.count > 0 {
				selectedSortString = arry[0]["value"] as? String ?? ""
			}
			
			ILUtility.showProgressIndicator(controller: self)
			CoreAPI.sharedManaged.filterUserPresentation(params: [:], successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				let value = response as! String
				let dic : [String : Any] = value.convertToDictionary()!
				if let tmpDict : [String:Any] = dic["data"] as? [String : Any]{
					self.myPresentationsArray = tmpDict["presentations"] as? [[String : Any]] ?? []
					self.sendFilterResultsToMyPresentationsVC(array: self.myPresentationsArray, selectedSortString: selectedSortString)
				}
				
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	func sendFilterResultsToMyPresentationsVC(array: [[String: Any]], selectedSortString: String) {
		var filteredArray = [[String: Any]]()
		if selectedSortString == "ALL" {
			filteredArray = myPresentationsArray
		}
		else {
			filteredArray = self.myPresentationsArray.filter({ (dict) -> Bool in
				return (dict["status"] as? String ?? "" == selectedSortString)
			})
		}
		self.performSegue(withIdentifier: "MyPresentationsViewControllerID", sender: filteredArray)
	}
	
	@IBAction func dropDownButtonAction(_ sender: UIButton){
		
		let pType = self.presentationTypeButton.title(for: .normal) ?? ""
		let sortType = self.sortByButton.title(for: .normal) ?? ""
		let sectionType = self.sectionButton.title(for: .normal) ?? ""
		switch sender.tag {
		case 101:
			if pType == "" {
				return
			}
		case 102:
			if pType == "" || sortType == "" {
				return
			}
		case 103:
			if pType == "" || sortType == "" || sectionType == "" {
				return
			}
		default:
			break
		}
		self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
	}
	
	@IBAction func backButtonAction(_ sender: UIButton){
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func menuButtonAction(_ sender: UIButton){
		onSlideMenuButtonPressed(sender)
	}
    
	func getSections() {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.getSectionsAndSubSections(successResponse: { (response) in
            
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any] {
                self.sections = dict1["sections"] as? [[String: Any]] ?? []
                self.subSections = dict1["sub_sections"] as? [String: Any] ?? [:]
            }
            ILUtility.hideProgressIndicator(controller: self)
        }) { (errorMessage) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PopUpVCID" {
            
            let vc = segue.destination as! CustomPopUpViewController
			vc.selectionType = .Single
			var selectedTitleStr: [String] = []
			var tempArray: [String] = []
			if sender as? Int == 100 {
				selectedTitleStr = [presentationTypeButton.title(for: .normal) ?? ""]
				tempArray = publishTypeArray
			}
			else if sender as? Int == 101 {
				selectedTitleStr = [sortByButton.title(for: .normal) ?? ""]
				if presentationTypeButton.title(for: .normal) == "Published Presentations" {
					tempArray =  sortByArrayForPublishPresentations
				}
				else {
					let titleArray = sortByArrayForMyPresentations.compactMap { (dict) -> String in
						return dict["title"] as? String ?? ""
					}
					tempArray =  titleArray
				}
			}
			else if sender as? Int == 102 {
				selectedTitleStr = [sectionButton.title(for: .normal) ?? ""]
				tempArray = sections.map({ (dict) -> String in
					return dict["title"] as? String ?? ""
				})
			}
			else if sender as? Int == 103 {
				vc.selectionType = .Multiple
				let sectionStr = sectionButton.title(for: .normal) ?? ""
				let splitStringArray = (subSectionTextView.text!).split(separator: ",").map({ (substring) in
					return String(substring)
				})
				selectedTitleStr = splitStringArray
				var subSectionsTmpArray = [[String: Any]]()
				if sectionStr != "" {
					if let tmpArray = subSections[sectionStr] as? [[String: Any]]{
						subSectionsTmpArray = tmpArray
					}
				}
				tempArray = subSectionsTmpArray.map({ (dict) -> String in
					return dict["title"] as? String ?? ""
				})
			}
			
			vc.selectedRowTitles = selectedTitleStr
			vc.titleArray = tempArray
            
            vc.callBack = { (titles) in
                if sender as? Int == 100 {
					if (self.presentationTypeButton.title(for: .normal) ?? "") != titles[0]{
						self.sortByButton.setTitle("", for: .normal)
					}
					self.presentationTypeButton.setTitle(titles[0], for: .normal)
					if titles[0] == "Published Presentations" {
						self.sectionsView.isHidden = false
					}
					else {
						self.sectionsView.isHidden = true
					}
				}
				else if sender as? Int == 101 {
					self.sortByButton.setTitle(titles[0], for: .normal)
				}
				else if sender as? Int == 102 {
					self.sectionButton.setTitle(titles[0], for: .normal)
				}
				else if sender as? Int == 103 {
					self.subSectionTextView.text = titles.joined(separator: ",")
				}
				
				let pType = self.presentationTypeButton.title(for: .normal) ?? ""
				let sortType = self.sortByButton.title(for: .normal) ?? ""
				let sectionType = self.sectionButton.title(for: .normal) ?? ""
				let subSectionType = self.subSectionTextView.text!
				
				if pType == "Published Presentations" {
					
					if sortType == "" || sectionType == "" || subSectionType == ""{
						self.isApplyButtonEnabled = false
					}
					else{
						self.isApplyButtonEnabled = true
					}
				}
				else {
					if pType == "" || sortType == "" {
						self.isApplyButtonEnabled = false
					}
					else{
						self.isApplyButtonEnabled = true
					}
				}
            }
        }
		else if segue.identifier == "MyPresentationsViewControllerID"{
			let vc = segue.destination as! MyPresentationsViewController
			vc.dataArray = sender as? [[String: Any]] ?? []
			vc.sections = sections
			vc.subSections = subSections
		}
    }
    

}
