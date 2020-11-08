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
	@IBOutlet weak var currentButton: UIButton!
	@IBOutlet weak var urlTF: FloatingLabel!
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var toLabel: UILabel!
	@IBOutlet weak var notifyLabel: UILabel!
	@IBOutlet weak var urlTFViewH: NSLayoutConstraint!
	@IBOutlet weak var currentButtonViewH: NSLayoutConstraint!
	@IBOutlet weak var currentButtonView: UIView!
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
		urlTF.text = ""
		notifyMeButton.isSelected = false
		currentButton.isSelected = false
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		
		currentButtonViewH.constant = 0
		urlTFViewH.constant = 0
		urlTF.isHidden = true
		currentButtonView.isHidden = true
		
		if sectionType == "certifications" {
			givenByTF.placeholder = "Given by*"
			certificationsNoTF.placeholder = "Certification number"
			fromLabel.text = "Issue Date*"
			toLabel.text = "Expiry Date*"
			notifyLabel.text = "Notify me"
		}
		else if sectionType == "administrative_responsibility" {
			givenByTF.placeholder = "Section*"
			certificationsNoTF.placeholder = "Location"
			fromLabel.text = "From*"
			toLabel.text = "To*"
			notifyLabel.text = "Current"
		}
		else if sectionType == "custom_fields" {
			givenByTF.placeholder = "Description*"
			certificationsNoTF.placeholder = "Number/ID"
			urlTF.placeholder = "URL"
			fromLabel.text = "Start Date*"
			toLabel.text = "End Date*"
			notifyLabel.text = "Notify me"
			currentButtonViewH.constant = 30
			urlTFViewH.constant = 55
			urlTF.isHidden = false
			currentButtonView.isHidden = false
		}
		enableOrDisableSaveButton()
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		
		var requestDict = ["type":sectionType,"post_data[title]":titleTF.text!,"post_data[status]":false] as [String : Any]
		
		let notifyMe = notifyMeButton.isSelected ? "True" : "False"
		if sectionType == "administrative_responsibility" {
			requestDict["post_data[from_date][dd]"] = startDateTF.text!
			requestDict["post_data[from_date][mm]"] = startMonthTF.text!
			requestDict["post_data[from_date][yy]"] = startYearTF.text!
			requestDict["post_data[to_date][dd]"] = endDateTF.text!
			requestDict["post_data[to_date][mm]"] = endMonthTF.text!
			requestDict["post_data[to_date][yy]"] = endYearTF.text!
			requestDict["post_data[currently_pursuing]"] = notifyMe
			requestDict["post_data[section]"] = givenByTF.text!
			requestDict["post_data[location]"] = certificationsNoTF.text!
		}
		else if sectionType == "certifications" {
			requestDict["post_data[issued_date][dd]"] = startDateTF.text!
			requestDict["post_data[issued_date][mm]"] = startMonthTF.text!
			requestDict["post_data[issued_date][yy]"] = startYearTF.text!
			requestDict["post_data[expiry_date][dd]"] = endDateTF.text!
			requestDict["post_data[expiry_date][mm]"] = endMonthTF.text!
			requestDict["post_data[expiry_date][yy]"] = endYearTF.text!
			requestDict["post_data[nofy_me]"] = notifyMe
			requestDict["post_data[given_by]"] = givenByTF.text!
			requestDict["post_data[certifications_no]"] = certificationsNoTF.text!
		}
		else if sectionType == "custom_fields" {
			let current = notifyMeButton.isSelected ? "True" : "False"
			requestDict["post_data[date][dd]"] = startDateTF.text!
			requestDict["post_data[date][mm]"] = startMonthTF.text!
			requestDict["post_data[date][yy]"] = startYearTF.text!
			requestDict["post_data[expiry][dd]"] = endDateTF.text!
			requestDict["post_data[expiry][mm]"] = endMonthTF.text!
			requestDict["post_data[expiry][yy]"] = endYearTF.text!
			requestDict["post_data[currently_pursuing]"] = current
			requestDict["post_data[nofy_me]"] = notifyMe
			requestDict["post_data[description]"] = givenByTF.text!
			requestDict["post_data[number_id]"] = certificationsNoTF.text!
			requestDict["post_data[url]"] = urlTF.text!
		}
		
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		delegate?.addSection(dict: requestDict)
	}
	
	@IBAction func notifyMeAction(_ sender: UIButton) {
		notifyMeButton.isSelected = !sender.isSelected
	}
	
	@IBAction func currentButtonAction(_ sender: UIButton) {
		currentButton.isSelected = !sender.isSelected
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
		var isValidationBool = false
		
		if sectionType == "certifications" {
			if startDateTF.text != "" && startMonthTF.text != "" && startYearTF.text != "" && endDateTF.text != "" && endYearTF.text != "" && titleTF.text != "" {
				isValidationBool = true
			}
		}
		else if sectionType == "administrative_responsibility" || sectionType == "custom_fields" {
			if startDateTF.text != "" && startMonthTF.text != "" && startYearTF.text != "" && endDateTF.text != "" && endYearTF.text != "" && titleTF.text != "" && givenByTF.text != ""{
				isValidationBool = true
			}
		}
		
		if isValidationBool {
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
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
