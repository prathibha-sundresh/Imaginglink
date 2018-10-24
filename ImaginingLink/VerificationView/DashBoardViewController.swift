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
        let storyboard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ILTabViewController") as! ILTabViewController
        var navController = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navController, animated: true, completion: nil)
        //            self.navigationController?.pushViewController(vc, animated: true)
        CoreAPI.sharedManaged.getPublicUserPresentation(successResponse: {(response) in
            
            
            //            let storyboard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            //            let vc = storyboard.instantiateViewController(withIdentifier: "PresentationViewController") as! PresentationViewController
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            CoreAPI.sharedManaged.getPublicUserPresentation(successResponse: {(response) in
            
        }, faliure: {(error) in
            
        })
    }
    
    @IBAction func SocialNetworkIconPressed(_ sender: Any) {
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
//        ILUtility.addNavigationBarBackButton(controller: self, userName: UserDefaults.standard.value(forKey: kUserName) as! String, userType: "Radiologist")
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
