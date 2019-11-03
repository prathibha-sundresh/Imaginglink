//
//  PublishStepOneViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/18/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class PublishStepOneViewController: UIViewController {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var selectedTapXCon: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        shadowView.layer.shadowColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.0).cgColor
        shadowView.layer.shadowOpacity = 1.0
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowRadius = 2
        selectedTapXCon.constant = self.view.frame.width / 3
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
