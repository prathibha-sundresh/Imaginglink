//
//  AddCommitteesTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/20/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol AddSectionTvCellDelegate {
	func addSection(dict: [String: Any])
}

class AddCommitteesTableViewCell: UITableViewCell {
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var endMonthTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var notifyMeButton: UIButton!
	@IBOutlet weak var committeePositionTF: FloatingLabel!
	@IBOutlet weak var typeTF: FloatingLabel!
	@IBOutlet weak var committeeNameTF: FloatingLabel!
	@IBOutlet weak var locationTF: FloatingLabel!
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
		committeePositionTF.text = ""
		typeTF.text = ""
		committeeNameTF.text = ""
		locationTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		endMonthTF.text = ""
		endYearTF.text = ""
		notifyMeButton.isSelected = false
	}
	
	@IBAction func notifyMeAction(_ sender: UIButton) {
		notifyMeButton.isSelected = !sender.isSelected
	}

	@IBAction func saveButtonAction(_ sender: UIButton) {
		let notifyMe = notifyMeButton.isSelected ? "True" : "False"
		let requestDict = [
		"type":"committees",
		"post_data[committee_position]":committeePositionTF.text!,
		"post_data[type]":typeTF.text!,
		"post_data[committee_name]": committeeNameTF.text!,
		"post_data[location]": locationTF.text!,
		"post_data[currently_pursuing]":notifyMe,
		"post_data[date_from][mm]":startMonthTF.text!,
		"post_data[date_from][yy]":startYearTF.text!,
		"post_data[date_to][mm]":endMonthTF.text!,
		"post_data[date_to][yy]":endYearTF.text!,
		"post_data[status]":false] as [String : Any]
		delegate?.addSection(dict: requestDict)
	}
}

extension AddCommitteesTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}
