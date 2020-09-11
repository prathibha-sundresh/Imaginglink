//
//  AddUGEducationTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol AddUGEducationTvCellDelegate {
	func addUG(dict: [String: Any])
}

class AddUGEducationTableViewCell: UITableViewCell {
	
	@IBOutlet weak var countryTF: FloatingLabel!
	@IBOutlet weak var cityTF: FloatingLabel!
	@IBOutlet weak var schoolTF: FloatingLabel!
	@IBOutlet weak var fromYearTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	var delegate: AddUGEducationTvCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
	var schoolType: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setUI() {
		countryTF.text = ""
		cityTF.text = ""
		schoolTF.text = ""
		fromYearTF.text = ""
		endYearTF.text = ""
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		enableOrDisableSaveButton()
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func selectCountryButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectCountry", "cell": self,"index": -1])
	}
	
	@IBAction func selectCityButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectCity", "country": countryTF.text!, "cell": self, "index": -1])
	}
	
	@IBAction func selectSchoolButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectSchool", "country": countryTF.text!,"city": cityTF.text!, "cell": self, "index": -1])
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
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		delegate?.addUG(dict: requestDict)
	}
}

extension AddUGEducationTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddUGEducationTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
