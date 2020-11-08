//
//  SummaryTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/4/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

protocol SummaryTableViewCellDelegate {
	func saveSummaryText(dict: [String: Any])
}

class SummaryTableViewCell: UITableViewCell,UITextViewDelegate {
	@IBOutlet weak var summaryTextView: SZTextView!
	@IBOutlet weak var summarySaveButton: UIButton!
	var post_id: String?
	var delegate: SummaryTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI(dict: [String : Any]) {
		
		let tmpDict = dict["overview"] as? [String: Any] ?? [:]
		if tmpDict.keys.count == 0 {
			// add summary
			post_id = ""
		}
		else {
			// edit summary
			post_id = dict["_id"] as? String ?? ""
		}
		summaryTextView.text = tmpDict["data"] as? String ?? ""
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		self.clipsToBounds = true
		
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		if summaryTextView.text! != "" {
			var requestDict = ["type" : "overview", "post_data": summaryTextView.text!]
			if post_id != "" {
				requestDict["post_id"] = post_id
			}
			delegate?.saveSummaryText(dict: requestDict)
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
		if textView.text != "" {
			summarySaveButton.isEnabled = true
			summarySaveButton.alpha = 1.0
		}
		else {
			summarySaveButton.isEnabled = false
			summarySaveButton.alpha = 0.5
		}
	}
}
