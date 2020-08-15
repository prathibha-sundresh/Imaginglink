//
//  EditHospitalORAcademicAppointmentsTVCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/13/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol EditAppointmentsTVCellDelegate {
	func saveAppointments(dict: [String: Any], at index: Int)
	func deleteAppointments(dict: [String : Any], at index: Int)
	func editAppointments(at index: Int)
	func cancelAppointments()
}

class EditHospitalORAcademicAppointmentsTVCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var endDateTF: FloatingLabel!
	@IBOutlet weak var endMonthTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var currentYearButton: UIButton!
	@IBOutlet weak var titleTF: FloatingLabel!
	@IBOutlet weak var locationTF: FloatingLabel!
	@IBOutlet weak var urlTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	var isEditMode: Bool = false
	var delegate: EditAppointmentsTVCellDelegate?
	var sectionType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
		endDateTF.isUserInteractionEnabled = isEditMode
		endMonthTF.isUserInteractionEnabled = isEditMode
		endYearTF.isUserInteractionEnabled = isEditMode
		titleTF.isUserInteractionEnabled = isEditMode
		locationTF.isUserInteractionEnabled = isEditMode
		urlTF.isUserInteractionEnabled = isEditMode
		titleTF.text = dict["title"] as? String ?? ""
		locationTF.text = dict["location"] as? String ?? ""
		urlTF.text = dict["url"] as? String ?? ""
		let currently_pursuing = dict["currently_pursuing"] as? String ?? "False"
		if let startDataDict = dict["date"] as? [String: Any] {
			startDateTF.text = startDataDict["dd"] as? String ?? ""
			startMonthTF.text = startDataDict["mm"] as? String ?? ""
			startYearTF.text = startDataDict["yy"] as? String ?? ""
		}
		if let endDataDict = dict["expiry"] as? [String: Any] {
			endDateTF.text = endDataDict["dd"] as? String ?? ""
			endMonthTF.text = endDataDict["mm"] as? String ?? ""
			endYearTF.text = endDataDict["yy"] as? String ?? ""
		}
		if currently_pursuing == "True" {
			currentYearButton.setImage(#imageLiteral(resourceName: "ClickedCheckBox"), for: UIControl.State.normal)
		} else {
			currentYearButton.setImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControl.State.normal)
		}
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func currentlyPursuingButtonAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
        if sender.isSelected {
            currentYearButton.setImage(#imageLiteral(resourceName: "ClickedCheckBox"), for: UIControl.State.normal)
        } else {
            currentYearButton.setImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControl.State.normal)
        }
    }
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelAppointments()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editAppointments(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteAppointments(dict: ["type" : sectionType,"status":"delete"], at: sender.tag)
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		let currently_pursuing = currentYearButton.isSelected ? "True" : "False"
		let requestDict = [
		"type":sectionType,
		"post_data[title]":titleTF.text!,
		"post_data[location]":locationTF.text!,
		"post_data[url]": urlTF.text!,
		"post_data[currently_pursuing]":currently_pursuing,
		"post_data[date][dd]":startDateTF.text!,
		"post_data[date][mm]":startMonthTF.text!,
		"post_data[date][yy]":startYearTF.text!,
		"post_data[expiry][dd]":endDateTF.text!,
		"post_data[expiry][mm]":endMonthTF.text!,
		"post_data[expiry][yy]":endYearTF.text!,
		"post_data[status]":true] as [String : Any]
		delegate?.saveAppointments(dict: requestDict, at: sender.tag)
	}
}

extension EditHospitalORAcademicAppointmentsTVCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}
