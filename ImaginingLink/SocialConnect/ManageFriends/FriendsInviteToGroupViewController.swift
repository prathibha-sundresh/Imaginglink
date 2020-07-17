//
//  FriendsInviteToGroupViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/9/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class FriendsInviteGroupCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var inviteButton: UIButton!
	@IBOutlet weak var inviteToGroupButton: UIButton!
	
	func setUI(dict : [String: Any]) {
		let image = dict["profile_picture"] as? String ?? ""
		imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
		nameLabel.text = dict["fullName"] as? String ?? ""
		var frame = nameLabel.frame
		frame.size.width = self.frame.size.width
		nameLabel.frame = frame
		var frame1 = emailLabel.frame
		frame1.size.width = self.frame.size.width
		emailLabel.frame = frame1
		emailLabel.text = dict["email"] as? String ?? ""
		self.layer.borderColor = UIColor(red: 0.89, green: 0.95, blue: 0.93, alpha: 1.00).cgColor
	}
}

class FriendsInviteToGroupViewController: UIViewController {
	var searchFriendsArray = [[String: Any]]()
	@IBOutlet weak var searchTF: UITextField!
	@IBOutlet weak var searchView: UIView!
	@IBOutlet weak var searchFriendCollectionView: UICollectionView!
	@IBOutlet weak var searchFriendCollectionViewH: NSLayoutConstraint!
	var filteredArray = [[String: Any]]()
	var selectedGroupDict :[String: Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
		searchView.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		getUserFriends()
        // Do any additional setup after loading the view.
    }
    
	@objc func addInviteToGroup(_ sender: UIButton) {
		
		if let selectedIndex = selectedGroupDict["index"] as? Int {
			let dict = filteredArray[selectedIndex]
			let id = dict["user_id"] as? String ?? ""
			let dict1 = selectedGroupDict["selected_group"] as? [String: Any] ?? [:]
			let group_id = dict1["social_connect_group_id"] as? String ?? ""
			let requestValues = ["friend_id" : id, "social_connect_group_id" : group_id]  as [String:Any]
			ILUtility.showProgressIndicator(controller: self)
			SocialConnectAPI.sharedManaged.makeUserAddMembersInGroupFriendRequest(requestDict: requestValues, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				if let responseStr = response["data"] as? String, responseStr != "" {
					ILUtility.showAlert(message: responseStr, controller: self)
				}
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		
	}
	
	@objc func inviteToGroupButton(_ sender: UIButton) {
		var dict = filteredArray[sender.tag]
		dict["selectedIndex"] = sender.tag
		self.performSegue(withIdentifier: "PopUpVCID", sender: dict)
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
				self.searchFriendsArray = results
				self.filteredArray = results
				self.changeScrollDirection()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func changeScrollDirection() {
		if let flowLayout = searchFriendCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			if filteredArray.count <= 1 {
				flowLayout.scrollDirection = .horizontal
				searchFriendCollectionViewH.constant = 240
			}
			else {
				flowLayout.scrollDirection = .vertical
				searchFriendCollectionViewH.constant = self.view.frame.size.height - 15
			}
		}
		searchFriendCollectionView.reloadData()
	}
	
	@IBAction func textDidChange(_ textfield: UITextField) {
		var isSearched = false
		let searchText = textfield.text ?? ""
		if searchText.count >= 3 && searchText != "" {
			isSearched = true
            filteredArray = searchFriendsArray.filter { (dict) -> Bool in
                let fullName = dict["fullName"] as? String ?? ""
				return fullName.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
		else{
			filteredArray = searchFriendsArray
			isSearched = true
		}
		if isSearched {
			changeScrollDirection()
		}
	}
	
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "PopUpVCID" {
            let vc = segue.destination as! CustomPopUpViewController
			//vc.selectedRowTitles = [publicButton.titleLabel?.text ?? ""]
			vc.selectionType = .Single
			let dict = sender as? [String: Any] ?? [:]
			let tmpArray = dict["available_groups"] as? [[String: Any]] ?? []
			let groupNames = tmpArray.map { (dict) -> String in
				return dict["group_name"] as? String ?? ""
			}
            vc.titleArray = groupNames
            vc.callBack = { (titles) in
				if titles.count > 0 {
					if let index = groupNames.firstIndex(of: titles[0]) {
						self.selectedGroupDict = ["index": dict["selectedIndex"] as? Int ?? 0, "selected_group": tmpArray[index]]
						self.searchFriendCollectionView.reloadData()
					}
				}
            }
        }
    }
    
}

extension FriendsInviteToGroupViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsInviteGroupCollectionViewCellID", for: indexPath) as! FriendsInviteGroupCollectionViewCell
		cell.setUI(dict:  filteredArray[indexPath.item])
		cell.inviteButton.tag = indexPath.item
		cell.inviteToGroupButton.tag = indexPath.item
		cell.inviteToGroupButton.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		if let selectedIndex = selectedGroupDict["index"] as? Int, indexPath.item == selectedIndex {
			let dict = selectedGroupDict["selected_group"] as? [String: Any] ?? [:]
			cell.inviteToGroupButton.setTitle(dict["group_name"] as? String ?? "Select Group", for: .normal)
		}
		else {
			cell.inviteToGroupButton.setTitle("Select Group", for: .normal)
		}
		cell.inviteButton.addTarget(self, action: #selector(addInviteToGroup), for: .touchUpInside)
		cell.inviteToGroupButton.addTarget(self, action: #selector(inviteToGroupButton), for: .touchUpInside)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.frame.size.width / 2 - 5, height: 240)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}
