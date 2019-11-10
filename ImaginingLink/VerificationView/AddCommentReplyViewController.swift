//
//  AddCommentReplyViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/10/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class AddCommentReplyViewController: UIViewController {
	var parentCommentID: String = ""
	@IBOutlet weak var commentReplyTextView: UITextView!
	@IBOutlet weak var commentReplySubmitButton: UIButton!
	var callBack: ((_ replyMessage: String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
		commentReplyTextView.text = ""
		commentReplySubmitButton.isEnabled = false
		commentReplySubmitButton.alpha = 0.6
		commentReplyTextView.layer.borderWidth = 1.0
        commentReplyTextView.layer.borderColor = UIColor(red:0.73, green:0.80, blue:0.83, alpha:1.0).cgColor
        commentReplyTextView.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }
    
	@IBAction func commentViewCancelOrSubmitAction(_ sender: UIButton){
		if commentReplyTextView.text != ""{
			if let callback = callBack{
				callback(commentReplyTextView.text!)
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
