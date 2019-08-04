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
        backButton.frame = CGRect(x: 0, y: 5, width: self.view.frame.width / 2, height: 50)
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        
        if (showBackButton == true) {
             backButton.setImage(UIImage(named: "BackButtonIcon"), for: UIControlState.normal)
            backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        }
        let attributes = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 12.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 116.0/255.0, green: 116.0/255.0, blue: 116.0/255.0, alpha: 1)]
        let attributesForBold = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Semibold", size: 18.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1)]
        let userName = UserDefaults.standard.value(forKey: kUserName) as! String
        let range = NSRange(location: 0, length: userName.count)
        let str1 = NSMutableAttributedString(string: backbuttonTitle, attributes: attributes)
        str1.addAttributes(attributesForBold, range: range)
        backButton.setAttributedTitle(str1, for: .normal)
        //backButton.setTitle(backbuttonTitle, for: UIControlState.normal)
//        backButton.setTitle("\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kUserType) as! String)", for: .normal)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.titleLabel?.lineBreakMode = .byWordWrapping
        backButton.titleLabel?.numberOfLines = 0
        backButton.contentHorizontalAlignment = .left
        backButton.setTitleColor(UIColor(red: 80.0/255.0, green: 88.0/255.0, blue: 93.0/255.0, alpha: 1), for: .normal)
        backButton.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        backButton.addTarget(self, action: #selector(BaseHamburgerViewController.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButtonType.custom)
        btnShowCart.backgroundColor = UIColor.clear
        btnShowCart.setImage(UIImage(named: "MenuIcon"), for: UIControlState.normal)
        btnShowCart.frame = CGRect(x: self.view.frame.width - 60, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(BaseHamburgerViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
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
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("InviteFriendsViewController")
            
            break
        case 1:
            print("My UFS\n", terminator: "")
            
//            if (getTopViewController() is WSFavouriteShoppingListViewController ) || (getTopViewController() is WSRecipeOverViewViewController ) || (getTopViewController() is SearchViewController ){
//                self.tabBarController?.selectedIndex = 0
//                return
//            }
            
            
            self.openViewControllerBasedOnIdentifier("ResetPasswordWithMenuViewController")
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("TwofactorAuthenticationViewController")
            break
        case 3:
            print("Scan\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ChangeEmailViewController")
            
            break
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
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let storyboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let destViewController : UIViewController? = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        //destViewController?.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(destViewController!, animated: true)
    }
    
}
