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
	@IBOutlet weak var postedByLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var borderView: UIView!
	//start_date,end_date
	func setUI(dict: [String: Any]) {
		eventImage.sd_setImage(with: URL(string: dict["photo"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
		eventNameLabel.text = dict["event_name"] as? String ?? ""
		locationLabel.text = dict["location"] as? String ?? ""
		goingButton.setTitle(dict["user_rsvp_status"] as? String ?? "", for: .normal)
		goingButton.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
	}
}

class GroupEventListViewController: UIViewController {
	var groupId = ""
	@IBOutlet weak var groupsListTableView: UITableView!
	var userGroupsEventsArray: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = true
		getUserGroupEventList()
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
				self.userGroupsEventsArray = array
				self.groupsListTableView.reloadData()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "CreateGroupEventSegue" {
			let vc = segue.destination as! CreateGroupEventViewController
			vc.groupId = groupId
		}
    }
    
	@IBAction func createEventAction(_ sender: UIButton) {
		self.navigationController?.navigationBar.isHidden = false
		self.performSegue(withIdentifier: "CreateGroupEventSegue", sender: nil)
	}
}

extension GroupEventListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userGroupsEventsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GroupEventListViewTvCellID", for: indexPath) as! GroupEventListViewTvCell
		cell.setUI(dict: userGroupsEventsArray[indexPath.row])
		return cell
	}
	
	
}
