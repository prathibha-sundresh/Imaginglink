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
        if (section == 0) {
            return 4
        } else if (section == 1) {
            return 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableviewcell = UITableViewCell()
        if (indexPath.section == 0) {
           let menuCell : MenuViewcontrollerTableCell = tableView.dequeueReusableCell(withIdentifier: "MenuViewId", for: indexPath) as! MenuViewcontrollerTableCell
            menuCell.iconImageView.image = UIImage(named: imagelist[indexPath.row])
            menuCell.MenuTextLabel.text = textlist[indexPath.row]
            
            menuCell.selectionStyle = UITableViewCellSelectionStyle.none
            tableviewcell = menuCell
        } else if (indexPath.section == 1) {
//             tableviewcell = tableView.dequeueReusableCell(withIdentifier: "LogoutId", for: indexPath)
            
        }
        return tableviewcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.slideMenuItemSelectedAtIndex(indexPath.row)
    }
    
    var imagelist = ["InviteFriendsICon", "ChangePasswordIcon", "TwoFactorAuthenticationMenuIcon", "ChangeEmailIcon"]
    var textlist = ["INVITE FRIENDS", "CHANGE PASSWORD", "2 FACTOR AUTHENTICATION", "CHANGE EMAIL"]
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        self.delegate = self
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
        
        if (self.delegate != nil) {
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
