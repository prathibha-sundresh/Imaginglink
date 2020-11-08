//
//  PublicOrPrivateProfolioVC.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class PublicOrPrivateProfolioVC: UIViewController {
	@IBOutlet weak var privateView: UIView!
	@IBOutlet weak var publicView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
		privateView.layer.borderWidth = 1.0
		privateView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		privateView.clipsToBounds = true
		
		publicView.layer.borderWidth = 1.0
		publicView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		publicView.clipsToBounds = true
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

	@IBAction func privateViewButtonAction(_ sender: UIButton) {
		
	}
	
	@IBAction func publicViewButtonAction(_ sender: UIButton) {
		
	}
}
