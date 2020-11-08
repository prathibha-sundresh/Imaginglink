//
//  AddCongressionalAndMediaTVCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/27/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddCongressionalAndMediaTVCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var textField1: FloatingLabel!
	@IBOutlet weak var textField2: FloatingLabel!
	@IBOutlet weak var textField3: FloatingLabel!
	@IBOutlet weak var textField4: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var uploadFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var dateLabel: UILabel!
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
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		
		if sectionType == "congressional_testimony" {
			textField1.placeholder = "Testimony Before*"
			textField2.placeholder = "Description*"
			textField3.placeholder = "Number/ID"
			textField4.placeholder = "URL"
			dateLabel.text = "Date"
		}
		else if sectionType == "media_appearances" {
			textField1.placeholder = "Title*"
			textField2.placeholder = "Description*"
			textField3.placeholder = "Published at"
			textField4.placeholder = "URL"
			dateLabel.text = "Date completed"
		}
		enableOrDisableSaveButton()
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var requestDict = [
		"type":sectionType,
		"post_data[date][dd]":startDateTF.text!,
		"post_data[date][mm]":startMonthTF.text!,
		"post_data[date][yy]":startYearTF.text!,
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		if sectionType == "congressional_testimony" {
			requestDict["post_data[testi_mony_before]"] = textField1.text!
			requestDict["post_data[description]"] = textField2.text!
			requestDict["post_data[number_id]"] = textField3.text!
			requestDict["post_data[url]"] = textField4.text!
		}
		else if sectionType == "media_appearances" {
			requestDict["post_data[title]"] = textField1.text!
			requestDict["post_data[description]"] = textField2.text!
			requestDict["post_data[published_at]"] = textField3.text!
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
	
	@IBAction func textDidChange(_ textField: UITextField) {
		enableOrDisableSaveButton()
	}
	
	func enableOrDisableSaveButton() {
		
		if startDateTF.text != "" && startMonthTF.text != "" && startYearTF.text != "" && textField1.text != "" && textField2.text != "" {
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
	}
}

extension AddCongressionalAndMediaTVCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddCongressionalAndMediaTVCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
