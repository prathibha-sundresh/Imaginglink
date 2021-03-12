//
//  EventInviteFriendsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/2/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit

class EventInviteFriendsViewController: BaseHamburgerViewController {
	@IBOutlet weak var inviteButton: UIButton!
	@IBOutlet weak var checkButton: UIButton!
	@IBOutlet weak var userFriendsTv: UITableView!
	var selectedIndexFriends = [Int]()
	var userFriends = [[String: Any]]()
	var groupId = ""
	var eventId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Invite friends")
		userFriendsTv.tableFooterView = UIView(frame: CGRect.zero)
		updateTableViewUI()
		getUserFriends()
        // Do any additional setup after loading the view.
    }
    
	func getUserFriends() {
		
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.getUserFriends(successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			self.userFriends = dic["data"] as? [[String : Any]] ?? []
			self.userFriendsTv.reloadData()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func inviteButton(_ sender: UIButton) {
		let results = selectedIndexFriends.map { (id) -> String in
			return userFriends[id]["user_id"] as? String ?? ""
		}
		let friendsIds = results.joined(separator: ",")

		let dic = ["group_id": groupId, "event_id": eventId, "invite_all":checkButton.isSelected, "friend_id": friendsIds] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.sendEventInvitation(parameterDict: dic) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let alert = UIAlertController(title: "Imaginglink", message: "Invitation sent successfully.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
				self.backAction()
			}))
			self.present(alert, animated: true, completion: nil)
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}

	}
    
	@IBAction func cancelButton(_ sender: UIButton) {
		checkButton.isSelected = true
		checkUnCheckButton(checkButton)
	}
	
	@IBAction func checkUnCheckButton(_ sender: UIButton) {
		if !checkButton.isSelected {
			checkButton.isSelected = true
			for (id, _) in userFriends.enumerated() {
				selectedIndexFriends.append(id)
			}
		}
		else{
			checkButton.isSelected = false
			selectedIndexFriends = []
			
		}
		updateTableViewUI()
	}
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	func updateTableViewUI() {
		inviteButton.isEnabled = selectedIndexFriends.count > 0 ? true : false
		inviteButton.alpha = selectedIndexFriends.count > 0 ? 1.0 : 0.5
		userFriendsTv.reloadData()
	}
}

extension EventInviteFriendsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriendsListTvCellID", for: indexPath) as! UserFriendsListTVCell
		cell.setUI(dict: userFriends[indexPath.row])
		if selectedIndexFriends.contains(indexPath.row) {
			cell.accessoryType = .checkmark
		}
		else{
			cell.accessoryType = .none
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userFriends.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		if selectedIndexFriends.contains(indexPath.row) {
//			if let index = selectedIndexFriends.firstIndex(of: indexPath.row){
//				selectedIndexFriends.remove(at: index)
//			}
//		}
//		else{
//			selectedIndexFriends.append(indexPath.row)
//		}
//		if selectedIndexFriends.count != userFriends.count {
//			checkButton.isSelected = false
//		}
//		else {
//			checkButton.isSelected = true
//		}
		selectedIndexFriends.removeAll()
		selectedIndexFriends.append(indexPath.row)
		updateTableViewUI()
	}
}
