//
//  ContactPersonalInfoTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/7/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol ContactPersonalInfoTableViewCellDelegate {
	func saveContactPersonalInfo(dict: [String: Any])
	func openDate()
	func openMonth()
	func openYear()
	func openGender()
}

class ContactPersonalInfoTableViewCell: UITableViewCell {
	@IBOutlet weak var countryCodeTF: FloatingLabel!
	@IBOutlet weak var mobileNoTF: FloatingLabel!
	@IBOutlet weak var emailTF: FloatingLabel!
	@IBOutlet weak var countryTF: FloatingLabel!
	@IBOutlet weak var addressTF: FloatingLabel!
	@IBOutlet weak var dayTF: FloatingLabel!
	@IBOutlet weak var monthTF: FloatingLabel!
	@IBOutlet weak var yearTF: FloatingLabel!
	@IBOutlet weak var genderTF: FloatingLabel!
	@IBOutlet weak var hideYearButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	var post_id: String?
	var delegate: ContactPersonalInfoTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setUI(dict: [String : Any]) {
				
		let tmpDict = dict["contact_and_personal_info"] as? [String: Any] ?? [:]
		if tmpDict.keys.count == 0 {
			// add personal_info
			post_id = ""
		}
		else {
			// edit personal_info
			post_id = dict["_id"] as? String ?? ""
		}
		let personalInfoDict = tmpDict["data"] as? [String: Any] ?? [:]
		mobileNoTF.text = personalInfoDict["phone"] as? String ?? ""
		emailTF.text = personalInfoDict["email"] as? String ?? ""
		countryTF.text = personalInfoDict["country"] as? String ?? ""
		addressTF.text = personalInfoDict["address"] as? String ?? ""
		dayTF.text = personalInfoDict["dd"] as? String ?? ""
		monthTF.text = personalInfoDict["dd"] as? String ?? ""
//		if let monthNumber = Int((personalInfoDict["mm"] as? String)!) {
//			let df = DateFormatter()
//			df.dateFormat = "MMMM"
//			let month = df.monthSymbols[monthNumber - 1]
//			monthTF.text = month
//		}
		yearTF.text = personalInfoDict["yy"] as? String ?? ""
		genderTF.text = (personalInfoDict["gender"] as? String ?? "").capitalized
		self.layer.borderWidth = 1.0
		self.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		self.clipsToBounds = true
		
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
//		let df = DateFormatter()
//		df.dateFormat = "MM"
//		let date = df.date(from: monthTF.text!)
//		let month = Calendar.current.component(.month, from: date!)
		var requestDict = [
		"type":"personal_info",
		"post_data[phone]":mobileNoTF.text!,
		"post_data[email]":emailTF.text!,
		"post_data[address]": addressTF.text!,
		"post_data[hide_year]":hideYearButton.isSelected,
		"post_data[gender]":genderTF.text!.lowercased(),
		"post_data[dd]":dayTF.text!,
		"post_data[mm]":monthTF.text!,
		"post_data[yy]":yearTF.text!,
		"post_data[country]":countryTF.text!,
		"post_data[status]":false] as [String : Any]
		
		if post_id != "" {
			requestDict["post_id"] = post_id
			requestDict["post_data[status]"] = true
		}
		delegate?.saveContactPersonalInfo(dict: requestDict)
	}
	
	@IBAction func dateDropDownAction(_ sender: UIButton) {
		delegate?.openDate()
	}
	
	@IBAction func monthDropDownAction(_ sender: UIButton) {
		delegate?.openMonth()
	}
	
	@IBAction func yearDropDownAction(_ sender: UIButton) {
		delegate?.openYear()
	}
	
	@IBAction func genderDropDownAction(_ sender: UIButton) {
		delegate?.openGender()
	}
	
	@IBAction func hideYearAction(_ sender: UIButton) {
		sender.isSelected = !sender.isSelected
        if sender.isSelected {
            hideYearButton.setImage(#imageLiteral(resourceName: "ClickedCheckBox"), for: UIControl.State.normal)
        } else {
            hideYearButton.setImage(#imageLiteral(resourceName: "unCheckedBox"), for: UIControl.State.normal)
        }
    }
}

extension ContactPersonalInfoTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension UITextField {
	func validateNumber(placeholderType: String, str: String, range: NSRange) -> Bool {
		if placeholderType == "Mobile No" || placeholderType == "DD" || placeholderType == "MM" || placeholderType == "YYYY" {
			let allowedCharacters = "1234567890"
			let allowedCharcterSet = CharacterSet(charactersIn: allowedCharacters)
			let typedCharcterSet = CharacterSet(charactersIn: str)
			
			var maxLength = 0
			if placeholderType == "Mobile No" {
				maxLength = 10
			}
			else if placeholderType == "DD" || placeholderType == "MM" {
				maxLength = 2
			}
			else if placeholderType == "YYYY" {
				maxLength = 4
			}
			let currentString: NSString = self.text! as NSString
			let newString: NSString =
				currentString.replacingCharacters(in: range, with: str) as NSString
			return allowedCharcterSet.isSuperset(of: typedCharcterSet) && newString.length <= maxLength
		}
		return true
	}
}
