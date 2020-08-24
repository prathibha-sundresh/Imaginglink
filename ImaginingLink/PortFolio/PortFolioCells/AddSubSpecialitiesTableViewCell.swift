//
//  AddSubSpecialitiesTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/11/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class AddSubSpecialitiesTableViewCell: UITableViewCell {
	@IBOutlet weak var addSubSpecialitiesTF: FloatingLabel!
	@IBOutlet weak var saveButton: UIButton!
	var delegate: AddSectionTvCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setUI() {
		saveButton.isEnabled = false
		saveButton.alpha = 0.5
		addSubSpecialitiesTF.text = ""
	}
	
	@IBAction func textFieldDidChange(_ textView: UITextField) {
		if addSubSpecialitiesTF.text != "" {
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		if addSubSpecialitiesTF.text! != "" {
			
			let requestDict = ["type" : "sub_speciality", "post_data[sub_speciality][]": addSubSpecialitiesTF.text!]
			delegate?.addSection(dict: requestDict)
		}
	}
}
