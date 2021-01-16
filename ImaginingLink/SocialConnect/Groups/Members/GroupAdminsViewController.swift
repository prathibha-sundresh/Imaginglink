//
//  GroupAdminsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/22/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class GroupAdminsViewController: UIViewController {

	@IBOutlet weak var myFriendsCollectionView: UICollectionView!
	@IBOutlet weak var myFriendsCollectionViewH: NSLayoutConstraint!
	var adminsArray = [[String: Any]]()
	var groupId = ""
	override func viewDidLoad() {
		super.viewDidLoad()
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
				let adminFilter = results.filter { (dict) -> Bool in
					var isAdminStr = ""
					if let isAdmin = dict["is_admin"] as? String {
						isAdminStr = isAdmin
					}
					if let isAdmin = dict["is_admin"] as? Int {
						isAdminStr = "\(isAdmin)"
					}
					if let isAdmin = dict["is_admin"] as? Bool {
						isAdminStr = isAdmin ? "1":"0"
					}
					return (isAdminStr == "1") ? true: false
				}
				self.adminsArray = adminFilter
				self.changeScrollDirection()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func changeScrollDirection() {
		if let flowLayout = myFriendsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			if adminsArray.count <= 1 {
				flowLayout.scrollDirection = .horizontal
				myFriendsCollectionViewH.constant = 210
			}
			else {
				flowLayout.scrollDirection = .vertical
				myFriendsCollectionViewH.constant = self.view.frame.size.height - 15
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
	
	@objc func settingButtonAction(_ sender: UIButton) {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let removeAsGroupAdminAction = UIAlertAction(title: "Remove as group admin", style: .default, handler: { (action) -> Void in
			if let groupMembers = self.adminsArray[sender.tag]["groups"] as? [[String: Any]], groupMembers.count < 3 {
				ILUtility.showAlert(message: "You can remove as admin only when you have more than 2 members in group", controller: self)
				return
			}
			ILUtility.showProgressIndicator(controller: self)
			let dict = self.adminsArray[sender.tag]
			let memberId = dict["user_id"] as? String ?? ""
			let requestDict = ["group_id": self.groupId,"member_id": memberId,"is_admin": "0"]
			GroupsAPI.sharedManaged.changeGroupMemberPrivilegeRequest(parameterDict: requestDict) { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				self.getGroupMembers()
			} faliure: { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		})
		
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
		removeAsGroupAdminAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(removeAsGroupAdminAction)
		self.present(actionsheet, animated: true, completion: nil)
	}
}

extension GroupAdminsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendsCollectionViewCellID", for: indexPath) as! MyFriendsCollectionViewCell
		cell.setUI(dict:  adminsArray[indexPath.item])
		cell.friendsLabel.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		cell.unFriendsButton.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
		cell.unFriendsButton.tag = indexPath.item
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return adminsArray.count
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
