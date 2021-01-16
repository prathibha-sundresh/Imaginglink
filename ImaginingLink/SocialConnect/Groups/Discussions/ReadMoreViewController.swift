//
//  ReadMoreViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/15/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class ReadMoreViewController: UIViewController {
	@IBOutlet weak var readMoreTextLabel: UILabel!
	var readMoreText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
		readMoreTextLabel.text = readMoreText
        // Do any additional setup after loading the view.
    }
    
	@IBAction func closeButtonAction(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
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
