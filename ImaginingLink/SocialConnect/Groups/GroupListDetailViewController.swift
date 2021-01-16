//
//  GroupListDetailViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/10/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class GroupListDetailViewController: BaseHamburgerViewController {

	@IBOutlet weak var topCollectionView: UICollectionView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var groupNameLabel: UILabel!
	@IBOutlet weak var groupImage: UIImageView!
	var groupDiscussionViewController : GroupDiscussionViewController?
	var groupEventListViewController : GroupEventListViewController?
	var selectedGroupDict = [String: Any]()
	var tabsArray : [[String: Any]] = [["name":"Discussion", "icon": "timeline_icon"],["name":"Members", "icon": "group_members_icon"],["name":"Events", "icon": "group_events_icon"], ["name":"Manage post", "icon": "group_manage_post_icon"]]
	var selectedOption : Int = 0
	var groupId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
		groupNameLabel.text = (selectedGroupDict["group_name"] as? String ?? "").capitalized
		groupImage.sd_setImage(with: URL(string: selectedGroupDict["group_logo"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
		groupImage.layer.borderColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00).cgColor
		groupId = self.selectedGroupDict["social_connect_group_id"] as? String ?? ""
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		loadVC()
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
			groupDiscussionViewController = storyboard.instantiateViewController(withIdentifier: "GroupDiscussionViewControllerID") as? GroupDiscussionViewController
			groupDiscussionViewController?.selectedGroupDict = selectedGroupDict
			controller = groupDiscussionViewController
		case 1:
			selectedOption = 0
			self.navigationController?.isNavigationBarHidden = true
			self.performSegue(withIdentifier: "ManageMembersViewControllerVCID", sender: nil)
			return
		case 2:
			groupEventListViewController = storyboard.instantiateViewController(withIdentifier: "GroupEventListViewControllerVCID") as? GroupEventListViewController
			groupEventListViewController?.groupId = groupId
			controller = groupEventListViewController
//		case 3:
//			friendsInviteToGroupViewController = storyboard.instantiateViewController(withIdentifier: "FriendsInviteToGroupViewControllerVCID") as? FriendsInviteToGroupViewController
//			controller = friendsInviteToGroupViewController
		default:
			break
		}
		
		controller?.view.frame = containerView.bounds
		self.addChild(controller!)
		containerView.addSubview((controller?.view)!)
		controller?.didMove(toParent: self)
	}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "ManageMembersViewControllerVCID" {
			let vc = segue.destination as! ManageMembersViewController
			vc.groupId = self.selectedGroupDict["social_connect_group_id"] as? String ?? ""
		}
    }
    

}

extension GroupListDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeLinesOptionsCollectionCellID", for: indexPath) as! timeLinesOptionsCollectionCell
		cell.bottomLine.isHidden = (selectedOption == indexPath.item) ? false : true
		let dict = tabsArray[indexPath.item]
		cell.imageView.image = UIImage(named: dict["icon"] as! String)
		cell.titleLabel.text = dict["name"] as? String ?? ""
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tabsArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedOption = indexPath.item
		topCollectionView.reloadData()
		loadVC()
	}
}
