//
//  PortFolioViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 7/27/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class PortFolioViewController: BaseHamburgerViewController {
	@IBOutlet weak var topCollectionView: UICollectionView!
	@IBOutlet weak var containerView: UIView!
	var portFolioLinesOptions : [[String: Any]] = [["name":"My Friends", "icon": "portfolio_profile_icon"],["name":"Requests", "icon": "portfolio_list_icon"],["name":"Add Friends", "icon": "addFriends_icon"]]
	var selectedOption : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = true
		loadVC()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
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
		
		let storyboard = UIStoryboard(name: "PortFolio", bundle: nil)
		var controller: UIViewController?
		
		switch selectedOption {
		case 0:
			let vc = storyboard.instantiateViewController(withIdentifier: "portFolioProfileViewControllerVCID") as! PortFolioProfileViewController
			controller = vc
		case 1:
			let vc = storyboard.instantiateViewController(withIdentifier: "UserPortFolioViewControllerVCID") as! UserPortFolioViewController
			controller = vc
		default:
			break
		}
		
		controller?.view.frame = containerView.bounds
		self.addChild(controller!)
		containerView.addSubview((controller?.view)!)
		controller?.didMove(toParent: self)
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		backAction()
	}
	
	@IBAction func menuButtonAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
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

extension PortFolioViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeLinesOptionsCollectionCellID", for: indexPath) as! timeLinesOptionsCollectionCell
		//cell.bottomLine.isHidden = (selectedOption == indexPath.item) ? false : true
		let dict = portFolioLinesOptions[indexPath.item]
		cell.imageView.image = UIImage(named: dict["icon"] as! String)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return portFolioLinesOptions.count
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		selectedOption = indexPath.item
		topCollectionView.reloadData()
		loadVC()
	}
}
