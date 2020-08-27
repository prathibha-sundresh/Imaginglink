//
//  EditCongressionalAndMediaTVCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/27/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditCongressionalAndMediaTVCell: UITableViewCell {
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
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var delegate: EditSectionTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
	var sectionType = ""
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
		textField4.text = dict["url"] as? String ?? ""
		
		if sectionType == "congressional_testimony" {
			textField1.placeholder = "Testimony Before*"
			textField2.placeholder = "Description*"
			textField3.placeholder = "Number/ID"
			dateLabel.text = "Date"
			
			textField1.text = dict["testi_mony_before"] as? String ?? ""
			textField2.text = dict["description"] as? String ?? ""
			textField3.text = dict["number_id"] as? String ?? ""
			
		}
		else if sectionType == "media_appearances" {
			textField1.placeholder = "Title*"
			textField2.placeholder = "Description*"
			textField3.placeholder = "Published at"
			dateLabel.text = "Date completed"
			
			textField1.text = dict["title"] as? String ?? ""
			textField2.text = dict["description"] as? String ?? ""
			textField3.text = dict["published_at"] as? String ?? ""
		}
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var requestDict = [
		"type":sectionType,
		"post_data[date][dd]":startDateTF.text!,
		"post_data[date][mm]":startMonthTF.text!,
		"post_data[date][yy]":startYearTF.text!,
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
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
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editSection(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteSection(dict: ["type" : sectionType,"status":"delete"], at: sender.tag)
	}
}

extension EditCongressionalAndMediaTVCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditCongressionalAndMediaTVCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
