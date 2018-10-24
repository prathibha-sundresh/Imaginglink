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
//        self.slidingViewController().topViewController.view.layer.shadowOpacity = 0.8
//        self.slidingViewController().topViewController.view.layer.shadowRadius  = 4.0
//        self.slidingViewController().topViewController.view.layer.shadowColor   = UIColor.black.cgColor
//        self.slidingViewController().topViewController.view.layer.shadowPath    = UIBezierPath(rect: self.view.bounds).cgPath //[UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
//        self.slidingViewController().topViewController.view.clipsToBounds = false
//
//        self.edgesForExtendedLayout = UIRectEdge()
//        self.extendedLayoutIncludesOpaqueBars = false
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMenu))
//
//        self.navigationItem.leftBarButtonItem?.accessibilityLabel = "hamburgerMenuButton"
    }
    
    override func viewDidLayoutSubviews() {
//        self.slidingViewController().topViewController.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
    }
    
    @objc func showMenu()  {
//        if (self.slidingViewController().currentTopViewPosition == ECSlidingViewControllerTopViewPosition.centered) {
//            self.slidingViewController().anchorTopViewToRight(animated: true, onComplete: nil)
//        } else {
//            self.slidingViewController().resetTopView(animated: true, onComplete: nil)
//        }
        
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(#imageLiteral(resourceName: "MenuIcon") , for: UIControlState())
        btnShowMenu.frame = CGRect(x: self.view.frame.width - 45, y: 0, width: 30, height: 30)
//        btnShowMenu.tag = 10
        btnShowMenu.addTarget(self, action: #selector(BaseHamburgerViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.rightBarButtonItem = customBarItem;
        
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
            
            
            self.openViewControllerBasedOnIdentifier("InviteFriendsViewController")
            break
        case 2:
            self.openViewControllerBasedOnIdentifier("ChefRewardLandingID")
            break
        case 3:
            print("Scan\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("ScanVCID")
            
            break
        case 4:
            print("Notifications", terminator: "")
            self.openViewControllerBasedOnIdentifier("MyNotificationViewControllerID")
            
            break
        case 5:
            print("Order History", terminator: "")
            break
        case 6:
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
        
        // for DTO
//        UserDefaults.standard.set(false, forKey: "isFromLoginForDTO")
//
//        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//            sender.isEnabled = true
//        }, completion:nil)
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let storyboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let destViewController : UIViewController? = storyboard.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController? = self.navigationController!.topViewController!
        
        if (topViewController!.restorationIdentifier == destViewController!.restorationIdentifier){
            print("Same VC")
        } else {
            // destViewController?.hidesBottomBarWhenPushed = true
            //self.navigationController?.popToViewController(topViewController, animated: false)
            self.navigationController!.pushViewController(destViewController!, animated: true)
        }
    }
    
}
