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
            
        menuCell.selectionStyle = UITableViewCell.SelectionStyle.none
            tableviewcell = menuCell

        return tableviewcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        if (indexPath.row == 4) {
            self.CloseMenuPressed(nil)
            CoreAPI.sharedManaged.logOut()
        } else {
            CloseMenuPressed(nil)
            delegate?.slideMenuItemSelectedAtIndex(indexPath.row)
        }
       
        
    }
    
    var imagelist = ["InviteFriendsICon", "ChangePasswordIcon", "TwoFactorAuthenticationMenuIcon", "ChangeEmailIcon", "logoutIcon"]
    var textlist = ["INVITE FRIENDS", "CHANGE PASSWORD", "2 FACTOR AUTHENTICATION", "CHANGE EMAIL", "LOGOUT"]
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.tableFooterView = UIView(frame: CGRect.zero)
        addShadowView()
        self.delegate = self
        addSlideMenuButton(showBackButton: false, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kUserName) as! String)")
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
    
    func addShadowView() {
        menuView.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = 10
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
            self.removeFromParent()
        })
    }
}
