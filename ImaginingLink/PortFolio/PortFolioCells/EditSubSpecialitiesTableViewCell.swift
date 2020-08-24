//
//  EditSubSpecialitiesTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/11/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class EditSubSpecialitiesTableViewCell: UITableViewCell {

	@IBOutlet weak var subSpecialitiesTF: FloatingLabel!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var saveButtonH: NSLayoutConstraint!
	var delegate: EditSectionTvCellDelegate?
	var isEditForSubSpecialties: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI(dict: [String : Any], btnTag: Int) {
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		saveButtonH.constant = isEditForSubSpecialties ? 36 : 0
		editButton.isHidden = isEditForSubSpecialties
		subSpecialitiesTF.isUserInteractionEnabled = isEditForSubSpecialties
		subSpecialitiesTF.setRightPaddingPoints(50)
		let subSpecialities = dict["sub_speciality"] as? [String] ?? []
		subSpecialitiesTF.text = subSpecialities.joined(separator: ",")
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		if subSpecialitiesTF.text! != "" {
//			let tmpArray = subSpecialitiesTF.text!.split(separator: ",")
//			var requestDict = ["type" : "sub_speciality"]
//			for i in 0 ..< tmpArray.count {
//				requestDict["post_data[sub_speciality][\(i)]"] = "\(tmpArray[i])"
//			}
			let requestDict = ["type" : "sub_speciality", "post_data[sub_speciality][]": subSpecialitiesTF.text!]
			delegate?.saveSection(dict: requestDict, at: sender.tag)
		}
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : "sub_speciality","status":"delete"], at: sender.tag)
	}
}
