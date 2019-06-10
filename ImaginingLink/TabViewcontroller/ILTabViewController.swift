//
//  ILTabViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 17/08/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class ILTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        addSlideMenuButton()
//        setupMiddleButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//       addSlideMenuButton()
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.white
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        menuButton.layer.borderColor = UIColor.clear.cgColor
        menuButton.layer.borderWidth = 1
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "home_tab_bar"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
    }

    
    func addSlideMenuButton(){
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 5, width: self.view.frame.width / 2, height: 50)
//        backButton.setImage(UIImage(named: "BackButtonIcon"), for: .normal)
        backButton.setTitle("\(UserDefaults.standard.value(forKey: kUserName) as! String) \n \(UserDefaults.standard.value(forKey: kUserType) as! String)", for: .normal)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.titleLabel?.lineBreakMode = .byWordWrapping
        backButton.titleLabel?.numberOfLines = 0
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        backButton.setTitleColor(UIColor(red: 80.0/255.0, green: 88.0/255.0, blue: 93.0/255.0, alpha: 1), for: .normal)
        backButton.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        backButton.addTarget(self, action: #selector(ILTabViewController.backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButtonType.custom)
        btnShowCart.backgroundColor = UIColor.clear
        btnShowCart.setImage(UIImage(named: "MenuIcon"), for: UIControlState.normal)
        btnShowCart.frame = CGRect(x: self.view.frame.width - 60, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(ILTabViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        self.navigationItem.rightBarButtonItem = customRightBarItem;
        
    }
    
    @objc func backAction() {
//        self.navigationController?.popViewController(animated: true)
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
        self.navigationController!.pushViewController(destViewController!, animated: true)
    }

    //
}
