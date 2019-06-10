//
//  MenuViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 08/08/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MenuViewController: BaseHamburgerViewController, UITableViewDelegate, UITableViewDataSource, SlideMenuDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textlist.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        CloseMenuPressed(nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableviewcell = UITableViewCell()
           let menuCell : MenuViewcontrollerTableCell = tableView.dequeueReusableCell(withIdentifier: "MenuViewId", for: indexPath) as! MenuViewcontrollerTableCell
            menuCell.iconImageView.image = UIImage(named: imagelist[indexPath.row])
            menuCell.MenuTextLabel.text = textlist[indexPath.row]
            
            menuCell.selectionStyle = UITableViewCellSelectionStyle.none
            tableviewcell = menuCell

        return tableviewcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        if (indexPath.row == 4) {
            
            CoreAPI.sharedManaged.requestLogout(successResponse: {(response) in
                self.CloseMenuPressed(nil)
                let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.openRegularSignIn()
            }, faliure: {(error) in
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            })
        } else {
            CloseMenuPressed(nil)
            delegate?.slideMenuItemSelectedAtIndex(indexPath.row)
        }
       
        
    }
    
    var imagelist = ["InviteFriendsICon", "ChangePasswordIcon", "TwoFactorAuthenticationMenuIcon", "ChangeEmailIcon", "logoutIcon"]
    var textlist = ["INVITE FRIENDS", "CHANGE PASSWORD", "2 FACTOR AUTHENTICATION", "CHANGE EMAIL", "LOGOUT"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        addSlideMenuButton(showBackButton: false, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    
    var delegate : SlideMenuDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func CloseMenuPressed(_ button:UIButton!) {
        btnMenu.tag = 0
        
        if (self.delegate != nil && button != nil) {
            var index = Int(button.tag)
                index = -1
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
}
