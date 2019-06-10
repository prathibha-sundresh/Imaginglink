//
//  FinalLoginViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 31/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class FinalLoginViewController : UIViewController {
    @IBAction func LoginPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
