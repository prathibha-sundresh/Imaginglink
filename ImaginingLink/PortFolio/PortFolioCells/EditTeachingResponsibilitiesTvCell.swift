//
//  EditTeachingResponsibilitiesTvCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/25/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditTeachingResponsibilitiesTvCell: UITableViewCell {
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
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var delegate: EditSectionTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
	var sectionType = ""
	var isEditMode: Bool = false
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
		editButton.isHidden = isEditMode ? true : false
		cancelButton.isHidden = isEditMode ? false : true
		disableView.isHidden = isEditMode
		
		var text1 = ""
		var text2 = ""
		var text3 = ""
		var text4 = ""
		var text5 = ""
		
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
		
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		let files = dict["file"] as? [String] ?? []
		if files.count > 0 {
			fileNameLabel.text = files[0]
			removeFileButton.isHidden = false
		}
		
		textField1.isHidden = false
		textField2.isHidden = false
		textField3.isHidden = false
		textField4.isHidden = false
		textField5.isHidden = false
		
		if sectionType == "teaching" {
			//5 TextFields
			textFieldsContainerViewH.constant = 310
			textField1.placeholder = "Location*"
			textField2.placeholder = "Course Description*"
			textField3.placeholder = "Role"
			textField4.placeholder = "Audience & Contact Time"
			textField5.placeholder = "Prep Time"
			
			text1 = dict["location"] as? String ?? ""
			text2 = dict["course_description"] as? String ?? ""
			text3 = dict["role"] as? String ?? ""
			text4 = dict["audience_contact_time"] as? String ?? ""
			text5 = dict["prep"] as? String ?? ""
		}
		else if sectionType == "major_mentoring_activities" {
			//3 TextFields
			textFieldsContainerViewH.constant = 190
			textField4.isHidden = true
			textField5.isHidden = true
			textField1.placeholder = "Trainee name*"
			textField2.placeholder = "Description*"
			textField3.placeholder = "Trainee's Current Position"
			
			text1 = dict["trainee_name"] as? String ?? ""
			text2 = dict["description"] as? String ?? ""
			text3 = dict["trainee_current_position"] as? String ?? ""
			
		}
		else if sectionType == "professional_societies"{
			//4 TextFields
			textFieldsContainerViewH.constant = 240
			textField5.isHidden = true
			textField1.placeholder = "Society name*"
			textField2.placeholder = "Membership Type*"
			textField3.placeholder = "Membership ID"
			textField4.placeholder = "URL"
			
			text1 = dict["society_name"] as? String ?? ""
			text2 = dict["member_ship_type"] as? String ?? ""
			text3 = dict["member_ship_id"] as? String ?? ""
			text4 = dict["url"] as? String ?? ""
		}
		else if sectionType == "educational_boards" {
			//4 TextFields
			textFieldsContainerViewH.constant = 240
			textField5.isHidden = true
			textField1.placeholder = "Role*"
			textField2.placeholder = "Journal name*"
			textField3.placeholder = "Sub Section"
			textField4.placeholder = "URL"
			
			text1 = dict["role"] as? String ?? ""
			text2 = dict["journal_name"] as? String ?? ""
			text3 = dict["sub_section"] as? String ?? ""
			text4 = dict["url"] as? String ?? ""
		}
		textField1.text = text1
		textField2.text = text2
		textField3.text = text3
		textField4.text = text4
		textField5.text = text5
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
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
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
		delegate?.saveSection(dict: requestDict, at: sender.tag)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : sectionType,"status":"delete"], at: sender.tag)
	}
	
	@IBAction func currentYearAction(_ sender: UIButton) {
		currentYearButton.isSelected = !sender.isSelected
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
}

extension EditTeachingResponsibilitiesTvCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditTeachingResponsibilitiesTvCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
