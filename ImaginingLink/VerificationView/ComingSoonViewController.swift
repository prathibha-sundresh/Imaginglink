//
//  ComingSoonViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/20/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class ComingSoonViewController: BaseHamburgerViewController {
    enum ComingSoon{
        case Cases
        case Quiz
        case Portfolio
        case SocialConnect
		case Publish
        case Folio
    }
    var typeOfVC = ComingSoon.Cases
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch typeOfVC {
        case .Cases:
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Cases")
        case .Quiz:
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Quiz")
        case .Portfolio:
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Portfolio")
        case .SocialConnect:
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Social Connect")
		case .Publish:
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Publish")
        case .Folio:
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Folio")
        }
		
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
