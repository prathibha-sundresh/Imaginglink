//
//  ManageFriendsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class ManageFriendsViewController: BaseHamburgerViewController {
	
	@IBOutlet weak var topCollectionView: UICollectionView!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var filterButton: UIButton!
	var myFriendsViewControllerVC : MyFriendsViewController?
	var friendRequestsViewController : FriendRequestsViewController?
	var friendsSearchViewController : FriendsSearchViewController?
	var friendsInviteToGroupViewController : FriendsInviteToGroupViewController?
	var timeLinesOptions : [[String: Any]] = [["name":"My Friends", "icon": "myfriends_icon"],["name":"Requests", "icon": "myfriends_icon"],["name":"Add Friends", "icon": "addFriends_icon"], ["name":"Invite to group", "icon": "inviteToGroups_icon"]]
	var selectedOption : Int = 0
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
	
	@IBAction func filterButtonAction(_ sender: UIButton) {
		myFriendsViewControllerVC?.filterAction()
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
		//
		let storyboard = UIStoryboard(name: "SocialConnect", bundle: nil)
		var controller: UIViewController?
		filterButton.isHidden = true
		switch selectedOption {
		case 0:
			filterButton.isHidden = false
			myFriendsViewControllerVC = storyboard.instantiateViewController(withIdentifier: "MyFriendsViewControllerVCID") as? MyFriendsViewController
			controller = myFriendsViewControllerVC
		case 1:
			friendRequestsViewController = storyboard.instantiateViewController(withIdentifier: "FriendRequestsViewControllerVCID") as? FriendRequestsViewController
			controller = friendRequestsViewController
		case 2:
			friendsSearchViewController = storyboard.instantiateViewController(withIdentifier: "FriendsSearchViewControllerVCID") as? FriendsSearchViewController
			controller = friendsSearchViewController
		case 3:
			friendsInviteToGroupViewController = storyboard.instantiateViewController(withIdentifier: "FriendsInviteToGroupViewControllerVCID") as? FriendsInviteToGroupViewController
			controller = friendsInviteToGroupViewController
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

extension ManageFriendsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
