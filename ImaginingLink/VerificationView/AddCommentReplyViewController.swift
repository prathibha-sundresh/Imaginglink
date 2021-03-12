//
//  AddCommentReplyViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/10/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class AddCommentReplyViewController: UIViewController {
	@IBOutlet weak var headerTitleLabel: UILabel!
	var parentCommentID: String = ""
	var isFrom: String = ""
	var messageStr: String = ""
	@IBOutlet weak var commentReplyTextView: UITextView!
	@IBOutlet weak var commentReplySubmitButton: UIButton!
	var callBack: ((_ replyMessage: String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
		commentReplySubmitButton.backgroundColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00)
		if isFrom == "GroupDiscussion" {
			headerTitleLabel.text = "Edit Discription"
		}
		else if isFrom == "Manage Post" {
			headerTitleLabel.text = "Reason for Rejection"
			commentReplySubmitButton.setTitle("Reject Request", for: .normal)
			commentReplySubmitButton.backgroundColor = UIColor(red: 0.98, green: 0.39, blue: 0.33, alpha: 1.00)
		}
		else {
			headerTitleLabel.text = "Add New Comment"
		}
		
		commentReplyTextView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		commentReplyTextView.text = messageStr
		commentReplySubmitButton.isEnabled = false
		commentReplySubmitButton.alpha = 0.6
		commentReplyTextView.layer.borderWidth = 1.0
        commentReplyTextView.layer.borderColor = UIColor(red:0.73, green:0.80, blue:0.83, alpha:1.0).cgColor
        commentReplyTextView.layer.cornerRadius = 2.0
        // Do any additional setup after loading the view.
    }
    
	@IBAction func commentViewCancelOrSubmitAction(_ sender: UIButton){
		if sender.tag == 2000 {
			if commentReplyTextView.text != ""{
				if let callback = callBack{
					callback(commentReplyTextView.text!)
				}
			}
		}
		self.dismiss(animated: false, completion: nil)
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
extension AddCommentReplyViewController: UITextViewDelegate{
	func textViewDidChange(_ textView: UITextView) {
		if textView == commentReplyTextView{
			if textView.text != ""{
				commentReplySubmitButton.isEnabled = true
				commentReplySubmitButton.alpha = 1.0
			}
			else{
				commentReplySubmitButton.isEnabled = false
				commentReplySubmitButton.alpha = 0.6
			}
		}
	}
}
