//
//  AddTeachingResponsibilitiesTvCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/24/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddTeachingResponsibilitiesTvCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var endDateTF: FloatingLabel!
	@IBOutlet weak var endMonthTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var currentYearButton: UIButton!
	@IBOutlet weak var textField1: FloatingLabel!
	@IBOutlet weak var textField2: FloatingLabel!
	@IBOutlet weak var textField3: FloatingLabel!
	@IBOutlet weak var textField4: FloatingLabel!
	@IBOutlet weak var textField5: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var uploadFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var textFieldsContainerViewH: NSLayoutConstraint!
	var delegate: AddSectionTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
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
		textField1.text = ""
		textField2.text = ""
		textField3.text = ""
		textField4.text = ""
		textField5.text = ""
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		endDateTF.text = ""
		endMonthTF.text = ""
		endYearTF.text = ""
		currentYearButton.isSelected = false
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		textField1.isHidden = false
		textField2.isHidden = false
		textField3.isHidden = false
		textField4.isHidden = false
		textField5.isHidden = false
		var placeHolder1 = ""
		var placeHolder2 = ""
		var placeHolder3 = ""
		var placeHolder4 = ""
		var placeHolder5 = ""
		if sectionType == "teaching" {
			//5 TextFields
			textFieldsContainerViewH.constant = 310
			placeHolder1 = "Location*"
			placeHolder2 = "Course Description*"
			placeHolder3 = "Role"
			placeHolder4 = "Audience & Contact Time"
			placeHolder5 = "Prep Time"
		}
		else if sectionType == "major_mentoring_activities" {
			//3 TextFields
			textFieldsContainerViewH.constant = 190
			textField4.isHidden = true
			textField5.isHidden = true
			placeHolder1 = "Trainee name*"
			placeHolder2 = "Description*"
			placeHolder3 = "Trainee's Current Position"
			
		}
		else if sectionType == "professional_societies" {
			//4 TextFields
			textFieldsContainerViewH.constant = 240
			textField5.isHidden = true
			placeHolder1 = "Society name*"
			placeHolder2 = "Membership Type*"
			placeHolder3 = "Membership ID"
			placeHolder4 = "URL"
		}
		else if sectionType == "educational_boards" {
			//4 TextFields
			textFieldsContainerViewH.constant = 240
			textField5.isHidden = true
			placeHolder1 = "Role*"
			placeHolder2 = "Journal name*"
			placeHolder3 = "Sub Section"
			placeHolder4 = "URL"
		}
		textField1.placeholder = placeHolder1
		textField2.placeholder = placeHolder2
		textField3.placeholder = placeHolder3
		textField4.placeholder = placeHolder4
		textField5.placeholder = placeHolder5
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		let currently_pursuing = currentYearButton.isSelected ? "True" : "False"
		var requestDict = [
		"type":sectionType,
		"post_data[currently_pursuing]":currently_pursuing,
		"post_data[date][dd]":startDateTF.text!,
		"post_data[date][mm]":startMonthTF.text!,
		"post_data[date][yy]":startYearTF.text!,
		"post_data[expiry][dd]":endDateTF.text!,
		"post_data[expiry][mm]":endMonthTF.text!,
		"post_data[expiry][yy]":endYearTF.text!,
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		if sectionType == "teaching" {
			requestDict["post_data[location]"] = textField1.text!
			requestDict["post_data[course_description]"] = textField2.text!
			requestDict["post_data[role]"] = textField3.text!
			requestDict["post_data[audience_contact_time]"] = textField4.text!
			requestDict["post_data[prep]"] = textField5.text!
		}
		else if sectionType == "major_mentoring_activities" {
			requestDict["post_data[trainee_name]"] = textField1.text!
			requestDict["post_data[description]"] = textField2.text!
			requestDict["post_data[trainee_current_position]"] = textField3.text!
		}
		else if sectionType == "professional_societies" {
			requestDict["post_data[society_name]"] = textField1.text!
			requestDict["post_data[member_ship_type]"] = textField2.text!
			requestDict["post_data[member_ship_id]"] = textField3.text!
			requestDict["post_data[url]"] = textField4.text!
		}
		else if sectionType == "educational_boards" {
			requestDict["post_data[role]"] = textField1.text!
			requestDict["post_data[journal_name]"] = textField2.text!
			requestDict["post_data[sub_section]"] = textField3.text!
			requestDict["post_data[url]"] = textField4.text!
		}
		delegate?.addSection(dict: requestDict)
	}
	
	@IBAction func addFileButtonAction(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
		documentPicker.modalPresentationStyle = .overFullScreen
		vc?.present(documentPicker, animated: true, completion: nil)
    }
	
	@IBAction func removeFileButtonAction(_ sender: UIButton) {
		fileNameLabel.text = "No file selected"
		fileUrl = nil
		removeFileButton.isHidden = true
	}
	
	@IBAction func currentYearAction(_ sender: UIButton) {
		currentYearButton.isSelected = !sender.isSelected
	}
}

extension AddTeachingResponsibilitiesTvCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddTeachingResponsibilitiesTvCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
