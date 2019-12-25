//
//  SendCommentTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 12/8/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

@objc protocol SendCommentDelegate {
	@objc func callPresentationAPI(dataArray: [[String: Any]])
//	func updatePresentationDict(dict: [String: Any])
//	@objc optional func clickOnCommentButton(isSelected: Bool)
}

class SendCommentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBOutlet weak var Textview: SZTextView!
	var myViewcontroller: UIViewController?
	var delegate: SendCommentDelegate?
	var presentationID: String = ""
	
	@IBAction func SendComment(_ sender: Any) {
        if (Textview.text!.count != 0) {
            //delegate?.sendCommentsToAPI(comments: Textview.text!)
			ILUtility.showProgressIndicator(controller: myViewcontroller!)
			CoreAPI.sharedManaged.requestForcomments(comment: Textview.text!, parentcommentid: "0", commentedcondition: "REVIEW", presentationid: presentationID, successResponse: {(response) in
				ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
				
				if let array = response["data"] as? [[String: Any]] {
					self.delegate?.callPresentationAPI(dataArray: array)
				}
				
			}, faliure: {(error) in
				ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
			})
            Textview.text = ""
        }
    }
	
	func setUI(id: String) {
		presentationID = id
		Textview.layer.borderWidth = 1.0
		Textview.layer.borderColor = UIColor(red:0.73, green:0.80, blue:0.83, alpha:1.0).cgColor
		Textview.layer.cornerRadius = 18.0
		Textview.clipsToBounds = true
		Textview.placeholder = "Write your comment"
		Textview.placeholderTextColor = UIColor(red:0.43, green:0.50, blue:0.53, alpha:1.0)
		Textview.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
	}
	
}
