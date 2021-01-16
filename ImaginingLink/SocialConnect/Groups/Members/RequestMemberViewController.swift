//
//  RequestMemberViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/22/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class RequestMemberViewController: UIViewController {
	var pendingRequestArray = [[String: Any]]()
	@IBOutlet weak var friendRequestCollectionView: UICollectionView!
	@IBOutlet weak var friendRequestCollectionH: NSLayoutConstraint!
	var groupId = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		getGroupMembers()
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
				let pendingFilter = results.filter { (dict) -> Bool in
					return dict["status"] as? String ?? "" == "PENDING"
				}
				self.pendingRequestArray = pendingFilter
				self.changeScrollDirection()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
	}
	
	@objc func approveButtonAction(_ sender: UIButton) {
		makeAPIRequest(index: sender.tag, type: "APPROVED")
	}
	
	@objc func rejectButtonAction(_ sender: UIButton) {
		makeAPIRequest(index: sender.tag, type: "REJECTED")
	}
	
	func makeAPIRequest(index: Int, type: String) {
		let dict = pendingRequestArray[index]
		let memberId = dict["user_id"] as? String ?? ""
		let requestDict = ["group_id": groupId,"member_id": memberId,"status": type]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.makeGroupAdminApproveOrRejectRequest(parameterDict: requestDict, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getGroupMembers()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func changeScrollDirection() {
		if let flowLayout = friendRequestCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			if pendingRequestArray.count <= 1 {
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

extension RequestMemberViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendRequestAcceptRejectCollectionViewCellID", for: indexPath) as! FriendRequestAcceptRejectCollectionViewCell
		cell.setUI(dict:  pendingRequestArray[indexPath.item])
		cell.acceptButton.addTarget(self, action: #selector(approveButtonAction), for: .touchUpInside)
		cell.rejectButton.addTarget(self, action: #selector(rejectButtonAction), for: .touchUpInside)
		cell.acceptButton.tag = indexPath.item
		cell.rejectButton.tag = indexPath.item
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pendingRequestArray.count
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
