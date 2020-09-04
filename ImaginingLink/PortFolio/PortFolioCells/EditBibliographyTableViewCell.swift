//
//  EditBibliographyTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/4/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditBibliographyTableViewCell: UITableViewCell {
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
	@IBOutlet weak var textField8: FloatingLabel!
	@IBOutlet weak var textField9: FloatingLabel!
	@IBOutlet weak var textField10: FloatingLabel!
	@IBOutlet weak var textField11: FloatingLabel!
	@IBOutlet weak var textField12: FloatingLabel!
	@IBOutlet weak var textField13: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var uploadFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var delegate: EditSectionTvCellDelegate?
	var cellDelegate: AddBibliographyTvCellDelegate?
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
	
		if let startDataDict = dict["date"] as? [String: Any] {
			startDateTF.text = startDataDict["dd"] as? String ?? ""
			startMonthTF.text = startDataDict["mm"] as? String ?? ""
			startYearTF.text = startDataDict["yy"] as? String ?? ""
		}
		textField1.text = dict["type"] as? String ?? ""
		textField2.text = dict["author"] as? String ?? ""
		textField3.text = dict["title"] as? String ?? ""
		textField4.text = dict["conference_name"] as? String ?? ""
		textField5.text = dict["editor"] as? String ?? ""
		textField6.text = dict["edition"] as? String ?? ""
		textField7.text = dict["city"] as? String ?? ""
		textField8.text = dict["publisher"] as? String ?? ""
		textField9.text = dict["volume"] as? String ?? ""
		textField10.text = dict["page_from"] as? String ?? ""
		textField11.text = dict["page_to"] as? String ?? ""
		textField12.text = dict["url"] as? String ?? ""
		textField13.text = dict["status"] as? String ?? ""
		enableOrDisableSaveButton()
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		
		var requestDict = [
			"type":"bibliography",
			"post_data[type]" : textField1.text!,
			"post_data[author]" : textField2.text!,
			"post_data[title]" : textField3.text!,
			"post_data[conference_name]" : textField4.text!,
			"post_data[editor]" : textField5.text!,
			"post_data[edition]" : textField6.text!,
			"post_data[city]" : textField7.text!,
			"post_data[publisher]" : textField8.text!,
			"post_data[date][dd]":startDateTF.text!,
			"post_data[date][mm]":startMonthTF.text!,
			"post_data[date][yy]":startYearTF.text!,
			"post_data[volume]" : textField9.text!,
			"post_data[page_from]" : textField10.text!,
			"post_data[page_to]" : textField11.text!,
			"post_data[url]" : textField12.text!,
			"post_data[status]" : textField13.text!] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		delegate?.saveSection(dict: requestDict, at: sender.tag)
	}
	
	@IBAction func selectBibliographyTypeAction(_ sender: UIButton) {
		cellDelegate?.chooseBibliographyType()
	}
	
	@IBAction func selectStatusTypeAction(_ sender: UIButton) {
		cellDelegate?.chooseStatusType()
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
		
		if startDateTF.text != "" && startMonthTF.text != "" && startYearTF.text != "" && textField1.text != "" && textField2.text != "" && textField3.text != "" && textField4.text != "" && textField13.text != "" {
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : "bibliography","status":"delete"], at: sender.tag)
	}
}

extension EditBibliographyTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditBibliographyTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
