//
//  EditCMETrackingTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditCMETrackingTableViewCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var textField1: FloatingLabel!
	@IBOutlet weak var textField2: FloatingLabel!
	@IBOutlet weak var textField3: FloatingLabel!
	@IBOutlet weak var textField4: FloatingLabel!
	@IBOutlet weak var textField5: FloatingLabel!
	@IBOutlet weak var textField6: FloatingLabel!
	@IBOutlet weak var textField7: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var uploadFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var delegate: EditSectionTvCellDelegate?
	var trackingTvCellDelegate: AddCMETrackingTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
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
		
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		let files = dict["file"] as? [String] ?? []
		if files.count > 0 {
			fileNameLabel.text = files[0]
			removeFileButton.isHidden = false
		}
	
		if let startDataDict = dict["date_completed"] as? [String: Any] {
			startDateTF.text = startDataDict["dd"] as? String ?? ""
			startMonthTF.text = startDataDict["mm"] as? String ?? ""
			startYearTF.text = startDataDict["yy"] as? String ?? ""
		}
		textField1.text = dict["year"] as? String ?? ""
		textField2.text = dict["credit_amount"] as? String ?? ""
		textField3.text = dict["credit_type"] as? String ?? ""
		textField4.text = dict["course_title"] as? String ?? ""
		textField5.text = dict["institution_name"] as? String ?? ""
		textField6.text = dict["course_code"] as? String ?? ""
		textField7.text = dict["course_description"] as? String ?? ""
		enableOrDisableSaveButton()
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var requestDict = [
		"type":"cme_tracking",
		"post_data[date_completed][dd]":startDateTF.text!,
		"post_data[date_completed][mm]":startMonthTF.text!,
		"post_data[date_completed][yy]":startYearTF.text!,
		"post_data[year]" : textField1.text!,
		"post_data[credit_amount]" : textField2.text!,
		"post_data[credit_type]" : textField3.text!,
		"post_data[course_title]" : textField4.text!,
		"post_data[institution_name]" : textField5.text!,
		"post_data[course_code]" : textField6.text!,
		"post_data[course_description]" : textField7.text!,
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
		}
		delegate?.saveSection(dict: requestDict, at: sender.tag)
	}
	
	@IBAction func selectCreditTypeButtonAction(_ sender: UIButton) {
		trackingTvCellDelegate?.chooseCreditType()
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
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : "cme_tracking","status":"delete"], at: sender.tag)
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		enableOrDisableSaveButton()
	}
	
	func enableOrDisableSaveButton() {
		
		if startDateTF.text != "" && startMonthTF.text != "" && startYearTF.text != "" && textField1.text != "" && textField2.text != "" && textField3.text != "" {
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
	}
}

extension EditCMETrackingTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditCMETrackingTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
