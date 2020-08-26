//
//  AddCertificationsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/18/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddCertificationsTableViewCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var endDateTF: FloatingLabel!
	@IBOutlet weak var endMonthTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var notifyMeButton: UIButton!
	@IBOutlet weak var titleTF: FloatingLabel!
	@IBOutlet weak var givenByTF: FloatingLabel!
	@IBOutlet weak var certificationsNoTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var toLabel: UILabel!
	@IBOutlet weak var notifyLabel: UILabel!
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
		titleTF.text = ""
		givenByTF.text = ""
		certificationsNoTF.text = ""
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		endDateTF.text = ""
		endMonthTF.text = ""
		endYearTF.text = ""
		notifyMeButton.isSelected = false
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"

		if sectionType == "certifications" {
			givenByTF.placeholder = "Given by*"
			certificationsNoTF.placeholder = "Certification number*"
			fromLabel.text = "Issue Date"
			toLabel.text = "Expiry Date"
			notifyLabel.text = "Notify me"
		}
		else if sectionType == "administrative_responsibility" {
			givenByTF.placeholder = "Section"
			certificationsNoTF.placeholder = "Location"
			fromLabel.text = "From"
			toLabel.text = "To"
			notifyLabel.text = "Current"
		}
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var fromDateKey = "issued_date"
		var toDateKey = "expiry_date"
		var notifyKey = "nofy_me"
		var text2Key = "given_by"
		var text3Key = "certifications_no"
		if sectionType == "administrative_responsibility" {
			fromDateKey = "from_date"
			toDateKey = "to_date"
			notifyKey = "currently_pursuing"
			text2Key = "section"
			text3Key = "location"
		}
		let notifyMe = notifyMeButton.isSelected ? "True" : "False"
		var requestDict = [
		"type":sectionType,
		"post_data[title]":titleTF.text!,
		"post_data[\(text2Key)]":givenByTF.text!,
		"post_data[\(text3Key)]": certificationsNoTF.text!,
		"post_data[\(notifyKey)]":notifyMe,
		"post_data[\(fromDateKey)][dd]":startDateTF.text!,
		"post_data[\(fromDateKey)][mm]":startMonthTF.text!,
		"post_data[\(fromDateKey)][yy]":startYearTF.text!,
		"post_data[\(toDateKey)][dd]":endDateTF.text!,
		"post_data[\(toDateKey)][mm]":endMonthTF.text!,
		"post_data[\(toDateKey)][yy]":endYearTF.text!,
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		delegate?.addSection(dict: requestDict)
	}
	
	@IBAction func notifyMeAction(_ sender: UIButton) {
		notifyMeButton.isSelected = !sender.isSelected
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
extension AddCertificationsTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddCertificationsTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
