//
//  PresentationView.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 27/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class PresentationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PresenationTableView: UITableView!
    let presentationArray : [[String:Any]]? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let tableviewcell = tableView.dequeueReusableCell(withIdentifier: "PresentationTableViewCell", for: indexPath) as! PresentationTableViewCell
        tableviewcell.selectionStyle = UITableViewCellSelectionStyle.none
        return tableviewcell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         PresenationTableView.dataSource = self
        PresenationTableView.delegate = self
        addSlideMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ILUtility.addNavigationBarBackToCartButton(controller: self)
        ILUtility.addNavigationBarBackButton(controller: self, userName: "prathibha", userType: "Radiologist")
    }
    
    func addSlideMenuButton(){
//        let btnShowMenu = UIButton(type: UIButtonType.system)
//        btnShowMenu.setImage(#imageLiteral(resourceName: "MenuIcon"), for: UIControlState.normal)
//        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
////        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
//        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
//        self.navigationItem.leftBarButtonItem = customBarItem;
        
        let btnShowCart = UIButton(type: UIButtonType.system)
        btnShowCart.setImage(#imageLiteral(resourceName: "MenuIcon"), for: UIControlState())
        btnShowCart.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        btnShowCart.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        btnShowCart.addTarget(self, action: #selector(BaseViewController.cartButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customRightBarItem = UIBarButtonItem(customView: btnShowCart)
        self.navigationItem.rightBarButtonItem = customRightBarItem;
        
//        let logoImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 63, height: 25))
//        logoImage.image = UIImage(named: "UFS_Logotype_RGB")
//        logoImage.contentMode = .scaleAspectFit
//        logoImage.autoresizingMask = .flexibleWidth
//        self.navigationItem.titleView = logoImage
        
        
    }
    
}
