//
//  GroupsListViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/8/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class GroupsListTvCell: UITableViewCell {
	@IBOutlet weak var groupName: UILabel!
	@IBOutlet weak var createdTime: UILabel!
	@IBOutlet weak var groupImageView: UIImageView!
	@IBOutlet weak var borderView: UIView!
	
	func setUI(dict: [String: Any]) {
		
		borderView.layer.borderColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00).cgColor
		groupName.text = (dict["group_name"] as? String ?? "").capitalized
		createdTime.text = dict["created_at"] as? String ?? ""
		groupImageView.sd_setImage(with: URL(string: dict["group_logo"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
		groupImageView.layer.borderColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00).cgColor
	}
}

class GroupsListViewController: BaseHamburgerViewController {
	@IBOutlet weak var groupsListTableView: UITableView!
	var userGroupsArray: [[String: Any]] = []
	var selectedGroupDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Groups")
		groupsListTableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		getUserGroups()
	}
	
	@IBAction func createGroup(_ sender: UIButton) {
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}
	
	func getUserGroups() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getUserGroups(successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				self.userGroupsArray = array
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
		
		if segue.identifier == "GroupListDetailViewControllerVCID" {
			let vc = segue.destination as! GroupListDetailViewController
			vc.selectedGroupDict = selectedGroupDict
			vc.groupListDetailsDict = sender as! [String: Any]
		}
    }

}

extension GroupsListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsListTvCellID", for: indexPath) as! GroupsListTvCell
		cell.setUI(dict: userGroupsArray[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userGroupsArray.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedGroupDict = userGroupsArray[indexPath.row]
		let groupID = selectedGroupDict["social_connect_group_id"] as? String ?? ""
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getGroupsIdDetails(groupId: groupID) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			let tmpDict = dic["data"] as? [String : Any] ?? [:]
			self.navigationController?.isNavigationBarHidden = true
			self.performSegue(withIdentifier: "GroupListDetailViewControllerVCID", sender: tmpDict)
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
}
