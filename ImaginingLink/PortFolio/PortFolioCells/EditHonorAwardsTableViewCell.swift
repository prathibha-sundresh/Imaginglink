//
//  EditHonorAwardsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/15/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditHonorAwardsTableViewCell: UITableViewCell {
	@IBOutlet weak var startDateTF: FloatingLabel!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	
	@IBOutlet weak var titleTF: FloatingLabel!
	@IBOutlet weak var awardedForTF: FloatingLabel!
	@IBOutlet weak var awardedByTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var delegate: EditSectionTvCellDelegate?
	var isEditMode: Bool = false
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
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var requestDict = [
		"type":"honor_awards",
		"post_data[title]":titleTF.text!,
		"post_data[awarded_for]":awardedForTF.text!,
		"post_data[awarded_by]": awardedByTF.text!,
		"post_data[dd]":startDateTF.text!,
		"post_data[mm]":startMonthTF.text!,
		"post_data[yy]":startYearTF.text!,
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
		}
		delegate?.saveSection(dict: requestDict, at: sender.tag)
	}
	
	func setUI(dict: [String: Any], btnTag: Int) {
		
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		
		editButton.isHidden = isEditMode ? true : false
		cancelButton.isHidden = isEditMode ? false : true
		removeFileButton.isHidden = true
		disableView.isHidden = isEditMode
		
		titleTF.text = dict["title"] as? String ?? ""
		awardedForTF.text = dict["awarded_for"] as? String ?? ""
		awardedByTF.text = dict["awarded_by"] as? String ?? ""
		
		startDateTF.text = dict["dd"] as? String ?? ""
		startMonthTF.text = dict["mm"] as? String ?? ""
		startYearTF.text = dict["yy"] as? String ?? ""
		
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		let files = dict["file"] as? [String] ?? []
		if files.count > 0 {
			fileNameLabel.text = files[0]
			removeFileButton.isHidden = false
		}
		enableOrDisableSaveButton()
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : "honor_awards","status":"delete"], at: sender.tag)
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
		if startDateTF.text != "" && startMonthTF.text != "" && startYearTF.text != "" && titleTF.text != "" {
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
	}
}

extension EditHonorAwardsTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditHonorAwardsTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
