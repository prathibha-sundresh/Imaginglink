//
//  AddCMETrackingTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol AddCMETrackingTvCellDelegate {
	func chooseCreditType()
}

class AddCMETrackingTableViewCell: UITableViewCell {
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
	var delegate: AddSectionTvCellDelegate?
	var trackingTvCellDelegate: AddCMETrackingTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
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
		textField6.text = ""
		textField7.text = ""
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
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
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		delegate?.addSection(dict: requestDict)
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

extension AddCMETrackingTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddCMETrackingTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
