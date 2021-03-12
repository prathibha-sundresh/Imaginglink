//
//  ManagePostsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/13/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit
import WebKit

class PostStatusTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var discLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var borderView : UIView!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var rejectButton: UIButton!
	
	func setUI(dict: [String: Any]) {
		profileImageView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		discLabel.text = detailsDict["message"] as? String ?? ""
		
		if let userDetails = dict["user_details"] as? [String: Any] {
			let image = userDetails["profile_picture"] as? String ?? ""
			profileImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
			let firstName = userDetails["first_name"] as? String ?? ""
			let lastName = userDetails["last_name"] as? String ?? ""
			let fullname = firstName + " " + lastName
			
			let strTnC = NSString(string: "\(fullname) shared a Status")
			let attributedString = NSMutableAttributedString(string: strTnC as String)
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: fullname))
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: "Status"))
			nameLabel.attributedText = attributedString
		}
		timeLabel.text = dict["created_at"] as? String ?? ""
	}
}

class PostAlbumVideoTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var webview: WKWebView!
	@IBOutlet weak var borderView : UIView!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var rejectButton: UIButton!
	
	func setUI(dict: [String: Any]) {
		
		profileImageView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		if let videosUrls = detailsDict["attachments"] as? [String], videosUrls.count > 0 {
			webview.load(URLRequest(url: URL(string: videosUrls[0])!))
		}
		else{
			webview.load(URLRequest(url: URL(string: detailsDict["attachments"] as? String ?? "")!))
		}
		if let userDetails = dict["user_details"] as? [String: Any] {
			let image = userDetails["profile_picture"] as? String ?? ""
			profileImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
			let firstName = userDetails["first_name"] as? String ?? ""
			let lastName = userDetails["last_name"] as? String ?? ""
			let fullname = firstName + " " + lastName
			
			let strTnC = NSString(string: "\(fullname) shared a Album")
			let attributedString = NSMutableAttributedString(string: strTnC as String)
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: fullname))
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: "Album"))
			nameLabel.attributedText = attributedString
		}
		timeLabel.text = dict["created_at"] as? String ?? ""
	}
}

class PostSharedMultipleImageTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var borderView : UIView!
	@IBOutlet weak var imagesCollectionView: UICollectionView!
	var attachmentsArray: [String] = []
	@IBOutlet weak var imagesCollectionViewH: NSLayoutConstraint!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var rejectButton: UIButton!
	
	func setUI(dict: [String: Any]) {
		profileImageView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		let msgID = detailsDict["message_id"] as? String ?? ""
		if let tmpArray = detailsDict["attachments"] as? [String] {
			attachmentsArray = tmpArray.map { (str) -> String in
				return "\(kImageAndFileBaseUrl)\(msgID)/\(str)"
			}
		}
		if attachmentsArray.count <= 2 {
			imagesCollectionViewH.constant = 160
		}
		else {
			imagesCollectionViewH.constant = 290
		}
		
		imagesCollectionView.reloadData()
		
		if let userDetails = dict["user_details"] as? [String: Any] {
			let image = userDetails["profile_picture"] as? String ?? ""
			profileImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
			let firstName = userDetails["first_name"] as? String ?? ""
			let lastName = userDetails["last_name"] as? String ?? ""
			let fullname = firstName + " " + lastName
			
			let strTnC = NSString(string: "\(fullname) shared a Album")
			let attributedString = NSMutableAttributedString(string: strTnC as String)
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: fullname))
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: "Album"))
			nameLabel.attributedText = attributedString
		}
		
		timeLabel.text = dict["created_at"] as? String ?? ""
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let albumImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumImageCollectionViewCellID", for: indexPath) as! AlbumImageCollectionViewCell
		albumImageCollectionViewCell.imageView.sd_setImage(with: URL(string: attachmentsArray[indexPath.item]), placeholderImage: nil)
		albumImageCollectionViewCell.plusNumberLabel.isHidden = true
//		if attachmentsArray.count > 4 && indexPath.row == 3 {
//			albumImageCollectionViewCell.plusNumberLabel.isHidden = false
//			albumImageCollectionViewCell.plusNumberLabel.text = "+\(attachmentsArray.count - 4)"
//		}
		return albumImageCollectionViewCell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//		if attachmentsArray.count > 4 {
//			return 4
//		}
		return attachmentsArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//delegate?.showMoreImages?(imagesList: attachmentsArray, index: imagesCollectionView.tag, imageIndex: indexPath.item)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if attachmentsArray.count == 1 {
			return CGSize(width: imagesCollectionView.frame.size.width, height: 160)
		}
		return CGSize(width: imagesCollectionView.frame.size.width / 2 - 5, height: 135)
	}
}

class PostSharedFileTableViewCell: UITableViewCell,UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var fileTableview: UITableView!
	@IBOutlet weak var fileTableviewH: NSLayoutConstraint!
	@IBOutlet weak var borderView : UIView!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var rejectButton: UIButton!
	var attachmentsArray: [[String: Any]] = []
	
	func setUI(dict: [String: Any]) {
		profileImageView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		attachmentsArray = detailsDict["attachments"] as? [[String: Any]] ?? []
		fileTableview.reloadData()
		fileTableviewH.constant = CGFloat(attachmentsArray.count * 25)
		
		if let userDetails = dict["user_details"] as? [String: Any] {
			let image = userDetails["profile_picture"] as? String ?? ""
			profileImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
			let firstName = userDetails["first_name"] as? String ?? ""
			let lastName = userDetails["last_name"] as? String ?? ""
			let fullname = firstName + " " + lastName
			
			let strTnC = NSString(string: "\(fullname) shared a File")
			let attributedString = NSMutableAttributedString(string: strTnC as String)
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: fullname))
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: "File"))
			nameLabel.attributedText = attributedString
		}
		timeLabel.text = dict["created_at"] as? String ?? ""
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "FileTypeTableViewCellID", for: indexPath) as! FileTypeTableViewCell
		let fileName = attachmentsArray[indexPath.row]["name"] as?String ?? ""
		cell.fileNameLbl.text = fileName
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return attachmentsArray.count
	}
}

