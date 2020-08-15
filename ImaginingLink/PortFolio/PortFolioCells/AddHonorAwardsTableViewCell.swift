//
//  AddHonorAwardsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/15/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol AddHonorAwardsTvCellDelegate {
	func addHonorAwards(dict: [String: Any])
}

class AddHonorAwardsTableViewCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	
	@IBOutlet weak var titleTF: FloatingLabel!
	@IBOutlet weak var awardedForTF: FloatingLabel!
	@IBOutlet weak var awardedByTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	var delegate: AddHonorAwardsTvCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI() {
		titleTF.text = ""
		awardedForTF.text = ""
		awardedByTF.text = ""
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		let requestDict = [
		"type":"honor_awards",
		"post_data[title]":titleTF.text!,
		"post_data[awarded_for]":awardedForTF.text!,
		"post_data[awarded_by]": awardedByTF.text!,
		"post_data[dd]":startDateTF.text!,
		"post_data[mm]":startMonthTF.text!,
		"post_data[yy]":startYearTF.text!,
		"post_data[status]":false] as [String : Any]
		delegate?.addHonorAwards(dict: requestDict)
	}
}

extension AddHonorAwardsTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}
