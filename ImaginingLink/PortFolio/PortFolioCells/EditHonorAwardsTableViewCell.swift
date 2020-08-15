//
//  EditHonorAwardsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/15/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
protocol EditHonorAwardsTvCellDelegate {
	func saveHonorAwards(dict: [String: Any], at index: Int)
	func deleteHonorAwards(dict: [String : Any], at index: Int)
	func editHonorAwards(at index: Int)
	func cancelHonorAwards()
}
class EditHonorAwardsTableViewCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	
	@IBOutlet weak var titleTF: FloatingLabel!
	@IBOutlet weak var awardedForTF: FloatingLabel!
	@IBOutlet weak var awardedByTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	var delegate: EditHonorAwardsTvCellDelegate?
	var isEditMode: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
		delegate?.saveHonorAwards(dict: requestDict, at: sender.tag)
	}
	
	func setUI(dict: [String: Any], btnTag: Int) {
		
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		
		editButton.isHidden = isEditMode ? true : false
		cancelButton.isHidden = isEditMode ? false : true
		removeFileButton.isHidden = true
		
		startDateTF.isUserInteractionEnabled = isEditMode
		startMonthTF.isUserInteractionEnabled = isEditMode
		startYearTF.isUserInteractionEnabled = isEditMode
		
		titleTF.isUserInteractionEnabled = isEditMode
		awardedForTF.isUserInteractionEnabled = isEditMode
		awardedByTF.isUserInteractionEnabled = isEditMode
		
		titleTF.text = dict["title"] as? String ?? ""
		awardedForTF.text = dict["awarded_for"] as? String ?? ""
		awardedByTF.text = dict["awarded_by"] as? String ?? ""
		
		startDateTF.text = dict["dd"] as? String ?? ""
		startMonthTF.text = dict["mm"] as? String ?? ""
		startYearTF.text = dict["yy"] as? String ?? ""
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelHonorAwards()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editHonorAwards(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteHonorAwards(dict: ["type" : "honor_awards","status":"delete"], at: sender.tag)
	}
}

extension EditHonorAwardsTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}
