//
//  UpdatePresentationViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/20/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class UpdatePresentationViewController: UIViewController {

    @IBOutlet weak var commentsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        commentsTextView.layer.borderWidth = 1.0
        commentsTextView.layer.borderColor = UIColor(red:0.73, green:0.80, blue:0.83, alpha:1.0).cgColor
        commentsTextView.layer.cornerRadius = 4.0
        commentsTextView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitForReviewBtnAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FinalSubmissionVCID", sender: nil)
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