class ManagePostsViewController: UIViewController {
	var groupId = ""
	var allPostArray: [[String: Any]] = []
	@IBOutlet weak var managePostTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
		getManagePosts()
        // Do any additional setup after loading the view.
    }
    
	func getManagePosts() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getGroupManagePosts(groupId: groupId, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				let filer = array.filter { (dict) -> Bool in
					let detailDict = dict["details"] as? [String: Any] ?? [:]
					let type = detailDict["message_type"] as? String ?? ""
					if type == "status_portfolio" || type == "case" || type == "share_group" {
						return false
					}
					return true
				}
				self.allPostArray = filer
				self.managePostTableView.reloadData()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func approvePost(by Index: Int) {
		let post_id = allPostArray[Index]["_id"] as? String ?? ""
		let dic = ["group_id": groupId,"post_id": post_id] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.approvePost(parameterDict: dic) { (response) in
			self.getManagePosts()
			ILUtility.hideProgressIndicator(controller: self)
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func rejectPost(by Index: Int) {
		self.performSegue(withIdentifier: "RejectGroupPostSegue", sender: Index)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "RejectGroupPostSegue" {
			let index = sender as! Int
			let vc = segue.destination as! AddCommentReplyViewController
			vc.isFrom = "Manage Post"
			vc.callBack = { (str) in
				let post_id = self.allPostArray[index]["_id"] as? String ?? ""
				let dic = ["group_id": self.groupId,"post_id": post_id,"reject_reason": str] as [String : Any]
				ILUtility.showProgressIndicator(controller: self)
				GroupsAPI.sharedManaged.rejectPost(parameterDict: dic) { (response) in
					self.getManagePosts()
					ILUtility.hideProgressIndicator(controller: self)
				} faliure: { (error) in
					ILUtility.hideProgressIndicator(controller: self)
				}
			}
		}
    }
	
	@objc func rejectButtonAction(_ sender: UIButton) {
		rejectPost(by: sender.tag)
	}
	
	@objc func acceptButtonAction(_ sender: UIButton) {
		approvePost(by: sender.tag)
	}
}

extension ManagePostsViewController: UITableViewDelegate, UITableViewDataSource {
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
			let statusCell = tableView.dequeueReusableCell(withIdentifier: "PostStatusTableViewCellID", for: indexPath) as! PostStatusTableViewCell
			
			statusCell.acceptButton.tag = indexPath.row
			statusCell.rejectButton.tag = indexPath.row
			statusCell.acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
			statusCell.rejectButton.addTarget(self, action: #selector(rejectButtonAction), for: .touchUpInside)
			statusCell.setUI(dict: allPostArray[indexPath.row])
			cell = statusCell
		}
		else if typeOfPost == "album" {
			let tmpDict = allPostArray[indexPath.row]["status"] as? [String : Any] ?? [:]
			let typeOfAlbum = tmpDict["album_type"] as? String ?? ""
			if typeOfAlbum == "video" {
				let albumVideoCell = tableView.dequeueReusableCell(withIdentifier: "PostAlbumVideoTableViewCellID", for: indexPath) as! PostAlbumVideoTableViewCell
				albumVideoCell.acceptButton.tag = indexPath.row
				albumVideoCell.rejectButton.tag = indexPath.row
				albumVideoCell.setUI(dict: allPostArray[indexPath.row])
				albumVideoCell.acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
				albumVideoCell.rejectButton.addTarget(self, action: #selector(rejectButtonAction), for: .touchUpInside)
				cell = albumVideoCell
			}
			else {
				let albumImageCell = tableView.dequeueReusableCell(withIdentifier: "PostSharedMultipleImageTableViewCellID", for: indexPath) as! PostSharedMultipleImageTableViewCell
				albumImageCell.acceptButton.tag = indexPath.row
				albumImageCell.rejectButton.tag = indexPath.row
				
				albumImageCell.setUI(dict: allPostArray[indexPath.row])
				albumImageCell.acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
				albumImageCell.rejectButton.addTarget(self, action: #selector(rejectButtonAction), for: .touchUpInside)
				albumImageCell.imagesCollectionView.tag = indexPath.row
				cell = albumImageCell
			}
		}
		else if typeOfPost == "user_file" {
			let sharedFileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostSharedFileTableViewCellID", for: indexPath) as! PostSharedFileTableViewCell
			sharedFileTableViewCell.acceptButton.tag = indexPath.row
			sharedFileTableViewCell.rejectButton.tag = indexPath.row
			sharedFileTableViewCell.setUI(dict: allPostArray[indexPath.row])
			sharedFileTableViewCell.acceptButton.addTarget(self, action: #selector(acceptButtonAction), for: .touchUpInside)
			sharedFileTableViewCell.rejectButton.addTarget(self, action: #selector(rejectButtonAction), for: .touchUpInside)
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
