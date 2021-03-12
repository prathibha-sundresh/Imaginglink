//
//  CreateGroupPollViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/15/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit

class GroupPollListViewTvCell: UITableViewCell {
	@IBOutlet weak var pollNameLabel: UILabel!
	@IBOutlet weak var createdDateLabel: UILabel!
	@IBOutlet weak var expiredDateLabel: UILabel!
	@IBOutlet weak var settingButton: UIButton!
	@IBOutlet weak var borderView: UIView!
	
	func setUI(dict: [String: Any]) {
		
		var startDate = ""
		if let dateStr = dict["expiry"] as? String {
			let expiry = dateStr.replacingOccurrences(of: " ", with: "T")
			let df = DateFormatter()
			df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			let date = df.date(from: expiry)
			df.dateFormat = "dd MMM, yyyy"
			startDate = df.string(from: date!)
		}
		let uploadedUser = dict["user_details"] as? [String: Any] ?? [:]
		let userName = "\(uploadedUser["first_name"] as? String ?? "")" + " " + "\(uploadedUser["last_name"] as? String ?? "")"
		if let dateStr = dict["uploaded_at"] as? String {
			let createdTime = dateStr.replacingOccurrences(of: " ", with: "T")
			let df = DateFormatter()
			df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			let date = df.date(from: createdTime)
			df.dateFormat = "MMMM dd"
			let monthStr = df.string(from: date!)
			df.dateFormat = "h:mm a"
			let timeStr = df.string(from: date!)
			createdDateLabel.text = "created on \(monthStr) at \(timeStr) by \(userName)"
		}
		pollNameLabel.text = dict["question"] as? String ?? ""
		expiredDateLabel.text = "Expire on  \(startDate)"
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		let loginUserID = UserDefaults.standard.value(forKey: kLoggedInUserId) as? String ?? ""
		let member_id = dict["user_id"] as? String ?? ""
		settingButton.isHidden = true
		if loginUserID == member_id {
			settingButton.isHidden = false
		}
	}
}

class CreateGroupPollViewController: UIViewController {
	var groupId = ""
	var pollType = ""
	var allPollsArray: [[String: Any]] = []
	var filterPollsArray: [[String: Any]] = []
	@IBOutlet weak var managePollTableView: UITableView!
	@IBOutlet weak var pollTypeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
		getAllManagePolls()
		pollType = "Active polls"
        // Do any additional setup after loading the view.
    }
    
	func getAllManagePolls() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getLoadAllGroupPolls(groupId: groupId, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				let results = array.filter({ (dict) -> Bool in
					return (dict["status"] as? String ?? "") != "DELETED"
				})
				self.allPollsArray = results 
				self.filterPolls(type: self.pollType)
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func createPollButtonAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: "AddPollViewControllerSegue", sender: nil)
	}
	
	func filterPolls(type: String) {
		var filterType = ""
		if type == "Active polls" {
			filterType = "NO"
		}
		else if type == "Past polls" {
			filterType = "YES"
		}
		let filer = allPollsArray.filter { (dict) -> Bool in
			let type = dict["expired"] as? String ?? ""
			return type == filterType ? true: false
		}
		self.filterPollsArray = type != "All" ? filer : allPollsArray
		self.managePollTableView.reloadData()
	}
	
	@IBAction func filterButtonAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: nil)
	}
	
	func deletePoll(by Index: Int) {
		let pollID = filterPollsArray[Index]["_id"] as? String ?? ""
		let dic = ["poll_id": pollID] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.deleteGroupPoll(parameterDict: dic) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getAllManagePolls()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@objc func menuButtonAction(_ sender: UIButton) {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let deletePollAction = UIAlertAction(title: "Delete", style: .default, handler: { (action) -> Void in
			self.deletePoll(by: sender.tag)
		})
		let updatePollAction = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
			self.performSegue(withIdentifier: "AddPollViewControllerSegue", sender: self.filterPollsArray[sender.tag])
		})
		deletePollAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		updatePollAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(updatePollAction)
		actionsheet.addAction(deletePollAction)
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
			
		}))
		self.present(actionsheet, animated: true, completion: nil)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PopUpVCID" {
			let vc = segue.destination as! CustomPopUpViewController
			vc.selectedRowTitles = [pollType]
			vc.selectionType = .Single
			vc.titleArray = ["All","Active polls","Past polls"]
			vc.callBack = { (titles) in
				if titles.count > 0 {
					self.pollType = titles[0]
					self.filterPolls(type: self.pollType)
				}
			}
		}
		else if segue.identifier == "AddPollViewControllerSegue" {
			let vc = segue.destination as! AddPollViewController
			vc.groupId = groupId
			vc.selectedDict = sender as? [String: Any] ?? [:]
			vc.isEditPoll = vc.selectedDict.keys.count > 0 ? true : false
		}
		else if segue.identifier == "PollDetailViewControllerSegue" {
			let vc = segue.destination as! PollDetailViewController
			vc.groupId = groupId
			vc.pollId = sender as? String ?? ""
		}
    }

}

extension CreateGroupPollViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if filterPollsArray.count == 0 {
			let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyPostTableviewCellID", for: indexPath) as! EmptyPostTableviewCell
			return emptyCell
		}
		let pollListViewTvCell = tableView.dequeueReusableCell(withIdentifier: "GroupPollListViewTvCellID", for: indexPath) as! GroupPollListViewTvCell
		pollListViewTvCell.settingButton.tag = indexPath.row
		pollListViewTvCell.setUI(dict: filterPollsArray[indexPath.row])
		pollListViewTvCell.settingButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
		return pollListViewTvCell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if filterPollsArray.count == 0 {
			return 1
		}
		return filterPollsArray.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let isExpired = filterPollsArray[indexPath.row]["expired"] as? String {
			let pollId = filterPollsArray[indexPath.row]["_id"] as? String ?? ""
			if isExpired == "YES" {
				ILUtility.showAlert(title: "Imaginglink",message: "The poll has Expired", controller: self)
			}
			else {
				self.performSegue(withIdentifier: "PollDetailViewControllerSegue", sender: pollId)
			}
		}
	}
}
