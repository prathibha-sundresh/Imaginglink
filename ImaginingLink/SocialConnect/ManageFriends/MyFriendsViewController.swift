//
//  MyFriendsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/4/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class MyFriendsCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var friendsLabel: UILabel!
	@IBOutlet weak var unFriendsButton: UIButton!
	@IBOutlet weak var addFriendButton: UIButton!
	
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

class MyFriendsViewController: UIViewController {

	@IBOutlet weak var myFriendsCollectionView: UICollectionView!
	@IBOutlet weak var searchTF: UITextField!
	@IBOutlet weak var searchView: UIView!
	@IBOutlet weak var myFriendsCollectionViewH: NSLayoutConstraint!
	var myFriendsArray = [[String: Any]]()
	var filteredArray = [[String: Any]]()
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
				myFriendsCollectionViewH.constant = self.view.frame.size.height - 15
			}
		}
		myFriendsCollectionView.reloadData()
	}
	
	func filterAction() {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let viewbyAtoZ = UIAlertAction(title: "View by A-Z", style: .default, handler: { (action) -> Void in
			self.sortArrayByName(sortType: ComparisonResult.orderedAscending)
        })
		let viewbyZtoA = UIAlertAction(title: "View by Z-A", style: .default, handler: { (action) -> Void in
			self.sortArrayByName(sortType: ComparisonResult.orderedDescending)
        })
		let newToOld = UIAlertAction(title: "New to Old", style: .default, handler: { (action) -> Void in
			self.sortArrayByDate(sortType: ComparisonResult.orderedAscending)
        })
		let oldToNew = UIAlertAction(title: "Old to New", style: .default, handler: { (action) -> Void in
			self.sortArrayByDate(sortType: ComparisonResult.orderedDescending)
        })
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		viewbyAtoZ.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		viewbyZtoA.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		newToOld.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		oldToNew.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(viewbyAtoZ)
		actionsheet.addAction(viewbyZtoA)
		actionsheet.addAction(newToOld)
		actionsheet.addAction(oldToNew)
		actionsheet.addAction(cancel)
        self.present(actionsheet, animated: true, completion: nil)
	}
	
	func sortArrayByDate(sortType: ComparisonResult) {
		let sortedArray = self.myFriendsArray.sorted { (dict1, dict2) -> Bool in
			let tmpDict1 = dict1["friendship"] as? [String: Any] ?? [:]
			let tmpDict2 = dict2["friendship"] as? [String: Any] ?? [:]
			let dateStr1 = tmpDict1["created_at"] as? String ?? ""
			let dateStr2 = tmpDict2["created_at"] as? String ?? ""
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
			let date1 = dateFormatter.date(from: dateStr1) ?? Date()
			let date2 = dateFormatter.date(from: dateStr2) ?? Date()
			return date1.compare(date2) == sortType
		}
		self.filteredArray = sortedArray
		self.changeScrollDirection()
	}
	
	func sortArrayByName(sortType: ComparisonResult) {
		let orderedAscendingArray = self.myFriendsArray.sorted { (dict1, dict2) -> Bool in
			let name1 = dict1["fullName"] as? String ?? ""
			let name2 = dict2["fullName"] as? String ?? ""
			return name1.localizedCaseInsensitiveCompare(name2) == sortType
		}
		self.filteredArray = orderedAscendingArray
		self.changeScrollDirection()
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	@objc func unFriendsButtonAction(_ sender: UIButton) {
		let dict = filteredArray[sender.tag]
		let fullName = dict["fullName"] as? String ?? ""
		let alert = UIAlertController(title: "Imaginglink", message: "Are you sure you want to unfriend \"\(fullName)\"", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			ILUtility.showProgressIndicator(controller: self)
			SocialConnectAPI.sharedManaged.makeAddORCancelORRejectORApproveORUnFriendRequest(friendID: dict["user_id"] as? String ?? "", urlStr: kUnFriend, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				self.getUserFriends()
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

extension MyFriendsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendsCollectionViewCellID", for: indexPath) as! MyFriendsCollectionViewCell
		cell.setUI(dict:  filteredArray[indexPath.item])
		cell.friendsLabel.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		cell.unFriendsButton.addTarget(self, action: #selector(unFriendsButtonAction), for: .touchUpInside)
		cell.unFriendsButton.tag = indexPath.item
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
