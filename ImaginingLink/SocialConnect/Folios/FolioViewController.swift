//
//  FolioViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 07/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol createFolioDelegate {
    func createFolioPressed()
}

class FolioViewController: BaseHamburgerViewController {
    
    @IBOutlet weak var folioTableView :UITableView!
	var likesArray: [Int] = []
	var foliosListArray : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tabBarController?.tabBar.isHidden = true
		folioTableView.tableFooterView = UIView(frame: .zero)
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Folios")
    }
    
	func getUserFolios() {
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.callFolioPresentation(successResponse: {success in
			ILUtility.hideProgressIndicator(controller: self)
			let str : String = success as! String
			let dic : [String : Any] = str.convertToDictionary()!
			//			if let message = dic["message"] as? String, message == kTokenExpire {
			//				ILUtility.showAlertWithCallBack(message: "Token Expired, Please login.", controller: self, success: {
			//					CoreAPI.sharedManaged.logOut()
			//				})
			//			}
			let array : [[String:Any]] = dic["data"] as? [[String : Any]] ?? []
			self.foliosListArray = array
			self.folioTableView.reloadData()
		}, faliure: {error in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		getUserFolios()
    }
    
	@IBAction func createFolioPressed(_ sender: UIButton) {
		performSegue(withIdentifier: "createFolio", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "createFolio" {
			//segue.destination as! CreateFolioViewController
		}
	}
	
	@objc func sharePost(_ sender: UIButton){
		
		let dict = foliosListArray[sender.tag]
		
		let msg = dict["group_name"] as? String ?? ""
		let logo = dict["group_logo"] as? String ?? ""
		
		let activityViewController = UIActivityViewController(activityItems: [msg,logo], applicationActivities: nil)
		
		activityViewController.popoverPresentationController?.sourceView = self.view
		activityViewController.excludedActivityTypes = [.message, .mail, .print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .postToTencentWeibo, .airDrop, .openInIBooks, .markupAsPDF]
		self.present(activityViewController, animated: false, completion: nil)
	}
	
	@objc func favouritesUnFavouritesPost(_ sender: UIButton) {
		let index = sender.tag
		var dict = foliosListArray[index]
		let id = dict["social_connect_folio_id"] as? String ?? ""
		let requestValues = ["group_id" : id] as [String:Any]
		ILUtility.showProgressIndicator(controller: self)
		FoliosAPI.sharedManaged.requestFavouriteUnfavoritePost(parameters:requestValues, successResponse: {(response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let favStatus = dict["is_favourite"] as? String, favStatus == "No" {
				dict["is_favourite"] = "Yes"
				ILUtility.showAlert(title: "Imaginglink",message: "Added to the favourite list", controller: self)
			}
			else {
				dict["is_favourite"] = "No"
				ILUtility.showAlert(title: "Imaginglink",message: "Removed from the favourite list", controller: self)
			}
			self.foliosListArray[index] = dict
			self.folioTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
			
		}, faliure: {(error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	@objc func makeFollowUnFollowGroup(_ sender: UIButton) {
		let index = sender.tag
		var dict = foliosListArray[index]
		let id = dict["social_connect_folio_id"] as? String ?? ""
		var statusStr = ""
		if let isFollowing = dict["is_following"] as? String, isFollowing == "Yes" {
			statusStr = "UNFOLLOW"
		}
		else {
			statusStr = "APPROVED"
		}
		
		ILUtility.showProgressIndicator(controller: self)
		FoliosAPI.sharedManaged.updateUserGroupStatus(groupId: id, status: statusStr, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let isFollowing = dict["is_following"] as? String, isFollowing == "Yes" {
				dict["is_following"] = "No"
			}
			else {
				dict["is_following"] = "Yes"
			}
			self.foliosListArray[index] = dict
			self.folioTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
}

extension FolioViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return foliosListArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	   let cell = tableView.dequeueReusableCell(withIdentifier: "FolioListTableViewCellID", for: indexPath) as! FolioListTableViewCell
		cell.selectedLikes = likesArray
		cell.delegate = self
		cell.likeButton.tag = indexPath.row
		cell.ShareButton.tag = indexPath.row
		cell.commentButton.tag = indexPath.row
		cell.followUnFollowButton.tag = indexPath.row
		cell.setupUI(dic: foliosListArray[indexPath.row])
		cell.ShareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
		cell.commentButton.addTarget(self, action: #selector(favouritesUnFavouritesPost), for: .touchUpInside)
		cell.followUnFollowButton.addTarget(self, action: #selector(makeFollowUnFollowGroup), for: .touchUpInside)
		return cell
	}
	
}

extension FolioViewController: SharedStatusTableViewCellDelegate {
	func getLikedStatus(row: Int) {
		if likesArray.contains(row){
			likesArray.removeAll()
		}
		else {
			likesArray.removeAll()
			likesArray.append(row)
		}
		self.folioTableView.reloadData()
	}
	
	func updateRatingWithIndex(row: Int, rating: Int) {
		ILUtility.showProgressIndicator(controller: self)
		var dict = foliosListArray[row]
		let id = dict["social_connect_folio_id"] as? String ?? ""
		let requestValues = ["group_id" : id, "like_emoji": "\(rating)"] as [String:Any]
		FoliosAPI.sharedManaged.requestForSaveAllPostLikesEmoji(parameters: requestValues, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			
			if let data = response["data"] as? [String:Any]{
				dict["liked_members_count"] = data["liked_members_count"] as? Int
				if let strRating = data["like_emoji"] as? String{
					dict["like_emoji"] = Int(strRating) ?? 1
				}
				else{
					dict["like_emoji"] = data["like_emoji"] as? Int ?? 1
				}
			}
			self.foliosListArray[row] = dict
			self.getLikedStatus(row: row)
			
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
}
