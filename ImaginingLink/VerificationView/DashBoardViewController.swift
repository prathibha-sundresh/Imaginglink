//
//  DashBoardViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 24/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class DashBoardViewController:  BaseHamburgerViewController {
    let Cases = 0
    let Quiz = 1
    let Portfolio = 2
    let SocialConnect = 3
    let Presentation = 4
//  kUserName


    @IBAction func CasesIconPressed(_ sender: Any) {
    }
    @IBAction func QuizIconPressed(_ sender: Any) {
    }
    @IBAction func PortpolioIconPresses(_ sender: Any) {
    }
    @IBAction func PresentationIconPressed(_ sender: Any) {
        
        
        
        let storyBoard = UIStoryboard(name: "DashBoard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PresentationViewController") as! PresentationViewController
        self.navigationController?.pushViewController(vc, animated: true)

//    self.tabBarController?.selectedIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       

    }
    
    
    @IBAction func SocialNetworkIconPressed(_ sender: Any) {
    }
    
    @IBAction func publishIconPressed(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: false, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
//        ILUtility.addNavigationBarBackButton(controller: self, userName: UserDefaults.standard.value(forKey: kUserName) as! String, userType: "Radiologist")
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
