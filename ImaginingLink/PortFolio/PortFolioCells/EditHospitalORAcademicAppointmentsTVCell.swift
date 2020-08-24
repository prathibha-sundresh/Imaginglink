//
//  EditHospitalORAcademicAppointmentsTVCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/13/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditHospitalORAcademicAppointmentsTVCell: UITableViewCell {
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
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	var isEditMode: Bool = false
	var delegate: EditSectionTvCellDelegate?
	var sectionType = ""
	var fileUrl: URL?
	var vc: UIViewController?
	@IBOutlet weak var disableView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setUI(dict: [String: Any], btnTag: Int) {
		
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		editButton.isHidden = isEditMode ? true : false
		cancelButton.isHidden = isEditMode ? false : true
		disableView.isHidden = isEditMode
		titleTF.text = dict["title"] as? String ?? ""
		locationTF.text = dict["location"] as? String ?? ""
		urlTF.text = dict["url"] as? String ?? ""
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
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func currentlyPursuingButtonAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
        if sender.isSelected {
            currentYearButton.setImage(#imageLiteral(resourceName: "ClickedCheckBox"), for: UIControl.State.normal)
        } else {
            currentYearButton.setImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControl.State.normal)
        }
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
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		let currently_pursuing = currentYearButton.isSelected ? "True" : "False"
		var requestDict = [
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
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]": true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
		}
		delegate?.saveSection(dict: requestDict, at: sender.tag)
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

extension EditHospitalORAcademicAppointmentsTVCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditHospitalORAcademicAppointmentsTVCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
