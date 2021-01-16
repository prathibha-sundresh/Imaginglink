//
//  AllMembersViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/22/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class AllMembersViewController: UIViewController {

	@IBOutlet weak var myFriendsCollectionView: UICollectionView!
	@IBOutlet weak var searchTF: UITextField!
	@IBOutlet weak var searchView: UIView!
	@IBOutlet weak var myFriendsCollectionViewH: NSLayoutConstraint!
	var myFriendsArray = [[String: Any]]()
	var filteredArray = [[String: Any]]()
	var groupId = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		searchView.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		getGroupMembers()
		myFriendsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		// Do any additional setup after loading the view.
	}
	
	func getGroupMembers() {
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getGroupMembers(groupId: groupId, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				let results = array.map { (dict) -> [String : Any] in
					var tmpDict = dict
					let fullName = "\(dict["first_name"] as? String ?? "") \(dict["last_name"] as? String ?? "")"
					tmpDict["fullName"] = fullName
					return tmpDict
				}
				let approvedFiltered = results.filter { (dict) -> Bool in
					return dict["status"] as? String ?? "" == "APPROVED"
				}
				self.myFriendsArray = approvedFiltered
				self.filteredArray = approvedFiltered
				self.changeScrollDirection()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func textDidChange(_ textfield: UITextField) {
		var isSearched = false
		let searchText = textfield.text ?? ""
		if searchText.count >= 3 && searchText != "" {
			isSearched = true
			filteredArray = myFriendsArray.filter { (dict) -> Bool in
				let fullName = dict["fullName"] as? String ?? ""
				return fullName.range(of: searchText, options: .caseInsensitive) != nil
			}
		}
		else {
			filteredArray = myFriendsArray
			isSearched = true
		}
		if isSearched {
			changeScrollDirection()
		}
	}
	
	func changeScrollDirection() {
		if let flowLayout = myFriendsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			if filteredArray.count <= 1 {
				flowLayout.scrollDirection = .horizontal
				myFriendsCollectionViewH.constant = 210
			}
			else {
				flowLayout.scrollDirection = .vertical
				myFriendsCollectionViewH.constant = self.view.frame.size.height - 60
			}
		}
		myFriendsCollectionView.reloadData()
	}
	
	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	*/
	
	@objc func addButtonAction(_ sender: UIButton) {
		let dict = filteredArray[sender.tag]
		//let fullName = dict["fullName"] as? String ?? ""
		let alert = UIAlertController(title: "Imaginglink", message: "Are you sure you want to send friend request ?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			ILUtility.showProgressIndicator(controller: self)
			SocialConnectAPI.sharedManaged.makeAddORCancelORRejectORApproveORUnFriendRequest(friendID: dict["user_id"] as? String ?? "", urlStr: kAddFriend, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				self.getGroupMembers()
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	func leaveFromGroup(index: Int) {
	
		func leaveGroup() {
			ILUtility.showProgressIndicator(controller: self)
			GroupsAPI.sharedManaged.leaveMemberFromGroupRequest(parameterDict: ["group_id": groupId]) { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				self.getGroupMembers()
			} faliure: { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		if let groupMembers = filteredArray[index]["groups"] as? [[String: Any]], groupMembers.count > 1 {
			leaveGroup()
		}
		else {
			let alert = UIAlertController(title: "Imaginglink", message: "Are you sure want leave from group ?", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
				leaveGroup()
			}))
			alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		
	}
	
	func removeFromGroup(index: Int) {
		
		let dict = ["group_id": groupId, "status": "UNFOLLOW"]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.updateUserGroupStatus(requestDict: dict,successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getGroupMembers()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func removeAsGroupAdminOrMakeAsGroupAdmin(index: Int, isAdmin: String) {
		if isAdmin == "0" {
			if let groupMembers = filteredArray[index]["groups"] as? [[String: Any]], groupMembers.count < 2 {
				ILUtility.showAlert(message: "you can remove as admin only when you have more than 2 members in group", controller: self)
				return
			}
		}
		ILUtility.showProgressIndicator(controller: self)
		let dict = filteredArray[index]
		let memberId = dict["user_id"] as? String ?? ""
		let requestDict = ["group_id": self.groupId,"member_id": memberId,"is_admin": isAdmin]
		GroupsAPI.sharedManaged.changeGroupMemberPrivilegeRequest(parameterDict: requestDict) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getGroupMembers()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@objc func settingButtonAction(_ sender: UIButton) {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let leaveFromGroupAction = UIAlertAction(title: "Leave from group", style: .default, handler: { (action) -> Void in
			self.leaveFromGroup(index: sender.tag)
		})
		let removeAsGroupAdminAction = UIAlertAction(title: "Remove as group admin", style: .default, handler: { (action) -> Void in
			self.removeAsGroupAdminOrMakeAsGroupAdmin(index: sender.tag, isAdmin: "0")
		})
		let removeFromGroupAction = UIAlertAction(title: "Remove from group", style: .default, handler: { (action) -> Void in
			self.removeFromGroup(index: sender.tag)
		})
		
		let makeAsAdminAction = UIAlertAction(title: "Make as admin", style: .default, handler: { (action) -> Void in
			self.removeAsGroupAdminOrMakeAsGroupAdmin(index: sender.tag, isAdmin: "1")
		})
		
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
		
		leaveFromGroupAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		removeAsGroupAdminAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		removeFromGroupAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		makeAsAdminAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		
		let tmpDict = filteredArray[sender.tag]
		let memberUserID = tmpDict["user_id"] as? String ?? ""
		let loginUserID = UserDefaults.standard.value(forKey: kLoggedInUserId) as? String ?? ""
		var isAdminStr = ""
		if let isAdmin = tmpDict["is_admin"] as? String {
			isAdminStr = isAdmin
		}
		if let isAdmin = tmpDict["is_admin"] as? Int {
			isAdminStr = "\(isAdmin)"
		}
		if let isAdmin = tmpDict["is_admin"] as? Bool {
			isAdminStr = isAdmin ? "1":"0"
		}
		if isAdminStr == "1" {
			if loginUserID == memberUserID {
				actionsheet.addAction(leaveFromGroupAction)
			}
			else {
				actionsheet.addAction(removeAsGroupAdminAction)
				actionsheet.addAction(removeFromGroupAction)
			}
		}
		else {
			if loginUserID == memberUserID {
				actionsheet.addAction(leaveFromGroupAction)
			}
			else {
				actionsheet.addAction(removeFromGroupAction)
				actionsheet.addAction(makeAsAdminAction)
			}
		}
		
		self.present(actionsheet, animated: true, completion: nil)
	}
}

extension AllMembersViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendsCollectionViewCellID", for: indexPath) as! MyFriendsCollectionViewCell
		cell.setUI(dict:  filteredArray[indexPath.item])
		cell.friendsLabel.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		cell.unFriendsButton.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
		cell.addFriendButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
		cell.unFriendsButton.tag = indexPath.item
		cell.addFriendButton.tag = indexPath.item
		let tmpDict = filteredArray[indexPath.item]
		
		let memberUserID = tmpDict["user_id"] as? String ?? ""
		let loginUserID = UserDefaults.standard.value(forKey: kLoggedInUserId) as? String ?? ""
		
		if let is_friend = tmpDict["is_friend"] as? String, (is_friend == "NO" && loginUserID != memberUserID) {
			cell.addFriendButton.isHidden = false
			cell.friendsLabel.isHidden = true
		}
		else {
			cell.addFriendButton.isHidden = true
			cell.friendsLabel.isHidden = false
		}
		
		var isAdminStr = ""
		if let isAdmin = tmpDict["is_admin"] as? String {
			isAdminStr = isAdmin
		}
		if let isAdmin = tmpDict["is_admin"] as? Int {
			isAdminStr = "\(isAdmin)"
		}
		if let isAdmin = tmpDict["is_admin"] as? Bool {
			isAdminStr = isAdmin ? "1":"0"
		}
		cell.unFriendsButton.isHidden = false
		if loginUserID != memberUserID && isAdminStr == "0" {
			cell.unFriendsButton.isHidden = true
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.frame.size.width / 2 - 5, height: 195)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}
