//
//  ILUtility.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 06/08/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class ILUtility : NSObject {
    
    class func addNavigationBarBackButton(controller:UIViewController, userName : String, userType:String) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        backButton.setImage(UIImage(named: "BackButtonIcon"), for: .normal)
        backButton.setTitle("\(userName) \n \(userType)", for: .normal)
        print("\(userName)\(userType)")
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.titleLabel?.lineBreakMode = .byWordWrapping
        backButton.titleLabel?.numberOfLines = 0
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        backButton.setTitleColor(UIColor(red: 80.0/255.0, green: 88.0/255.0, blue: 93.0/255.0, alpha: 1), for: .normal)
        backButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 17)
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
//        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButtonType.custom)
        btnShowCart.setImage(#imageLiteral(resourceName: "MenuIcon"), for: UIControlState.normal)
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(addMenuViewcontroller), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        controller.navigationItem.rightBarButtonItem = customRightBarItem;

    }
    
    class func addNavigationBarBackButtonWithOuttitle(controller:UIViewController) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        backButton.setImage(UIImage(named: "BackButtonIcon"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
       
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        //        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButtonType.custom)
        btnShowCart.setImage(#imageLiteral(resourceName: "MenuIcon"), for: UIControlState.normal)
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(addMenuViewcontroller), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        controller.navigationItem.rightBarButtonItem = customRightBarItem;
        
    }
    
    class func addNavigationBarBackToCartButton(controller:UIViewController) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 35)
        backButton.setImage(UIImage(named: "MenuIcon"), for: .normal)
//        backButton.setTitle(WSUtility.getlocalizedString(key: "Back to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        backButton.setTitleColor(ApplicationOrangeColor, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "DINPro-Regular", size: 12)
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
    }
    
    func addSlideMenuButton(viewcontroller:UIViewController){
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(UIImage(named:"MenuIcon") , for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        viewcontroller.navigationItem.leftBarButtonItem = customBarItem;
        
        let btnShowCart = UIButton(type: UIButtonType.system)
        btnShowCart.setImage(#imageLiteral(resourceName: "WebShop-ShoppingCart"), for: UIControlState())
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        btnShowCart.addTarget(self, action: #selector(BaseViewController.cartButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        viewcontroller.navigationItem.rightBarButtonItem = customRightBarItem;
        
        let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 63, height: 25))
        logoImage.image = UIImage(named: "UFS_Logotype_RGB")
        logoImage.contentMode = .scaleAspectFit
        logoImage.autoresizingMask = .flexibleWidth
        viewcontroller.navigationItem.titleView = logoImage
        
        
    }
    
    @objc class func addMenuViewcontroller() {
        
    }
    
    class func showToastMessage(toViewcontroller : UIViewController, statusToDisplay: String, MessageToDisplay : String) -> Void {
        let spinnerActivity = MBProgressHUD.showAdded(to: toViewcontroller.view, animated: true);
        spinnerActivity.hide(animated: true, afterDelay: 1)
        spinnerActivity.label.text = MessageToDisplay;
        
        spinnerActivity.detailsLabel.text = statusToDisplay;
        
        spinnerActivity.isUserInteractionEnabled = false;
    }
    

}
