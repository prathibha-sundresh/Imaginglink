//
//  GroupEventListViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/26/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class GroupEventListViewTvCell: UITableViewCell {
	@IBOutlet weak var eventImage: UIImageView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var goingButton: UIButton!
	@IBOutlet weak var settingButton: UIButton!
	@IBOutlet weak var postedByLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var borderView: UIView!
	
	func setUI(dict: [String: Any]) {
		var startDate = ""
		var endDate = ""
		if let dateStr = dict["start_date"] as? String {
			let df = DateFormatter()
			df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			let date = df.date(from: dateStr)
			df.dateFormat = "dd/MM/yyyy, h:mm a"
			startDate = df.string(from: date!)
		}
		
		if let dateStr = dict["end_date"] as? String {
			let df = DateFormatter()
			df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			let date = df.date(from: dateStr)
			//df.dateFormat = "EEEE, d MMM, yyyy h:mm a"
			df.dateFormat = "dd/MM/yyyy, h:mm a"
			endDate = df.string(from: date!)
		}
		dateLabel.text = "\(startDate) - \(endDate)"
		eventImage.sd_setImage(with: URL(string: dict["photo"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
		eventNameLabel.text = dict["event_name"] as? String ?? ""
		locationLabel.text = dict["location"] as? String ?? ""
		goingButton.setTitle(dict["user_rsvp_status"] as? String ?? "", for: .normal)
		goingButton.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		postedByLabel.text = "Posted on \(dict["created_at"] as? String ?? "")"
	}
}

class GroupEventListViewController: UIViewController {
	var groupId = ""
	@IBOutlet weak var groupsListTableView: UITableView!
	var filteredEventsArray: [[String: Any]] = []
	var allEventsArray: [[String: Any]] = []
	@IBOutlet weak var eventTypeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = true
		getUserGroupEventList()
		eventTypeButton.layer.borderWidth = 1.0
		eventTypeButton.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		eventTypeButton.layer.cornerRadius = 15.0
		eventTypeButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		
	}
	
	func getUserGroupEventList() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getUserGroupEventsList(groupId: groupId, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				self.allEventsArray = array
				self.getEventsList(type: "Active Events")
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func eventTypeAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["isFrom": "filterEvents"])
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "CreateGroupEventSegue" {
			let vc = segue.destination as! CreateGroupEventViewController
			let senderDict = sender as? [String: Any] ?? [:]
			vc.groupId = groupId
			vc.selectedDict = senderDict["indexDict"] as? [String: Any] ?? [:]
			vc.isUpdateMode = (senderDict["type"] as? String ?? "") == "editMode"
		}
		else if segue.identifier == "PopUpVCID" {
			let dict = sender as? [String: Any] ?? [:]
			let isFromStr = dict["isFrom"] as? String ?? ""
			
			let vc = segue.destination as! CustomPopUpViewController
			vc.selectionType = .Single
			if isFromStr == "filterEvents" {
				vc.titleArray = ["Active Events", "Past Events"]
			}
			else {
				vc.titleArray = ["MAY_BE", "GOING", "NOT_GOING"]
			}
			
			vc.selectedRowTitles = [eventTypeButton.titleLabel?.text ?? ""]
			vc.callBack = { (titles) in
				if titles.count > 0 {
					if isFromStr == "filterEvents" {
						self.eventTypeButton.setTitle(titles[0], for: .normal)
						self.getEventsList(type: titles[0])
					}
					else {
						self.storeEventRVspAPI(index: dict["index"] as! Int, status: titles[0])
					}
				}
			}
		}
		else if segue.identifier == "GroupEventDetailVCID" {
			let dict = sender as? [String: Any] ?? [:]
			let vc : GroupDiscussionViewController = segue.destination as! GroupDiscussionViewController
			vc.isFromTab = "GroupEvents"
			vc.groupId = groupId
			vc.eventId = dict["_id"] as? String ?? ""
			vc.selectedGroupDict = dict
		}
    }
    
	func getEventsList(type: String) {
		var results = [[String: Any]]()
		if type == "Active Events" {
			results = self.allEventsArray.filter { (dict) -> Bool in
				return dict["expiredEvent"] as? Bool ?? false == false
			}
		}
		else {
			results = self.allEventsArray.filter { (dict) -> Bool in
				return dict["expiredEvent"] as? Bool ?? false == true
			}
		}
		self.filteredEventsArray = results
		self.groupsListTableView.reloadData()
	}
	
	func storeEventRVspAPI(index: Int, status: String) {
		ILUtility.showProgressIndicator(controller: self)
		let tmpDict = filteredEventsArray[index]
		let reqestDict = ["event_id": tmpDict["_id"] as? String ?? "", "status": status]
		GroupsAPI.sharedManaged.storeEventRSVP(parameterDict: reqestDict) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getUserGroupEventList()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func deleteGroupEvent(index: Int) {
		ILUtility.showProgressIndicator(controller: self)
		let tmpDict = filteredEventsArray[index]
		GroupsAPI.sharedManaged.deleteGroupEventRSVP(parameterDict: ["event_id": tmpDict["_id"] as? String ?? ""], successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getUserGroupEventList()
		}, faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	@IBAction func createEventAction(_ sender: UIButton) {
		self.navigationController?.navigationBar.isHidden = false
		self.performSegue(withIdentifier: "CreateGroupEventSegue", sender: nil)
	}
	
	@objc func updateRvspStatus(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["isFrom": "updateRvsp", "index": sender.tag])
	}
	
	@objc func settingButton(_ sender: UIButton){
		
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
	
		let editEventAction = UIAlertAction(title: "Edit Event", style: .default, handler: { (action) -> Void in
			self.navigationController?.navigationBar.isHidden = false
			let dict = ["type": "editMode", "indexDict": self.filteredEventsArray[sender.tag]] as [String : Any]
			self.performSegue(withIdentifier: "CreateGroupEventSegue", sender: dict)
		})
		
		let deleteEventAction = UIAlertAction(title: "Delete Event", style: .default, handler: { (action) -> Void in
			self.deleteGroupEvent(index: sender.tag)
		})
		
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
			
		}))
		
		editEventAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		deleteEventAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(editEventAction)
		actionsheet.addAction(deleteEventAction)
		
		self.present(actionsheet, animated: true, completion: nil)
	}
}

extension GroupEventListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if filteredEventsArray.count == 0 {
			return 1
		}
		return filteredEventsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if filteredEventsArray.count == 0 {
			let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyPostTableviewCellID", for: indexPath) as! EmptyPostTableviewCell
			emptyCell.discLabel.text = "Currenty you don’t have any events"
			return emptyCell
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "GroupEventListViewTvCellID", for: indexPath) as! GroupEventListViewTvCell
		cell.setUI(dict: filteredEventsArray[indexPath.row])
		cell.goingButton.tag = indexPath.row
		cell.goingButton.addTarget(self, action: #selector(updateRvspStatus), for: .touchUpInside)
		cell.settingButton.tag = indexPath.row
		cell.settingButton.addTarget(self, action: #selector(settingButton), for: .touchUpInside)
		let selectedDict = filteredEventsArray[indexPath.row]
		let loginUserID = UserDefaults.standard.value(forKey: kLoggedInUserId) as? String ?? ""
		if selectedDict["created_user_id"] as! String == loginUserID {
			cell.settingButton.isHidden = false
		}
		else {
			cell.settingButton.isHidden = true
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let tmpDict = filteredEventsArray[indexPath.row]
		self.performSegue(withIdentifier: "GroupEventDetailVCID", sender: tmpDict)
	}
}
