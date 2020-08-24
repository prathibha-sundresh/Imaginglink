//
//  AddPGEducationTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/16/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol AddOrUpdatePGEducationTvCellDelegate {
	func AddOrUpdatePGEducation(dict: [String: Any])
	func chooseCountry()
	func chooseCity(of country: String)
	func chooseSchool(of country: String, and city: String)
}

class AddPGEducationTableViewCell: UITableViewCell {
	@IBOutlet weak var countryTF: FloatingLabel!
	@IBOutlet weak var cityTF: FloatingLabel!
	@IBOutlet weak var schoolTF: FloatingLabel!
	@IBOutlet weak var specializationTF: FloatingLabel!
	@IBOutlet weak var fromYearTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var graduatedButton: UIButton!
	@IBOutlet weak var residencyTypeButton: UIButton!
	@IBOutlet weak var fellowshipTypeButton: UIButton!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	var delegate: AddOrUpdatePGEducationTvCellDelegate?
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
		countryTF.text = ""
		cityTF.text = ""
		schoolTF.text = ""
		specializationTF.text = ""
		fromYearTF.text = ""
		endYearTF.text = ""
		graduatedButton.isSelected = false
		residencyTypeButton.isSelected = false
		fellowshipTypeButton.isSelected = false
		removeFileButton.isHidden = true
		fileNameLabel.text = ""
	}
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var requestDict = [
		"type":"education",
		"education_type":"PG",
		"post_data[country]":countryTF.text!,
		"post_data[city]":cityTF.text!,
		"post_data[school]": schoolTF.text!,
		"post_data[pg_specialization]": specializationTF.text!,
		"post_data[period_start]":fromYearTF.text!,
		"post_data[period_end]":endYearTF.text!,
		"post_data[graduated]":graduatedButton.isSelected,
		"post_data[graduation_type]":residencyTypeButton.isSelected ? "Residency" : "Fellowship",
		"post_data[status]":false] as [String : Any]
		if fileNameLabel.text! != "No file selected" {
			requestDict["source_file_name[]"] = fileUrl
		}
		delegate?.AddOrUpdatePGEducation(dict: requestDict)
	}
	
	@IBAction func graduatedAction(_ sender: UIButton) {
		graduatedButton.isSelected = !sender.isSelected
	}
	
	@IBAction func graduatedTypeAction(_ sender: UIButton) {
		residencyTypeButton.isSelected = false
		fellowshipTypeButton.isSelected = false
		sender.isSelected = true
	}
	
	@IBAction func selectCountryButtonAction(_ sender: UIButton) {
		delegate?.chooseCountry()
	}
	
	@IBAction func selectCityButtonAction(_ sender: UIButton) {
		delegate?.chooseCity(of : countryTF.text!)
	}
	
	@IBAction func selectSchoolButtonAction(_ sender: UIButton) {
		delegate?.chooseSchool(of: countryTF.text!, and: cityTF.text!)
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
extension AddPGEducationTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension AddPGEducationTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
