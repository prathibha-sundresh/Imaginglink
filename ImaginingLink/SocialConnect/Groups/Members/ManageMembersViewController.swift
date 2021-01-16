//
//  ManageMembersViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/22/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class ManageMembersViewController: BaseHamburgerViewController {
	@IBOutlet weak var topCollectionView: UICollectionView!
	@IBOutlet weak var containerView: UIView!
	var allMembersViewController : AllMembersViewController?
	var requestMemberViewController : RequestMemberViewController?
	var groupAdminsViewController : GroupAdminsViewController?
	var inviteGroupMemberVC : InviteGroupMemberVC?
	var timeLinesOptions : [[String: Any]] = [["name":"All Members", "icon": "myfriends_icon"],["name":"Requests", "icon": "myfriends_icon"],["name":"Admins", "icon": "addFriends_icon"], ["name":"Invite to group", "icon": "inviteToGroups_icon"]]
	var selectedOption : Int = 0
	var groupId = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		loadVC()
		// Do any additional setup after loading the view.
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		backAction()
	}
	
	@IBAction func menuButtonAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
	}
	
	func loadVC() {
		if self.children.count > 0{
			let viewControllers:[UIViewController] = self.children
			for viewContoller in viewControllers{
				viewContoller.willMove(toParent: nil)
				viewContoller.view.removeFromSuperview()
				viewContoller.removeFromParent()
			}
		}
		
		let storyboard = UIStoryboard(name: "Groups", bundle: nil)
		var controller: UIViewController?
		
		switch selectedOption {
		case 0:
			allMembersViewController = storyboard.instantiateViewController(withIdentifier: "AllMembersViewControllerVCID") as? AllMembersViewController
			allMembersViewController?.groupId = groupId
			controller = allMembersViewController
		case 1:
			requestMemberViewController = storyboard.instantiateViewController(withIdentifier: "RequestMemberViewControllerVCID") as? RequestMemberViewController
			requestMemberViewController?.groupId = groupId
			controller = requestMemberViewController
		case 2:
			groupAdminsViewController = storyboard.instantiateViewController(withIdentifier: "GroupAdminsViewControllerVCID") as? GroupAdminsViewController
			groupAdminsViewController?.groupId = groupId
			controller = groupAdminsViewController
		case 3:
			inviteGroupMemberVC = storyboard.instantiateViewController(withIdentifier: "InviteGroupMemberVCID") as? InviteGroupMemberVC
			inviteGroupMemberVC?.groupId = groupId
			controller = inviteGroupMemberVC
		default:
			break
		}
		
		controller?.view.frame = containerView.bounds
		self.addChild(controller!)
		containerView.addSubview((controller?.view)!)
		controller?.didMove(toParent: self)
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

extension ManageMembersViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeLinesOptionsCollectionCellID", for: indexPath) as! timeLinesOptionsCollectionCell
		cell.bottomLine.isHidden = (selectedOption == indexPath.item) ? false : true
		let dict = timeLinesOptions[indexPath.item]
		cell.imageView.image = UIImage(named: dict["icon"] as! String)
		cell.titleLabel.text = dict["name"] as? String ?? ""
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return timeLinesOptions.count
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedOption = indexPath.item
		topCollectionView.reloadData()
		loadVC()
	}
}
