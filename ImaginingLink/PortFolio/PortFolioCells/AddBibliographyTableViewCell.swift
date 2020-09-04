//
//  AddBibliographyTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/3/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol AddBibliographyTvCellDelegate {
	func chooseBibliographyType()
	func chooseStatusType()
}

class AddBibliographyTableViewCell: UITableViewCell {
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
	var delegate: AddSectionTvCellDelegate?
	var cellDelegate: AddBibliographyTvCellDelegate?
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
		textField8.text = ""
		textField9.text = ""
		textField10.text = ""
		textField11.text = ""
		textField12.text = ""
		textField13.text = ""
		startDateTF.text = ""
		startMonthTF.text = ""
		startYearTF.text = ""
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		enableOrDisableSaveButton()
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		
//		post_data[university]:Boston university
//		post_data[sponsor]:S Buck
//		post_data[number]:234
//		post_data[abstract]:Imaginglink...
		
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
		delegate?.addSection(dict: requestDict)
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
}

extension AddBibliographyTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddBibliographyTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
