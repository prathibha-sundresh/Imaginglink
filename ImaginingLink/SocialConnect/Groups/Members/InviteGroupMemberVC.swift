//
//  InviteGroupMemberVC.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/23/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class InviteGroupMemberVC: UIViewController {

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
		getUserFriends()
		myFriendsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		// Do any additional setup after loading the view.
	}
	
	func getUserFriends() {
		
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.getUserFriends(successResponse: { (response) in
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
				self.myFriendsArray = results
				self.filteredArray = results
				self.changeScrollDirection()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@objc func addInviteToGroup(_ sender: UIButton) {
		
		let dict = filteredArray[sender.tag]
		let id = dict["user_id"] as? String ?? ""
		let requestValues = ["friend_id" : id, "social_connect_group_id" : groupId]  as [String:Any]
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.makeUserAddMembersInGroupFriendRequest(requestDict: requestValues, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let responseStr = response["data"] as? String, responseStr != "" {
				ILUtility.showAlert(message: responseStr, controller: self)
			}
			self.getUserFriends()
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
	
}

extension InviteGroupMemberVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendsCollectionViewCellID", for: indexPath) as! MyFriendsCollectionViewCell
		cell.setUI(dict:  filteredArray[indexPath.item])
		cell.addFriendButton.addTarget(self, action: #selector(addInviteToGroup), for: .touchUpInside)
		cell.addFriendButton.tag = indexPath.item
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
