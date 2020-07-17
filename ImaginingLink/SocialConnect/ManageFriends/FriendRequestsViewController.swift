//
//  FriendRequestsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class FriendRequestAcceptRejectCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var friendsLabel: UILabel!
	@IBOutlet weak var ignoreFriendButton: UIButton!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var rejectButton: UIButton!
	
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

class FriendRequestsViewController: UIViewController {
	var pendingRequestArray = [[String: Any]]() // to_me
	var requestSentArray = [[String: Any]]() // from_me
	var ignoredRequestArray = [[String: Any]]()
	var filteredArray = [[String: Any]]()
	@IBOutlet weak var friendRequestCollectionView: UICollectionView!
	@IBOutlet weak var friendRequestCollectionH: NSLayoutConstraint!
	@IBOutlet weak var frinedRequestTypeTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.frinedRequestTypeTF.text = "Pending requests"
		getFriendRequests()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func selectdropDownForPendingOrSentRequest(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: nil)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "PopUpVCID" {
			let vc = segue.destination as! CustomPopUpViewController
			vc.selectionType = .Single
			vc.titleArray = ["Pending requests", "Requests sent","Ignored requests"]
			vc.selectedRowTitles = [frinedRequestTypeTF.text!]
			vc.callBack = { (titles) in
				self.frinedRequestTypeTF.text = titles[0]
				if titles[0] == "Pending requests" {
					self.filteredArray = self.pendingRequestArray
				}
				else if titles[0] == "Ignored requests" {
					self.filteredArray = self.ignoredRequestArray
				}
				else {
					self.filteredArray = self.requestSentArray
				}
				self.changeScrollDirection()
			}
		}
    }
	
	@objc func ignoreFriendButtonAction(_ sender: UIButton) {
		makeAPIRequest(index: sender.tag, endUrlPath: kIgnoreFriendRequest)
	}
	
	@objc func acceptOrCancelFriendButtonAction(_ sender: UIButton) {
		if frinedRequestTypeTF.text! == "Pending requests" || frinedRequestTypeTF.text! == "Ignored requests" {
			makeAPIRequest(index: sender.tag, endUrlPath: kApproveFriendRequest)
		}
		else {
			makeAPIRequest(index: sender.tag, endUrlPath: kCancelFriendRequest)
		}
	}
	
	@objc func rejectFriendButtonAction(_ sender: UIButton) {
		makeAPIRequest(index: sender.tag, endUrlPath: kRejectFriendRequest)
	}
	
	func makeAPIRequest(index: Int, endUrlPath: String) {
		let dict = filteredArray[index]
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.makeAddORCancelORRejectORApproveORUnFriendRequest(friendID: dict["user_id"] as? String ?? "", urlStr: endUrlPath, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getFriendRequests()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	func getFriendRequests() {
		
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.getPendingFriendRequests(successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let tmpDict = dic["data"] as? [String : Any] {
				let fromMearray = tmpDict["from_me"] as? [[String: Any]] ?? []
				let results = fromMearray.map { (dict) -> [String : Any] in
					var tmpDict = dict
					let fullName = "\(dict["first_name"] as? String ?? "") \(dict["last_name"] as? String ?? "")"
					tmpDict["fullName"] = fullName
					return tmpDict
				}
				self.requestSentArray = results
				let toMearray = tmpDict["to_me"] as? [[String: Any]] ?? []
				let results1 = toMearray.map { (dict) -> [String : Any] in
					var tmpDict = dict
					let fullName = "\(dict["first_name"] as? String ?? "") \(dict["last_name"] as? String ?? "")"
					tmpDict["fullName"] = fullName
					return tmpDict
				}
				let ignoredFilter = results1.filter { (dict) -> Bool in
					return dict["status"] as? String ?? "" == "IGNORED"
				}
				let pendingFilter = results1.filter { (dict) -> Bool in
					return dict["status"] as? String ?? "" == "PENDING"
				}
				self.pendingRequestArray = pendingFilter
				self.ignoredRequestArray = ignoredFilter
				if self.frinedRequestTypeTF.text! == "Pending requests" {
					self.filteredArray = self.pendingRequestArray
				}
				else if self.frinedRequestTypeTF.text! == "Ignored requests" {
					self.filteredArray = self.ignoredRequestArray
				}
				else {
					self.filteredArray = self.requestSentArray
				}
				
				self.changeScrollDirection()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	func changeScrollDirection() {
		if let flowLayout = friendRequestCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			if filteredArray.count <= 1 {
				flowLayout.scrollDirection = .horizontal
				friendRequestCollectionH.constant = 225
			}
			else {
				flowLayout.scrollDirection = .vertical
				friendRequestCollectionH.constant = self.view.frame.size.height - 15
			}
		}
		friendRequestCollectionView.reloadData()
	}
}

extension FriendRequestsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendRequestAcceptRejectCollectionViewCellID", for: indexPath) as! FriendRequestAcceptRejectCollectionViewCell
		cell.setUI(dict:  filteredArray[indexPath.item])
		cell.ignoreFriendButton.addTarget(self, action: #selector(ignoreFriendButtonAction), for: .touchUpInside)
		cell.acceptButton.addTarget(self, action: #selector(acceptOrCancelFriendButtonAction), for: .touchUpInside)
		cell.rejectButton.addTarget(self, action: #selector(rejectFriendButtonAction), for: .touchUpInside)
		cell.ignoreFriendButton.tag = indexPath.item
		cell.acceptButton.tag = indexPath.item
		cell.rejectButton.tag = indexPath.item
		
		if frinedRequestTypeTF.text! == "Pending requests" || frinedRequestTypeTF.text! == "Ignored requests" {
			cell.ignoreFriendButton.isHidden = frinedRequestTypeTF.text! == "Ignored requests" ? true :false
			cell.rejectButton.isHidden = false
			cell.acceptButton.setTitle("Accept", for: .normal)
		}
		else {
			cell.ignoreFriendButton.isHidden = true
			cell.rejectButton.isHidden = true
			cell.acceptButton.setTitle("Cancel request", for: .normal)
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: self.view.frame.size.width / 2 - 5, height: 225)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}
