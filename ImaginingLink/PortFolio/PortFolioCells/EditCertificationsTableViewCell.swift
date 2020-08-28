//
//  EditCertificationsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/18/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditCertificationsTableViewCell: UITableViewCell {
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
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var toLabel: UILabel!
	@IBOutlet weak var notifyLabel: UILabel!
	@IBOutlet weak var urlTFViewH: NSLayoutConstraint!
	@IBOutlet weak var currentButtonViewH: NSLayoutConstraint!
	@IBOutlet weak var currentButtonView: UIView!
	var delegate: EditSectionTvCellDelegate?
	var isEditMode: Bool = false
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
	
	func setUI(dict: [String: Any], btnTag: Int) {
		var fromDateKey = "issued_date"
		var toDateKey = "expiry_date"
		var notifyKey = "nofy_me"
		
		currentButtonViewH.constant = 0
		urlTFViewH.constant = 0
		urlTF.isHidden = true
		currentButtonView.isHidden = true
		titleTF.text = dict["title"] as? String ?? ""
		
		if sectionType == "certifications" {
			givenByTF.placeholder = "Given by*"
			certificationsNoTF.placeholder = "Certification number*"
			fromLabel.text = "Issue Date"
			toLabel.text = "Expiry Date"
			notifyLabel.text = "Notify me"
		
			givenByTF.text = dict["given_by"] as? String ?? ""
			certificationsNoTF.text = dict["certifications_no"] as? String ?? ""
		}
		else if sectionType == "administrative_responsibility" {
			givenByTF.placeholder = "Section"
			certificationsNoTF.placeholder = "Location"
			fromLabel.text = "From"
			toLabel.text = "To"
			notifyLabel.text = "Current"
			
			givenByTF.text = dict["section"] as? String ?? ""
			certificationsNoTF.text = dict["location"] as? String ?? ""
			fromDateKey = "from_date"
			toDateKey = "to_date"
			notifyKey = "currently_pursuing"
		}
		else if sectionType == "custom_fields" {
			givenByTF.placeholder = "Description*"
			certificationsNoTF.placeholder = "Number/ID"
			urlTF.placeholder = "URL"
			fromLabel.text = "Start Date"
			toLabel.text = "End Date"
			notifyLabel.text = "Notify me"
			currentButtonViewH.constant = 30
			urlTFViewH.constant = 55
			urlTF.isHidden = false
			currentButtonView.isHidden = false
			
			givenByTF.text = dict["description"] as? String ?? ""
			certificationsNoTF.text = dict["number_id"] as? String ?? ""
			urlTF.text = dict["url"] as? String ?? ""
			fromDateKey = "date"
			toDateKey = "expiry"
			notifyKey = "currently_pursuing"
			let current = (dict[notifyKey] as? String ?? "false").lowercased()
			currentButton.isSelected = (current == "true") ? true : false
		}
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		
		disableView.isHidden = isEditMode
		editButton.isHidden = isEditMode
		cancelButton.isHidden = !isEditMode
		
		if let startDataDict = dict[fromDateKey] as? [String: Any] {
			startDateTF.text = startDataDict["dd"] as? String ?? ""
			startMonthTF.text = startDataDict["mm"] as? String ?? ""
			startYearTF.text = startDataDict["yy"] as? String ?? ""
		}
		if let endDataDict = dict[toDateKey] as? [String: Any] {
			endDateTF.text = endDataDict["dd"] as? String ?? ""
			endMonthTF.text = endDataDict["mm"] as? String ?? ""
			endYearTF.text = endDataDict["yy"] as? String ?? ""
		}
		let graduated = (dict[notifyKey] as? String ?? "false").lowercased()
		
		notifyMeButton.isSelected = (graduated == "true") ? true : false
		
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		let files = dict["file"] as? [String] ?? []
		if files.count > 0 {
			fileNameLabel.text = files[0]
			removeFileButton.isHidden = false
		}
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		
		var requestDict = ["type":sectionType,"post_data[title]":titleTF.text!,"post_data[status]":true, "source_file_name[]" : fileUrl ?? fileNameLabel.text!,] as [String : Any]
		
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
		
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
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
	
	@IBAction func currentButtonAction(_ sender: UIButton) {
		currentButton.isSelected = !sender.isSelected
	}
}
extension EditCertificationsTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditCertificationsTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
