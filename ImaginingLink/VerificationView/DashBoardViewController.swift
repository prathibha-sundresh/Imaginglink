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
    
    @IBAction func CasesIconPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ComingSoon", sender: Cases)
    }
    @IBAction func QuizIconPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ComingSoon", sender: Quiz)
    }
    @IBAction func PortpolioIconPresses(_ sender: Any) {
        self.performSegue(withIdentifier: "ComingSoon", sender: Portfolio)
    }
    @IBAction func PresentationIconPressed(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "DashBoard", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PresentationViewController") as! PresentationViewController
        vc.isFromPresentations = true
        self.navigationController?.pushViewController(vc, animated: true)
//    self.tabBarController?.selectedIndex = 0
    }
    func addShadowToButton(button: UIButton) {
        button.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 4.0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ComingSoon"{
            let vc: ComingSoonViewController = segue.destination as! ComingSoonViewController
            let type = sender as? Int ?? 0
            if type == 0{
                vc.typeOfVC = ComingSoonViewController.ComingSoon.Cases
            }
            else if type == 1{
                vc.typeOfVC = ComingSoonViewController.ComingSoon.Quiz
            }
            else if type == 2{
                vc.typeOfVC = ComingSoonViewController.ComingSoon.Portfolio
            }
            else if type == 3{
                vc.typeOfVC = ComingSoonViewController.ComingSoon.SocialConnect
            }
        }
    }
    
    
    @IBAction func SocialNetworkIconPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ComingSoon", sender: SocialConnect)
    }
    
    @IBAction func publishIconPressed(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for tagValue in 1001..<1007{
            addShadowToButton(button: self.view.viewWithTag(tagValue) as! UIButton)
        }
//        ILUtility.addNavigationBarBackButton(controller: self, userName: UserDefaults.standard.value(forKey: kUserName) as! String, userType: "Radiologist")
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(true, forKey: kLoggedIn)
        addSlideMenuButton(showBackButton: false, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
    }
    
}
