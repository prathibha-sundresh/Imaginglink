//
//  BaseHamburgerViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 22/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import Foundation
import ECSlidingViewController

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int)
}

class BaseHamburgerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    func addSlideMenuButton(showBackButton:Bool, backbuttonTitle: String){
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 5, width: self.view.frame.width - 100, height: 50)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        if (showBackButton == true) {
            backButton.setImage(UIImage(named: "BackButtonIcon"), for: UIControl.State.normal)
            backButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        }
        let attributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 12.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 116.0/255.0, green: 116.0/255.0, blue: 116.0/255.0, alpha: 1)]
        let attributesForBold = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Semibold", size: 18.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)]
        let str = NSString(string: backbuttonTitle)
        let range = str.range(of: UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)
        let str1 = NSMutableAttributedString(string: backbuttonTitle, attributes: attributesForBold)
        str1.addAttributes(attributes, range: range)
        backButton.setAttributedTitle(str1, for: .normal)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.titleLabel?.lineBreakMode = .byWordWrapping
        backButton.titleLabel?.numberOfLines = 0
        backButton.contentHorizontalAlignment = .left
        
        backButton.addTarget(self, action: #selector(BaseHamburgerViewController.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButton.ButtonType.custom)
        btnShowCart.backgroundColor = UIColor.clear
        btnShowCart.setImage(UIImage(named: "MenuIcon"), for: UIControl.State.normal)
        btnShowCart.frame = CGRect(x: self.view.frame.width - 60, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(BaseHamburgerViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        self.navigationItem.rightBarButtonItem = customRightBarItem;
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func getTopViewController() -> UIViewController {
        let topViewController : UIViewController? = self.navigationController!.topViewController!
        return topViewController!
    }
    
  
    func slideMenuItemSelectedAtIndex(_ index: Int) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            self.openViewControllerBasedOnIdentifier("InviteFriendsViewController")
        case 1:
            self.openViewControllerBasedOnIdentifier("ResetPasswordWithMenuViewController")
        case 2:
            self.openViewControllerBasedOnIdentifier("TwofactorAuthenticationViewController")
        case 3:
            self.openViewControllerBasedOnIdentifier("ChangeEmailViewController")
		case 4:
			self.performSegue(withIdentifier: "FaqViewControllerVCID", sender: nil)
		case 5:
			break
		case 6:
			self.performSegue(withIdentifier: "TermsAndConditionsPolicyID", sender: "Privacy Policy")
		case 7:
			self.performSegue(withIdentifier: "TermsAndConditionsPolicyID", sender: "Terms & Conditions")
		case 8:
			self.performSegue(withIdentifier: "ContactUSViewControllerSegue", sender: nil)
        default:
            print("default\n", terminator: "")
        }
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
//        sender.isEnabled = false
        sender.tag = 10
       
    
        let mainStoryBoard = UIStoryboard.init(name: "DashBoard", bundle: nil)
        let menuVC : MenuViewController = mainStoryBoard.instantiateViewController(withIdentifier:"MenuViewController") as! MenuViewController
        menuVC.btnMenu = sender
//        menuVC.delegate = self
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(menuVC.view)
        
        // self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
    }
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "TermsAndConditionsPolicyID"{
            let vc: TermsAndCondtionsAndPrivacyViewController = segue.destination as! TermsAndCondtionsAndPrivacyViewController
            if sender as? String == "Terms & Conditions"{
                vc.isClickedFrom = "Terms & Conditions"
            }
            else{
                vc.isClickedFrom = "Privacy Policy"
            }
        }
	}
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let storyboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let destViewController : UIViewController? = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        //destViewController?.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(destViewController!, animated: true)
    }
    
}
