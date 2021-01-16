//
//  GroupDiscussionViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/12/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmptyPostTableviewCell: UITableViewCell {
	@IBOutlet weak var emptyImage: UIImageView!
	@IBOutlet weak var discLabel: UILabel!
}

class GroupDiscussionViewController: UIViewController {
	@IBOutlet weak var groupImage: UIImageView!
	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var addedMembersLabel: UILabel!
	@IBOutlet weak var discLabel: UILabel!
	@IBOutlet weak var readMoreButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var joinButton: UIButton!
	@IBOutlet weak var shareToTimelineButton: UIButton!
	@IBOutlet weak var groupHeaderView: UIView!
	@IBOutlet weak var groupDetailsView: UIView!
	@IBOutlet weak var updateStatusShareAlbumView: UIView!
	@IBOutlet weak var groupDetailsTableview: UITableView!
	var allPostArray: [[String: Any]] = []
	var likesArray : [Int] = []
	var selectedGroupDict = [String: Any]()
	var groupListDetailsDict = [String: Any]()
	var groupId = ""
	var followOrUnfollow = ""
    override func viewDidLoad() {
        super.viewDidLoad()
		setUIForHeader()
		addBordersForButton(readMoreButton)
		addBordersForButton(editButton)
		addBordersForButton(joinButton)
		addBordersForButton(shareToTimelineButton)
		getGroupDetails()
		getGroupDiscussions()
		groupDetailsTableview.tableHeaderView = groupHeaderView
        // Do any additional setup after loading the view.
    }
    
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	func setUIForHeader() {
		groupId = selectedGroupDict["social_connect_group_id"] as? String ?? ""
		groupNameLabel.text = (selectedGroupDict["group_name"] as? String ?? "").capitalized
		groupImage.sd_setImage(with: URL(string: selectedGroupDict["group_logo"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
		
		updateStatusShareAlbumView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		groupDetailsView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
	}
	
	func addBordersForButton(_ sender: UIButton) {
		sender.layer.borderWidth = 1.0
		sender.layer.borderColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.25).cgColor
		sender.clipsToBounds = true
	}
	
	func getGroupMembers() {
		if groupId != "" {
			ILUtility.showProgressIndicator(controller: self)
			GroupsAPI.sharedManaged.getGroupMembers(groupId: self.groupId) { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				let value = response as! String
				let dic : [String : Any] = value.convertToDictionary()!
				self.groupListDetailsDict = dic["data"] as? [String : Any] ?? [:]
				self.addGroupDescription()
				if let members = self.groupListDetailsDict["group_members"] as? [[String: Any]], members.count > 0 {
					self.addedMembersLabel.text = "\(members.count)+ Members"
				}
			} faliure: { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	func getGroupDetails() {
		if groupId != "" {
			ILUtility.showProgressIndicator(controller: self)
			GroupsAPI.sharedManaged.getGroupsIdDetails(groupId: self.groupId) { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				let value = response as! String
				let dic : [String : Any] = value.convertToDictionary()!
				self.groupListDetailsDict = dic["data"] as? [String : Any] ?? [:]
				self.addGroupDescription()
				if let members = self.groupListDetailsDict["group_members"] as? [[String: Any]], members.count > 0 {
					self.addedMembersLabel.text = "\(members.count)+ Members"
				}
			} faliure: { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	func addGroupDescription() {
		if let disc = self.groupListDetailsDict["group_description"] as? String, disc != "" {
			self.discLabel.text = disc
			self.discLabel.layer.borderWidth = 0.0
			self.readMoreButton.isEnabled = true
			self.readMoreButton.alpha = 1.0
		}
		else {
			self.discLabel.text = "     Tell members and prospective members about the group it’s purpose, it’s value and interests.     "
			self.discLabel.layer.borderColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.25).cgColor
			self.discLabel.layer.borderWidth = 1.0
			self.readMoreButton.isEnabled = false
			self.readMoreButton.alpha = 0.5
		}
	}
	
	func getGroupDiscussions() {
		let dict = ["group_id": self.groupId, "limit": "10", "offset":"0"]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getGroupDiscussions(requestDict: dict,successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let array = response["data"] as? [[String : Any]] {
				let tmparry = array.filter { (dict) -> Bool in
					return dict["timeline_status"] as! String != "DELETED"
				}
				self.allPostArray = tmparry
				self.groupDetailsTableview.reloadData()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func getTimeLinePostDetails(selectedDict: [String: Any]) {
		
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.getTimelineDetails(timeLineID: selectedDict["_id"] as? String ?? "", successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			var postDetailsDict = selectedDict
			postDetailsDict["isUpdateMode"] = true
			if let tmpDict = dic["data"] as? [String : Any] {
				if let disc = tmpDict["description"] as? String {
					var detailsDict = postDetailsDict["details"] as? [String : Any] ?? [:]
					detailsDict["description"] = disc
					postDetailsDict["details"] = detailsDict
				}
			}
			self.performSegue(withIdentifier: "CreatePostViewControllerSegue", sender: postDetailsDict)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func updateStausORShareAlbum(_ sender: UIButton) {
		self.performSegue(withIdentifier: "CreatePostViewControllerSegue", sender: nil)
	}
	
	@objc func menuButtonAction(_ sender: UIButton){
		
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let selectedDict = allPostArray[sender.tag]
		var title = ""
		var pinned = ""
		if let isFavourite = selectedDict["is_favourite"] as? String, isFavourite == "No"{
			title = "Save post"
		}
		else{
			title = "Unsave post"
		}

		if let isPinned = selectedDict["pinned"] as? String, isPinned == "NO" {
			pinned = "Pin post"
		}
		else{
			pinned = "Unpin Post"
		}
		
		let favouritePostAction = UIAlertAction(title: title, style: .default, handler: { (action) -> Void in
			self.favouritesUnFavouritesPost(index: sender.tag)
		})

		let pinnedPostAction = UIAlertAction(title: pinned, style: .default, handler: { (action) -> Void in
			self.pinUnPinnedPost(index: sender.tag)
		})
		
		let detailsDict = selectedDict["details"] as? [String : Any] ?? [:]
		let typeOfPost = detailsDict["message_type"] as? String ?? ""
		
		if typeOfPost != "status" {
			actionsheet.addAction(favouritePostAction)
		}
		
		let editPostAction = UIAlertAction(title: "Edit post", style: .default, handler: { (action) -> Void in
			self.editTimelinePost(dict: selectedDict)
		})
		let hidePostAction = UIAlertAction(title: "Hide post", style: .default, handler: { (action) -> Void in
			self.hideTimelinePost(index: sender.tag, typeOfPost: typeOfPost)
		})
		
		let deletePostAction = UIAlertAction(title: "Delete post", style: .default, handler: { (action) -> Void in
			self.deleteTimelinePost(index: sender.tag)
		})
		
		let reportPostAction = UIAlertAction(title: "Report post", style: .default, handler: { (action) -> Void in
			self.performSegue(withIdentifier: "ReportPostID", sender: selectedDict)
		})
		
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
			
		}))
		
		favouritePostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		editPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		hidePostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		deletePostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		reportPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		pinnedPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		
		if selectedDict["logged_in_user_id"] as! String == selectedDict["user_id"] as! String {
			actionsheet.addAction(editPostAction)
			actionsheet.addAction(deletePostAction)
		}
		else {
			actionsheet.addAction(hidePostAction)
			actionsheet.addAction(reportPostAction)
		}
		actionsheet.addAction(pinnedPostAction)
		self.present(actionsheet, animated: true, completion: nil)
	}
	
	@objc func commentButtonAction(_ sender: UIButton) {
		let selectedDict = allPostArray[sender.tag]
		self.performSegue(withIdentifier: "CommentsViewControllerSegue", sender: selectedDict)
	}
	
	func favouritesUnFavouritesPost(index: Int) {
		
		var dict = allPostArray[index]
		let timeLineID = dict["_id"] as? String ?? ""
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.requestFavouriteUnfavoritePost(timeLineID: timeLineID, successResponse: {(response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let favStatus = dict["is_favourite"] as? String, favStatus == "No" {
				dict["is_favourite"] = "Yes"
				ILUtility.showAlert(title: "Imaginglink",message: "Added to the favourite list", controller: self)
			}
			else {
				dict["is_favourite"] = "No"
				ILUtility.showAlert(title: "Imaginglink",message: "Removed from the favourite list", controller: self)
			}
			self.allPostArray[index] = dict
			self.groupDetailsTableview.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
			
		}, faliure: {(error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	func pinUnPinnedPost(index: Int) {
		var dict = allPostArray[index]
		let requestValues = ["post_id" : dict["_id"] as? String ?? "", "group_id": groupId] as [String:Any]
		let type = (dict["pinned"] as? String ?? "NO") == "NO" ? kPinPost : kUnPinPost
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.requestPinUnpinPost(pinType: type, requestDict: requestValues) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let favStatus = dict["pinned"] as? String, favStatus == "NO" {
				dict["pinned"] = "YES"
				ILUtility.showAlert(title: "Imaginglink",message: "Post pinned successfully.", controller: self)
			}
			else {
				dict["pinned"] = "NO"
				ILUtility.showAlert(title: "Imaginglink",message: "Post unpinned successfully.", controller: self)
			}
			self.allPostArray[index] = dict
			self.groupDetailsTableview.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func hideTimelinePost(index: Int, typeOfPost: String) {
		
		let dict = allPostArray[index]
		let timeLineID = dict["_id"] as? String ?? ""
		let requestDict = ["post_id": timeLineID, "type": "generalWalltimeline"]
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.hideTimeLimelinePost(requestDict: requestDict, successResponse: {(response) in
			ILUtility.hideProgressIndicator(controller: self)
			ILUtility.showAlert(title: "Imaginglink",message: "Post has been hidden", controller: self)
			self.allPostArray.remove(at: index)
			self.groupDetailsTableview.reloadData()
		}, faliure: {(error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	func editTimelinePost(dict: [String: Any]) {
		getTimeLinePostDetails(selectedDict: dict)
	}
	
	func deleteTimelinePost(index: Int) {
		
		let dict = allPostArray[index]
		let timeLineID = dict["_id"] as? String ?? ""
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.deleteTimeLimelinePost(timeLineID: timeLineID, successResponse: {(response) in
			ILUtility.hideProgressIndicator(controller: self)
			ILUtility.showAlert(title: "Imaginglink",message: "Post has been deleted", controller: self)
			self.allPostArray.remove(at: index)
			self.groupDetailsTableview.reloadData()
		}, faliure: {(error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	@objc func sharePost(_ sender: UIButton){
		let index = sender.tag
		let dict = allPostArray[index]
		
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		let msg = detailsDict["message"] as? String ?? ""
		
		var sharingItems = [Any]()
		let msgID = detailsDict["message_id"] as? String ?? ""
		let typeOfPost = detailsDict["message_type"] as? String ?? ""
		sharingItems.append(msg)
		if typeOfPost == "status" {
			//sharingItems = []
		}
		else if typeOfPost == "album" {
			let typeOfAlbum = detailsDict["album_type"] as? String ?? ""
			if typeOfAlbum == "video" {
				if let videosUrls = detailsDict["attachments"] as? [String], videosUrls.count > 0 {
					sharingItems.append(contentsOf: videosUrls)
				}
				else{
					sharingItems.append(contentsOf: [detailsDict["attachments"] as? String ?? ""])
				}
			}
			else {
				if let tmpArray = detailsDict["attachments"] as? [String] {
					let array = tmpArray.map { (str) -> String in
						return "\(kImageAndFileBaseUrl)\(msgID)/\(str)"
					}
					sharingItems.append(contentsOf: array)
				}
			}
		}
		else if typeOfPost == "user_file" {
			if let tmpArray = detailsDict["attachments"] as? [[String: Any]] {
				let array = tmpArray.map { (dict) -> String in
					return "\(kImageAndFileBaseUrl)\(msgID)/\(dict["name"] as? String ?? "")"
				}
				sharingItems.append(contentsOf: array)
			}
		}
		
		let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
		
		activityViewController.popoverPresentationController?.sourceView = self.view
		activityViewController.excludedActivityTypes = [.message, .mail, .print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .postToTencentWeibo, .airDrop, .openInIBooks, .markupAsPDF]
		self.present(activityViewController, animated: false, completion: nil)
	}
	
	func updateGroupDiscussion(text: String) {
		let dict = ["group_id": groupId, "group_description": text]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.updateGroupDescription(requestDict: dict,successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let description = response["data"] as? String {
				self.groupListDetailsDict["group_description"] = description
				self.addGroupDescription()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func makeFollowUnFollowGroup(status: String) {
		let dict = ["group_id": self.groupId, "status": (status == "follow") ? "APPROVED" : "UNFOLLOW"]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.updateUserGroupStatus(requestDict: dict,successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.followOrUnfollow = status
			if status == "follow" {
				self.joinButton.setTitle("✓  Joined", for: .normal)
			}
			else {
				self.joinButton.setTitle("join", for: .normal)
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func readMore(_ sender: UIButton) {
		if let disc = self.groupListDetailsDict["group_description"] as? String, disc != "" {
			self.performSegue(withIdentifier: "ReadMoreVCID", sender: nil)
		}
	}
	
	@IBAction func editAction(_ sender: UIButton) {
		if let isAdmin = selectedGroupDict["is_admin"] as? Bool, isAdmin == true {
			self.performSegue(withIdentifier: "EditDiscriptionViewControllerlD", sender: nil)
		}
		else {
			ILUtility.showAlert(title: "Imaginglink",message: "You don't have permission to edit group description", controller: self)
		}
	}
	
	@IBAction func joinAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: nil)
	}
	
	@IBAction func shareToTimelineAction(_ sender: UIButton) {
		let dict = ["share_group_id": groupId, "message_type": "share_group", "visibility": "public"]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.shareGroup(requestDict: dict,successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "ReadMoreVCID" {
			let vc = segue.destination as! ReadMoreViewController
			vc.readMoreText = self.groupListDetailsDict["group_description"] as? String ?? ""
		}
		else if segue.identifier == "EditDiscriptionViewControllerlD" {
			let vc : AddCommentReplyViewController = segue.destination as! AddCommentReplyViewController
			vc.isFrom = "GroupDiscussion"
			vc.messageStr = self.groupListDetailsDict["group_description"] as? String ?? ""
			vc.callBack = { (replyMessage) in
				self.updateGroupDiscussion(text: replyMessage)
			}
		}
		else if (segue.identifier == "CommentsViewControllerSegue") {
			let vc : CommentsViewController = segue.destination as! CommentsViewController
			vc.dataDict = sender as? [String: Any] ?? [:]
		}
		else if (segue.identifier == "fullImageVCID") {
			let vc : FullSizeImageViewController = segue.destination as! FullSizeImageViewController
			vc.imagesDict = sender as? [String: Any] ?? [:]
			vc.isFrom = "SocialConnet"
		}
		else if (segue.identifier == "UploadedFilesViewControllerID") {
			let vc : UploadedFilesViewController = segue.destination as! UploadedFilesViewController
			self.navigationController?.isNavigationBarHidden = true
			vc.dataDict = sender as? [String: Any] ?? [:]
		}
		else if (segue.identifier == "ReportPostID") {
			let vc : ReportPostViewController = segue.destination as! ReportPostViewController
			if let dict = sender as? [String: Any]{
				vc.userID = dict["_id"] as? String ?? ""
				vc.presentationTitle = ""
				vc.isFromVC = "Groups"
				vc.groupId = groupId
			}
		}
		else if segue.identifier == "PopUpVCID" {
			let vc = segue.destination as! CustomPopUpViewController
			vc.selectionType = .Single
			vc.titleArray = ["follow", "unfollow"]
			vc.selectedRowTitles = [followOrUnfollow]
			vc.callBack = { (titles) in
				if titles.count > 0 {
					self.makeFollowUnFollowGroup(status: titles[0])
				}
			}
		}
		else if (segue.identifier == "CreatePostViewControllerSegue") {
			self.navigationController?.isNavigationBarHidden = false
			let vc : CreatePostViewController = segue.destination as! CreatePostViewController
			let dict = sender as? [String: Any] ?? [:]
			vc.isFrom = "Group"
			vc.groupID = groupId
			let tmpDict = dict["details"] as? [String : Any] ?? [:]
			let typeOfPost = tmpDict["message_type"] as? String ?? ""
			switch typeOfPost {
			case "album":
				vc.selectedIndex = 101
				vc.albumUpdateDict = dict
			case "user_file":
				vc.selectedIndex = 102
				vc.filesUpdateDict = dict
			default:
				vc.selectedIndex = 100
				vc.statusUpdateDict = dict
			}
		}
    }
}

extension GroupDiscussionViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell = UITableViewCell()
		if allPostArray.count == 0 {
			let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyPostTableviewCellID", for: indexPath) as! EmptyPostTableviewCell
			emptyCell.discLabel.text = "Currenty you don’t have any posts"
			return emptyCell
		}
		
		let dict = allPostArray[indexPath.row]["details"] as? [String : Any] ?? [:]
		let typeOfPost = dict["message_type"] as? String ?? ""

		if typeOfPost == "status" {
			let statusCell = tableView.dequeueReusableCell(withIdentifier: "SharedStatusTableViewCellID", for: indexPath) as! SharedStatusTableViewCell
			statusCell.selectedLikes = likesArray
			statusCell.likeButton.tag = indexPath.row
			statusCell.ShareButton.tag = indexPath.row
			statusCell.menuButton.tag = indexPath.row
			statusCell.commentButton.tag = indexPath.row
			statusCell.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
			statusCell.ShareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
			statusCell.commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
			statusCell.delegate = self
			statusCell.setUI(dict: allPostArray[indexPath.row])
			cell = statusCell
		}
		else if typeOfPost == "album" {
			let typeOfAlbum = dict["album_type"] as? String ?? ""
			if typeOfAlbum == "video" {
				let albumVideoCell = tableView.dequeueReusableCell(withIdentifier: "SharedVideoTableViewCellID", for: indexPath) as! SharedVideoTableViewCell
				albumVideoCell.selectedLikes = likesArray
				albumVideoCell.likeButton.tag = indexPath.row
				albumVideoCell.ShareButton.tag = indexPath.row
				albumVideoCell.menuButton.tag = indexPath.row
				albumVideoCell.commentButton.tag = indexPath.row
				albumVideoCell.delegate = self
				albumVideoCell.setUI(dict: allPostArray[indexPath.row])
				albumVideoCell.ShareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
				albumVideoCell.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
				albumVideoCell.commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
				cell = albumVideoCell
			}
			else {
				let albumImageCell = tableView.dequeueReusableCell(withIdentifier: "SharedMultipleImageTableViewCellID", for: indexPath) as! SharedMultipleImageTableViewCell
				albumImageCell.selectedLikes = likesArray
				albumImageCell.likeButton.tag = indexPath.row
				albumImageCell.ShareButton.tag = indexPath.row
				albumImageCell.menuButton.tag = indexPath.row
				albumImageCell.commentButton.tag = indexPath.row
				albumImageCell.delegate = self
				albumImageCell.setUI(dict: allPostArray[indexPath.row])
				albumImageCell.ShareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
				albumImageCell.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
				albumImageCell.commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
				albumImageCell.delegate = self
				albumImageCell.imagesCollectionView.tag = indexPath.row
				cell = albumImageCell
			}
		}
		else if typeOfPost == "user_file" {
			let sharedFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SharedFileTableViewCellID", for: indexPath) as! SharedFileTableViewCell
			sharedFileTableViewCell.selectedLikes = likesArray
			sharedFileTableViewCell.likeButton.tag = indexPath.row
			sharedFileTableViewCell.ShareButton.tag = indexPath.row
			sharedFileTableViewCell.menuButton.tag = indexPath.row
			sharedFileTableViewCell.commentButton.tag = indexPath.row
			sharedFileTableViewCell.delegate = self
			sharedFileTableViewCell.fileDelegate = self
			sharedFileTableViewCell.setUI(dict: allPostArray[indexPath.row])
			sharedFileTableViewCell.ShareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
			sharedFileTableViewCell.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
			sharedFileTableViewCell.commentButton.addTarget(self, action: #selector(commentButtonAction), for: .touchUpInside)
			cell = sharedFileTableViewCell
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if allPostArray.count == 0 {
			return 1
		}
		return allPostArray.count
	}
}

extension GroupDiscussionViewController: SharedStatusTableViewCellDelegate {
	func getLikedStatus(row: Int) {
		if likesArray.contains(row){
			likesArray.removeAll()
		}
		else{
			likesArray.removeAll()
			likesArray.append(row)
		}
		self.groupDetailsTableview.reloadData()
	}
	
	func updateRatingWithIndex(row: Int, rating: Int) {
		ILUtility.showProgressIndicator(controller: self)
		var dict = allPostArray[row]
		let timeLineID = dict["_id"] as? String ?? ""

		SocialConnectAPI.sharedManaged.requestForSaveAllPostLikesEmoji(timeLineID: timeLineID, likeUnLikeValue: "\(rating)", successResponse: { (response) in
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
			self.allPostArray[row] = dict
			self.getLikedStatus(row: row)
			
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func showMoreImages(imagesList: [String], index:Int, imageIndex: Int) {
		let dict = self.allPostArray[index]
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		let text = detailsDict["message"] as? String ?? ""
		self.performSegue(withIdentifier: "fullImageVCID", sender: ["images": imagesList, "message": text, "index": imageIndex])
	}
}

extension GroupDiscussionViewController: FileTypeTableViewCellDelegate {
	func didSelect(index: Int) {
		let selectedDict = allPostArray[index]
		self.performSegue(withIdentifier: "UploadedFilesViewControllerID", sender: selectedDict)
	}
}
