//
//  EditPGEducationTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/16/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol EditPGEducationTableViewCellDelegate {
	func savePGEducation(dict: [String: Any], at index: Int)
	func deletePGEducation(dict: [String : Any], at index: Int)
	func editPGEducation(at index: Int)
	func cancelPGEducation()
}

class EditPGEducationTableViewCell: UITableViewCell {
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
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	var isEditMode: Bool = false
	var vc: UIViewController?
	var fileUrl: URL?
	var delegate: AddOrUpdatePGEducationTvCellDelegate?
	var editPGEducationdelegate: EditPGEducationTableViewCellDelegate?
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
		
		disableView.isHidden = isEditMode
		editButton.isHidden = isEditMode
		cancelButton.isHidden = !isEditMode
		
		countryTF.text = dict["country"] as? String ?? ""
		cityTF.text = dict["city"] as? String ?? ""
		schoolTF.text = dict["school"] as? String ?? ""
		specializationTF.text = dict["pg_specialization"] as? String ?? ""
		fromYearTF.text = dict["period_start"] as? String ?? ""
		endYearTF.text = dict["period_end"] as? String ?? ""
		
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		let files = dict["certificate"] as? [String] ?? []
		if files.count > 0 {
			fileNameLabel.text = files[0]
			removeFileButton.isHidden = false
		}
		
		let graduation_type = dict["graduation_type"] as? String ?? ""
		let graduated = dict["graduated"] as? String ?? "false"
		if graduation_type == "Residency" {
			residencyTypeButton.isSelected = true
		}
		else {
			fellowshipTypeButton.isSelected = true
		}
		graduatedButton.isSelected = (graduated == "true") ? true : false
		enableOrDisableSaveButton()
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
		"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
		"post_data[status]":true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
		}
		editPGEducationdelegate?.savePGEducation(dict: requestDict, at: sender.tag)
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		editPGEducationdelegate?.cancelPGEducation()
	}
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		editPGEducationdelegate?.editPGEducation(at: sender.tag)
	}
	
	@IBAction func deleteButtonAction(_ sender: UIButton) {
		editPGEducationdelegate?.deletePGEducation(dict: ["type" : "education","subtype" : "PG","status":"delete"], at: sender.tag)
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
}

extension EditPGEducationTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditPGEducationTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}
