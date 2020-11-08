//
//  EditFundingTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/19/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditFundingTableViewCell: UITableViewCell {
	@IBOutlet weak var grantNumberTableview: UITableView!
	@IBOutlet weak var startMonthTF: FloatingLabel!
	@IBOutlet weak var startYearTF: FloatingLabel!
	@IBOutlet weak var endMonthTF: FloatingLabel!
	@IBOutlet weak var endYearTF: FloatingLabel!
	@IBOutlet weak var textField1: FloatingLabel!
	@IBOutlet weak var textField2: FloatingLabel!
	@IBOutlet weak var textField3: FloatingLabel!
	@IBOutlet weak var textField4: FloatingLabel!
	@IBOutlet weak var textField5: FloatingLabel!
	@IBOutlet weak var textField6: FloatingLabel!
	@IBOutlet weak var textField7: FloatingLabel!
	@IBOutlet weak var textField8: FloatingLabel!
	@IBOutlet weak var fileNameLabel: UILabel!
	@IBOutlet weak var removeFileButton: UIButton!
	@IBOutlet weak var uploadFileButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var disableView: UIView!
	@IBOutlet weak var addAnotherGrantFooterView: UIView!
	@IBOutlet weak var grantNumberTableviewH: NSLayoutConstraint!
	var delegate: EditSectionTvCellDelegate?
	var addDelegate: AddFundingTableViewCellDelegate?
	var vc: UIViewController?
	var fileUrl: URL?
	var isEditMode: Bool = false
	var grantArray = [[String: Any]]()
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
		
		textField1.text = dict["funding_type"] as? String ?? ""
		textField2.text = dict["funding_subtype"] as? String ?? ""
		textField3.text = dict["title_of_founded_project"] as? String ?? ""
		textField4.text = dict["description"] as? String ?? ""
		textField5.text = dict["total_funding_amount"] as? String ?? ""
		textField6.text = dict["role"] as? String ?? ""
		textField7.text = dict["agency_name"] as? String ?? ""
		textField8.text = dict["alternate_url"] as? String ?? ""
		if let startDateDict = dict["start_date"] as? [String: Any] {
			startMonthTF.text = startDateDict["mm"] as? String ?? ""
			startYearTF.text = startDateDict["yy"] as? String ?? ""
		}
		if let endDateDict = dict["end_date"] as? [String: Any] {
			endMonthTF.text = endDateDict["mm"] as? String ?? ""
			endYearTF.text = endDateDict["yy"] as? String ?? ""
		}
		removeFileButton.isHidden = true
		fileNameLabel.text = "No file selected"
		grantArray = dict["grant_number"] as? [[String: Any]] ?? []
		grantArray.append(["id": "\(grantArray.count)","grantnumber": "","granturl": ""])
		grantNumberTableview.reloadData()
		enableOrDisableSaveButton()
	}
	
	@IBAction func selectFundingTypeButtonAction(_ sender: UIButton) {
		vc?.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "Funding Type"])
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var requestDict = [
			"type":"grant_or_fund_details",
			"post_data[funding_type]" : textField1.text!,
			"post_data[funding_subtype]" : textField2.text!,
			"post_data[title_of_founded_project]" : textField3.text!,
			"post_data[description]" : textField4.text!,
			"post_data[total_funding_amount]" : textField5.text!,
			"post_data[role]" : textField6.text!,
			"post_data[agency_name]" : textField7.text!,
			"post_data[start_date][mm]":startMonthTF.text!,
			"post_data[start_date][yy]":startYearTF.text!,
			"post_data[end_date][mm]":endMonthTF.text!,
			"post_data[end_date][yy]":endYearTF.text!,
			"post_data[alternate_url]" : textField8.text!,
			"source_file_name[]" : fileUrl ?? fileNameLabel.text!,
			"post_data[status]" : true] as [String : Any]
		if fileNameLabel.text! == "No file selected" {
			requestDict["source_file_name[]"] = nil
		}
		for i in 0..<grantArray.count {
			requestDict["post_data[grant_number][\(i)][id]"] = grantArray[i]["id"] as? String ?? ""
			requestDict["post_data[grant_number][\(i)][grantnumber]"] = grantArray[i]["grantnumber"] as? String ?? ""
			requestDict["post_data[grant_number][\(i)][granturl]"] = grantArray[i]["granturl"] as? String ?? ""
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
	
	@IBAction func textDidChange(_ textField: UITextField) {
		enableOrDisableSaveButton()
	}
	
	func enableOrDisableSaveButton() {
		
		if startMonthTF.text != "" && startYearTF.text != "" && endMonthTF.text != "" && endYearTF.text != "" && textField1.text != "" && textField2.text != "" && textField3.text != "" && textField4.text != "" && textField5.text != "" && textField6.text != "" && textField7.text != "" && textField8.text != "" {
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
		delegate?.deleteSection(dict: ["type" : "grant_or_fund_details","status":"delete"], at: sender.tag)
	}
	
	@IBAction func addAnotherGrantNoButtonAction(_ sender: UIButton) {
		grantArray.append(["cell\(grantArray.count)":"empty"])
		grantNumberTableview.reloadData()
	}
}

extension EditFundingTableViewCell: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return textField.validateNumber(placeholderType: textField.placeholder!, str: string, range: range)
	}
}

extension EditFundingTableViewCell: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		fileUrl = url
		fileNameLabel.text = url.lastPathComponent
		removeFileButton.isHidden = false
	}
}

extension EditFundingTableViewCell: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return grantArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell : GrantNumberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GrantNumberTableViewCellID", for: indexPath) as! GrantNumberTableViewCell
		cell.delegate = self
		cell.removeButton.tag = indexPath.row
		let dict = grantArray[indexPath.row]
		cell.tag = Int(dict["id"] as? String ?? "\(indexPath.row)") ?? indexPath.row
		cell.setUI(dict: grantArray[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 150
	}
}

extension EditFundingTableViewCell: GrantNumberTableViewCellDelegate {
	func saveDetails(cell: GrantNumberTableViewCell) {
		let tmpDict = ["id": "\(cell.tag)","grantnumber": cell.textField1.text!,"granturl": cell.textField2.text!]
		if let index = grantArray.firstIndex(where: { $0["id"] as! String == "\(cell.tag)"}) {
			grantArray[index] = tmpDict
		}
	}
	
	func removeGrantNumber(at Index: Int) {
		if grantArray.count > 1 {
			grantArray.remove(at: Index)
			grantNumberTableview.reloadData()
		}
	}
}
