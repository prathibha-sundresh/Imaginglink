//
//  OptionTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/24/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit
protocol OptionTableViewCellDelegate {
	func updateAnswerText(text: String, at row: Int)
}

class OptionTableViewCell: UITableViewCell {
	var delegate: OptionTableViewCellDelegate?
	@IBOutlet weak var ansNumberLabel: UILabel!
	@IBOutlet weak var ansTextTF: UITextField!
	@IBOutlet weak var borderView: UIView!
	@IBOutlet weak var deleteButtonButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setUI(answer: String, row: Int, isEditMode: Bool) {
		borderView.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		if isEditMode {
			ansTextTF.text = answer
		}
		deleteButtonButton.tag = row
		ansTextTF.tag = row
		for (index,value) in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated() {
			if row == index {
				ansNumberLabel.text = "\(value)"
				break
			}
		}
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		delegate?.updateAnswerText(text: textField.text!, at: textField.tag)
	}
}
