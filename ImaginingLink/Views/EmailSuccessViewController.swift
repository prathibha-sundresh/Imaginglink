//
//  EmailSuccessViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 04/06/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class EmailSuccessViewController: UIViewController {
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self,  selector: #selector(callSignUp), userInfo:nil, repeats: true)
    }

    @objc func callSignUp() {
        timer?.invalidate()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SignUpViewcontroller") as! SignUpViewcontroller
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
