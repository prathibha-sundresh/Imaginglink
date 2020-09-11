//
//  EditUGEducationTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol EditUGEducationTvCellDelegate {
	func saveUgSection(dict: [String: Any], at index: Int)
	func deleteUgSection(dict: [String : Any], at index: Int)
	func editUgSection(at index: Int)
	func cancelUgSection()
}

class EditUGEducationTableViewCell: UITableViewCell {
	@IBOutlet weak var countryTF: FloatingLabel!
	@IBOutlet weak var cityTF: FloatingLabel!
	@IBOutlet weak var schoolTF: FloatingLabel!
	@IBOutlet weak var fromYearTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var delegate: EditUGEducationTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
	var isEditMode: Bool = false
	var schoolType: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI(dict : [String: Any], btnTag: Int) {
		deleteButton.tag = btnTag
		editButton.tag = btnTag
		saveButton.tag = btnTag
		editButton.isHidden = isEditMode ? true : false
		cancelButton.isHidden = isEditMode ? false : true
		disableView.isHidden = isEditMode
		
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		if let files = dict["file"] as? [String], files.count > 0 {
			fileNameLabel.text = files[0]
			removeFileButton.isHidden = false
		}
		countryTF.text = dict["country"] as? String ?? ""
		cityTF.text = dict["city"] as? String ?? ""
		schoolTF.text = dict["school"] as? String ?? ""
		fromYearTF.text = dict["period_start"] as? String ?? ""
		endYearTF.text = dict["period_end"] as? String ?? ""
		
	}
	@IBAction func textDidChange(_ textField: UITextField) {
		enableOrDisableSaveButton()
	}
	
	func enableOrDisableSaveButton() {
		if fromYearTF.text != "" && endYearTF.text != "" && countryTF.text != "" && cityTF.text != "" && schoolTF.text != ""{
			saveButton.isEnabled = true
			saveButton.alpha = 1.0
		}
		else {
			saveButton.isEnabled = false
			saveButton.alpha = 0.5
		}
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		
		var requestDict = [
		"type":"education",
		"education_type":"UG",
		"post_data[school_type]": schoolType,
		"post_data[country]":countryTF.text!,
		"post_data[city]":cityTF.text!,
		"post_data[school]": schoolTF.text!,
		"post_data[period_start]":fromYearTF.text!,
		"post_data[period_end]":endYearTF.text!,
		"post_data[is_custom_school]": false,
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
		}
		delegate?.saveUgSection(dict: requestDict, at: sender.tag)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.cancelUgSection()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editUgSection(at: sender.tag)
	}
	
	@IBAction func selectCountryButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectCountry", "cell": self,"index": editButton.tag])
	}
	
	@IBAction func selectCityButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectCity", "country": countryTF.text!, "cell": self, "index": editButton.tag])
	}
	
	@IBAction func selectSchoolButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectSchool", "country": countryTF.text!,"city": cityTF.text!, "cell": self, "index": editButton.tag])
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		delegate?.deleteUgSection(dict: ["type" : "education","subtype" : "UG","status":"delete"], at: sender.tag)
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

extension EditUGEducationTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditUGEducationTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
