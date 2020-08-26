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
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var toLabel: UILabel!
	@IBOutlet weak var notifyLabel: UILabel!
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
		
		if sectionType == "certifications" {
			givenByTF.placeholder = "Given by*"
			certificationsNoTF.placeholder = "Certification number*"
			fromLabel.text = "Issue Date"
			toLabel.text = "Expiry Date"
			notifyLabel.text = "Notify me"
			
			titleTF.text = dict["title"] as? String ?? ""
			givenByTF.text = dict["given_by"] as? String ?? ""
			certificationsNoTF.text = dict["certifications_no"] as? String ?? ""
		}
		else if sectionType == "administrative_responsibility" {
			givenByTF.placeholder = "Section"
			certificationsNoTF.placeholder = "Location"
			fromLabel.text = "From"
			toLabel.text = "To"
			notifyLabel.text = "Current"
			
			titleTF.text = dict["title"] as? String ?? ""
			givenByTF.text = dict["section"] as? String ?? ""
			certificationsNoTF.text = dict["location"] as? String ?? ""
			fromDateKey = "from_date"
			toDateKey = "to_date"
			notifyKey = "currently_pursuing"
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
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":false] as [String : Any]
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
