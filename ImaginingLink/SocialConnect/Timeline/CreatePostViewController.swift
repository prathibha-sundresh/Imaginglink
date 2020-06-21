//
//  CreatePostViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 6/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class CreatePostViewController: BaseHamburgerViewController {

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var statusImage: UIImageView!
	@IBOutlet weak var albumImage: UIImageView!
	@IBOutlet weak var shareFileImage: UIImageView!
	var statusUpdateDict = [String: Any]()
	var albumUpdateDict = [String: Any]()
	var filesUpdateDict = [String: Any]()
	var selectedIndex = 100
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		updateStatusAlbumFileButtonAction(self.view.viewWithTag(selectedIndex) as! UIButton)
	}
	
	@IBAction func backAction(_ sender: UIButton) {
		backAction()
    }
	
	@IBAction func updateStatusAlbumFileButtonAction(_ sender: UIButton) {
		
		if self.children.count > 0{
			let viewControllers:[UIViewController] = self.children
			for viewContoller in viewControllers{
				viewContoller.willMove(toParent: nil)
				viewContoller.view.removeFromSuperview()
				viewContoller.removeFromParent()
			}
		}
		for i in 100...102 {
			let btn = self.view.viewWithTag(i) as! UIButton
			sender.tag == i ? (btn.isEnabled = false) : (btn.isEnabled = true)
		}
		statusImage.image = UIImage(named: "status_icon")
		albumImage.image = UIImage(named: "album_icon")
		shareFileImage.image = UIImage(named: "shareFile_icon")
		let storyboard = UIStoryboard(name: "SocialConnect", bundle: nil)
		var controller: UIViewController?
		if sender.tag == 100 {
			statusImage.image = UIImage(named: "sel_status_icon")
			addSlideMenuButton(showBackButton: true, backbuttonTitle: "Update status")
			let timelineStatusVC = storyboard.instantiateViewController(withIdentifier: "UpdateTimelineStatusVCID") as! UpdateTimelineStatusVC
			timelineStatusVC.dataDict = statusUpdateDict
			controller = timelineStatusVC
		}
		else if sender.tag == 101 {
			albumImage.image = UIImage(named: "sel_album_icon")
			addSlideMenuButton(showBackButton: true, backbuttonTitle: "Share Album")
			let shareAlbumViewController = storyboard.instantiateViewController(withIdentifier: "ShareAlbumViewControllerID") as! ShareAlbumViewController
			shareAlbumViewController.dataDict = albumUpdateDict
			controller = shareAlbumViewController
		}
		else if sender.tag == 102 {
			shareFileImage.image = UIImage(named: "sel_shareFile_icon")
			addSlideMenuButton(showBackButton: true, backbuttonTitle: "Share File")
			let shareFileViewController = storyboard.instantiateViewController(withIdentifier: "ShareFileViewControllerID") as! ShareFileViewController
			shareFileViewController.dataDict = filesUpdateDict
			controller = shareFileViewController
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
