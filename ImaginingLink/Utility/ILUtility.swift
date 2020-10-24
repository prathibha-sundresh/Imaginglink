//
//  ILUtility.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 06/08/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import MessageBanner

class ILUtility : NSObject {
    
    enum MessageBanner {
    case InAppNotificationRed
    case InAppNotificationYellow
    case InAppNotificationBlue
    }
    
    enum InAppNotificationDuration {
    case DurationShort
    case DurationLong
    case DurationExtraLong
    } ;
    
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
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        backButton.setTitleColor(UIColor(red: 80.0/255.0, green: 88.0/255.0, blue: 93.0/255.0, alpha: 1), for: .normal)
        backButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 17)
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButton.ButtonType.custom)
        btnShowCart.backgroundColor = UIColor.clear
        btnShowCart.setImage(UIImage(named: "MenuIcon"), for: UIControl.State.normal)
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(addMenuViewcontroller), for: UIControl.Event.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        controller.navigationItem.rightBarButtonItem = customRightBarItem;

    }
    
    class func addNavigationBarBackButtonWithOuttitle(controller:UIViewController) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        backButton.setImage(UIImage(named: "BackButtonIcon"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
       
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        //        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let btnShowCart = UIButton(type: UIButton.ButtonType.custom)
        btnShowCart.backgroundColor = UIColor.clear
        btnShowCart.setImage(UIImage(named: "MenuIcon"), for: UIControl.State.normal)
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnShowCart.contentMode = .scaleAspectFit
        btnShowCart.addTarget(self, action: #selector(addMenuViewcontroller), for: UIControl.Event.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        controller.navigationItem.rightBarButtonItem = customRightBarItem;
        
    }
    
    class func addNavigationBarBackToCartButton(controller:UIViewController) {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 35)
        backButton.setImage(UIImage(named: "MenuIcon"), for: .normal)
//        backButton.setTitle(WSUtility.getlocalizedString(key: "Back to cart", lang: WSUtility.getLanguage(), table: "Localizable"), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        backButton.setTitleColor(ApplicationOrangeColor, for: .normal)
        backButton.titleLabel?.font = UIFont(name: "DINPro-Regular", size: 12)
        backButton.addTarget(controller, action: #selector(self.backAction(_:)), for: .touchUpInside)
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        
    }
    
   class func isValidPassword(_ passwordString: String?) -> Bool {
        
//        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#%!$@^*()_.])[A-Za-z\\d#%!$@^*()_.]{8,}"
        let regex = "^(?=.*[#%!&$@~^*()_.])[A-Za-z\\d#%!&$@~^*()_.]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
        
        let isValid: Bool = passwordTest.evaluate(with: passwordString)
        
        return isValid
    }
    
   class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func addSlideMenuButton(viewcontroller:UIViewController){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.backgroundColor = UIColor.clear
        btnShowMenu.setImage(UIImage(named: "MenuIcon"), for: UIControl.State.normal)
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        viewcontroller.navigationItem.leftBarButtonItem = customBarItem;
        
        let btnShowCart = UIButton(type: UIButton.ButtonType.system)
        btnShowCart.setImage(#imageLiteral(resourceName: "WebShop-ShoppingCart"), for: UIControl.State())
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
    
    class func showToastMessage(toViewcontroller : UIViewController, statusToDisplay: String) -> Void {
        let spinnerActivity = MBProgressHUD.showAdded(to: toViewcontroller.view, animated: true);
        spinnerActivity.hide(animated: true, afterDelay: 1)
        spinnerActivity.detailsLabel.text = statusToDisplay;
        spinnerActivity.isUserInteractionEnabled = false;
    }
    
    class func showInAppNotification(withTitle title: String?) {
        if title == nil || (title?.count ?? 0) == 0 {
            return
        }
        let style = MBLMessageBannerType.warning
//        if type == MessageBanner.InAppNotificationRed {
//            style = MBLMessageBannerType.error
//        } else if type == MessageBanner.InAppNotificationYellow {
//            style = MBLMessageBannerType.warning
//        } else if type == MessageBanner.InAppNotificationBlue {
//            style = MBLMessageBannerType.message
//        }
        
//        let topWindow: UIWindow? = UIApplication.topViewController()
        
        let controller: UIViewController? =  UIApplication.topViewController()
        
        //    [MBLMessageBanner setMessageBannerDelegate:self];
//        MBLMessageBanner.show(in: controller, title: title, subtitle: nil, type: style, duration: 2, userDissmissedCallback: { message in
//
//        }, at: MBLMessageBannerPosition.bottom, canBeDismissedByUser: true)
        
        MBLMessageBanner.show(in: controller, title: title!, subtitle: nil, image: nil, type: MBLMessageBannerType.warning, duration: 2, userDissmissedCallback: {(message) in
           
        }, buttonTitle: nil, userPressedButtonCallback: {(banner) in
            MBLMessageBanner.hide(completion: {
                    print("Dismissed")
                })
                return
        }, at: MBLMessageBannerPosition.bottom, canBeDismissedByUser: true, delegate: nil)
//        MBLMessageBanner.showMessageBanner(in: controller, title: title, subtitle: title, type: MBLMessageBannerType.warning, at: MBLMessageBannerPosition.bottom)
        
//        MBLMessageBanner.show(inViewController: controller, title: title, subtitle: nil, image: iconImage, type: style, duration: 2, userDissmissedCallback: { message in
//
//        }, userPressedButtonCallback: { banner in
//
//            MBLMessageBanner.hide(withCompletion: {
//                print("Dismissed")
//            })
//            return
//        }, atPosition: MBLMessageBannerPosition.bottom, canBeDismissedByUser: true, delegate: nil)
        
    }
    class func showAlertWithCallBack(title:String = "Imaginglink", message: String, controller: UIViewController, success:@escaping () -> Void) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertContoller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            success()
        }))
        controller.present(alertContoller, animated: true, completion: nil)
    }
    
    class func showAlert(title:String = "Imaginglink", message: String, controller: UIViewController) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertContoller.addAction(alertAction)
        controller.present(alertContoller, animated: true, completion: nil)
    }
    class func showProgressIndicator(controller: UIViewController){
        MBProgressHUD.showAdded(to: controller.view, animated: true)
    }
    class func hideProgressIndicator(controller: UIViewController){
        MBProgressHUD.hide(for: controller.view, animated: true)
    }
    class func getValueFromUserDefaults(key: String) -> String{
        return UserDefaults.standard.value(forKey: key) as? String ?? ""
    }
    class func clearUserDefaults(){
        UserDefaults.standard.set(false, forKey: kLoggedIn)
        UserDefaults.standard.set(false, forKey: kTwoFactorAuthentication)
        UserDefaults.standard.set(nil, forKey: kUserType)
        UserDefaults.standard.set(nil, forKey: kToken)
        UserDefaults.standard.setValue(nil, forKey: kAuthenticatedEmailId)
        UserDefaults.standard.set(nil, forKey: kFirstName)
        UserDefaults.standard.set(nil, forKey: kLastName)
        UserDefaults.standard.set(nil, forKey: kUserName)
        UserDefaults.standard.set(nil, forKey: OTP_Value)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UIViewController {
    
    func showToast(message : String, _ error: Bool = false ,_ value: CGFloat = 50) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height - value, width: self.view.frame.width, height: 50))
        if error{
            toastLabel.backgroundColor = UIColor.red
        }
        else{
            toastLabel.backgroundColor = UIColor(red: 6.0/255.0, green: 170.0/255.0, blue: 99.0/255.0, alpha: 1)
        }
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
