//
//  UpdateTimelineStatusVC.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 6/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

class UpdateTimelineStatusVC: UIViewController {
	
	@IBOutlet weak var statusTextView: SZTextView!
	@IBOutlet weak var publicButton: UIButton!
	@IBOutlet weak var postButton: UIButton!
	var dataDict: [String: Any] = [:]
	var isUpdateStatus = false
	var isFrom = ""
	var groupID = ""
	var eventId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

		enableDisablePostButton(isBool: false)
		publicButton.layer.borderWidth = 1.0
		publicButton.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		publicButton.layer.cornerRadius = 15.0
		publicButton.clipsToBounds = true
		
		statusTextView.placeholder = "Type something you want to share"
		statusTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		statusTextView.placeholderTextColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00)
		statusTextView.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
		setUI()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func selectVisibilityDropdown(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: nil)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PopUpVCID" {
            let vc = segue.destination as! CustomPopUpViewController
			vc.selectedRowTitles = [publicButton.titleLabel?.text ?? ""]
			vc.selectionType = .Single
            vc.titleArray = ["Public", "Only Me"]
            vc.callBack = { (titles) in
				if self.publicButton.title(for: .normal) != titles[0] && self.statusTextView.text != "" {
					self.enableDisablePostButton(isBool: true)
				}
				self.publicButton.setTitle(titles[0], for: .normal)
            }
        }
    }
    
	@IBAction func postButton(_ sender: UIButton) {
		
		if isUpdateStatus {
			let timeline_id = dataDict["_id"] as? String ?? ""
			let detailsDict = dataDict["details"] as? [String : Any] ?? [:]
			let post_id = detailsDict["message_id"] as? String ?? ""
			let visibility = (publicButton.titleLabel!.text == "Public") ? "public" : "only_me"
			var requestDict = ["timeline_id": timeline_id,"post_id": post_id,"status_message" : statusTextView.text!, "post_type": "status", "visibility": visibility] as [String : Any]
			if isFrom == "GroupDiscussions" {
				requestDict["group_id"] = groupID
			}
			else if isFrom == "GroupEvents" {
				requestDict["group_id"] = groupID
				requestDict["event_id"] = eventId
			}
			ILUtility.showProgressIndicator(controller: self)
			SocialConnectAPI.sharedManaged.updatePost(requestDict: requestDict, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		else {
			ILUtility.showProgressIndicator(controller: self)
			let visibility = (publicButton.titleLabel!.text == "Public") ? "public" : "only_me"
			var requestDict = ["message" : statusTextView.text!, "message_type": "status", "visibility": visibility] as [String : Any]
			if isFrom == "GroupDiscussions" {
				requestDict["group_id"] = groupID
			}
			else if isFrom == "GroupEvents" {
				requestDict["group_id"] = groupID
				requestDict["event_id"] = eventId
			}
			SocialConnectAPI.sharedManaged.createStatusPost(requestDict: requestDict, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	func enableDisablePostButton(isBool: Bool) {
		postButton.isEnabled = isBool
		postButton.alpha = isBool ? 1.0 : 0.6
	}
	
	func setUI(){
		isUpdateStatus = dataDict["isUpdateMode"] as? Bool ?? false
		let detailsDict = dataDict["details"] as? [String : Any] ?? [:]
		statusTextView.text = detailsDict["message"] as? String ?? ""
		var visibility = dataDict["visibility"] as? String ?? "public"
		if visibility == "only_me" {
			visibility = "Only Me"
		}
		else {
			visibility = "Public"
		}
		self.publicButton.setTitle(visibility, for: .normal)
	}
}

extension UpdateTimelineStatusVC: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		if textView == statusTextView{
			if textView.text == "Type something you want to share" || textView.text == "" {
				enableDisablePostButton(isBool: false)
			}
			else {
				enableDisablePostButton(isBool: true)
			}
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currentString: NSString = statusTextView.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
		return newString.length <= 1000
	}
}

