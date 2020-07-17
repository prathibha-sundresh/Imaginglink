//
//  FriendsSearchViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/7/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class FriendsSearchViewController: UIViewController {
	var searchFriendsArray = [[String: Any]]()
	@IBOutlet weak var searchTF: UITextField!
	@IBOutlet weak var searchView: UIView!
	@IBOutlet weak var searchFriendCollectionView: UICollectionView!
	@IBOutlet weak var searchFriendCollectionViewH: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
		searchView.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	@objc func addFriendsButtonAction(_ sender: UIButton) {
		let dict = searchFriendsArray[sender.tag]
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.makeAddORCancelORRejectORApproveORUnFriendRequest(friendID: dict["user_id"] as? String ?? "", urlStr: kAddFriend, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			ILUtility.showAlert(message: "Friend request has sent successfully.", controller: self)
			self.searchFriendsArray.remove(at: sender.tag)
			self.changeScrollDirection()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func textDidChange(_ textfield: UITextField) {
		
		let searchText = textfield.text ?? ""
		if searchText.count >= 3 && searchText != "" {
			ILUtility.showProgressIndicator(controller: self)
			SocialConnectAPI.sharedManaged.searchFriendRequest(name: searchTF.text!, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				self.searchFriendsArray.removeAll()
				if let array = response["data"] as? [[String : Any]] {
					let results = array.map { (dict) -> [String : Any] in
						var tmpDict = dict
						let fullName = "\(dict["first_name"] as? String ?? "") \(dict["last_name"] as? String ?? "")"
						tmpDict["fullName"] = fullName
						return tmpDict
					}
					self.searchFriendsArray = results
				}
				self.changeScrollDirection()
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
        }
		else {
			self.searchFriendsArray.removeAll()
			searchFriendCollectionView.reloadData()
		}
	}
	
	func changeScrollDirection() {
		if let flowLayout = searchFriendCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			if searchFriendsArray.count <= 1 {
				flowLayout.scrollDirection = .horizontal
				searchFriendCollectionViewH.constant = 210
			}
			else {
				flowLayout.scrollDirection = .vertical
				searchFriendCollectionViewH.constant = self.view.frame.size.height - 15
			}
		}
		searchFriendCollectionView.reloadData()
	}
	
}

extension FriendsSearchViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendsCollectionViewCellID", for: indexPath) as! MyFriendsCollectionViewCell
		cell.setUI(dict:  searchFriendsArray[indexPath.item])
		cell.addFriendButton.tag = indexPath.item
		cell.addFriendButton.layer.borderColor = UIColor(red: 0.73, green: 0.80, blue: 0.83, alpha: 1.00).cgColor
		cell.addFriendButton.addTarget(self, action: #selector(addFriendsButtonAction), for: .touchUpInside)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return searchFriendsArray.count
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
