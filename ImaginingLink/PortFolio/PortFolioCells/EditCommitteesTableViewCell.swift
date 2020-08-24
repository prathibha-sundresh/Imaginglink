//
//  EditCommitteesTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/20/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol EditSectionTvCellDelegate {
	func saveSection(dict: [String: Any], at index: Int)
	func deleteSection(dict: [String : Any], at index: Int)
	func editSection(at index: Int)
	func cancelSection()
}

class EditCommitteesTableViewCell: UITableViewCell {
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
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var isEditMode: Bool = false
	var delegate: EditSectionTvCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	func setUI(dict: [String: Any], btnTag: Int) {
		
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		
		disableView.isHidden = isEditMode
		editButton.isHidden = isEditMode
		cancelButton.isHidden = !isEditMode
		
		committeePositionTF.text = dict["committee_position"] as? String ?? ""
		typeTF.text = dict["type"] as? String ?? ""
		committeeNameTF.text = dict["committee_name"] as? String ?? ""
		locationTF.text = dict["location"] as? String ?? ""
		if let startDataDict = dict["date_from"] as? [String: Any] {
			startMonthTF.text = startDataDict["mm"] as? String ?? ""
			startYearTF.text = startDataDict["yy"] as? String ?? ""
		}
		if let endDataDict = dict["date_to"] as? [String: Any] {
			endMonthTF.text = endDataDict["mm"] as? String ?? ""
			endYearTF.text = endDataDict["yy"] as? String ?? ""
		}
		let graduated = (dict["currently_pursuing"] as? String ?? "false").lowercased()
		
		notifyMeButton.isSelected = (graduated == "true") ? true : false
		
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
		"post_data[status]":true] as [String : Any]
		delegate?.saveSection(dict: requestDict, at: sender.tag)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : "committees","status":"delete"], at: sender.tag)
	}
	
	@IBAction func notifyMeAction(_ sender: UIButton) {
		notifyMeButton.isSelected = !sender.isSelected
	}
}

extension EditCommitteesTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}
