//
//  AddHospitalAppointmentsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/15/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol AddAppointmentsTVCellDelegate {
	func addAppointments(dict: [String: Any])
}

class AddHospitalAppointmentsTableViewCell: UITableViewCell {
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
	var delegate: AddAppointmentsTVCellDelegate?
	var sectionType = ""
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
		locationTF.text = ""
		urlTF.text = ""
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		endDateTF.text = ""
		endMonthTF.text = ""
		endYearTF.text = ""
		currentYearButton.setImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControl.State.normal)
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
		"post_data[status]":false] as [String : Any]
		delegate?.addAppointments(dict: requestDict)
	}
}
extension AddHospitalAppointmentsTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}
