//
//  EditPresentationTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 12/14/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol EditPresentationTableViewCellDelegate {
	func editButtonEnabled(isEnabled: Bool)
	func sectionsAndSubSections(tag: Int, sectionName: String)
	func updateKeywords(keywords: [String])
	func updateDescription(description: String)
	func updateUniverisity(univerisity: String)
	func updateTitle(title: String)
	func updatePresentationDetails()
	func updateDownloadStatus(tag: Int)
	func selectCoAuthorsFromDropDown(tag: Int)
	func addCoAuthorsToPresentation()
	func removeSubSection(subSections: [String])
}
class EditPresentationTableViewCell: UITableViewCell {
	@IBOutlet weak var titleTF: UITextField!
	@IBOutlet weak var sectionTitleTF: UITextField!
    @IBOutlet weak var keywordsTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
	@IBOutlet weak var universityTF: UITextField!
	@IBOutlet weak var coAuthorsTF: UITextField!
	@IBOutlet weak var allowDownloadableTF: UITextField!
	@IBOutlet weak var subSectionsCV: UICollectionView!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var sectionDropDownButton: UIButton!
	@IBOutlet weak var subSectionDropDownButton: UIButton!
	@IBOutlet weak var downloadDropDownButton: UIButton!
	@IBOutlet weak var saveButtonConstraintH: NSLayoutConstraint!
	@IBOutlet weak var coAuthorsConstraintY: NSLayoutConstraint!
	@IBOutlet weak var selectedCoAuthorsTextLabel: UILabel!
	@IBOutlet weak var subSectionTextLabel: UILabel!
	var subSections: [String: Any] = [:]
	var selectedSubsections: [String] = []
	var selectedCoauthors: [[String: Any]] = []
	var delegate: EditPresentationTableViewCellDelegate?
	var editButtonEnabled: Bool = false
	var myController: UIViewController?
	@IBOutlet weak var subSectionConstraintY: NSLayoutConstraint!
	var isSubSectionEmpty: Bool = false {
		didSet{
			self.subSectionConstraintY.constant = isSubSectionEmpty ? 60 : 20
		}
	}
	func setUI(dict: [String: Any]) {
		
		editButton.isHidden = editButtonEnabled
		saveButtonConstraintH.constant = editButtonEnabled ? 36 : 0
		titleTF.isUserInteractionEnabled = editButtonEnabled
		keywordsTF.isUserInteractionEnabled = editButtonEnabled
		descriptionTF.isUserInteractionEnabled = editButtonEnabled
		universityTF.isUserInteractionEnabled = editButtonEnabled
		sectionDropDownButton.isHidden = !editButtonEnabled
		subSectionDropDownButton.isHidden = !editButtonEnabled
		downloadDropDownButton.isHidden = !editButtonEnabled
		
		titleTF.text = dict["title"] as? String ?? ""
		sectionTitleTF.text = dict["section"] as? String ?? ""
		if let keywords = dict["keywords"] as? [String] {
            keywordsTF?.text = keywords.joined(separator: ",")
        }
		
		coAuthorsTF.isHidden = true
		coAuthorsConstraintY.constant = 20
		
		if let coauthors = dict["co_authors"] as? [[String: Any]], coauthors.count > 0 {
			let coAuthorsNames = coauthors.map { $0["full_name"] as? String ?? "" }
			coAuthorsTF.isHidden = false
			coAuthorsConstraintY.constant = 95
			coAuthorsTF?.text = "\(coAuthorsNames.joined(separator: ","))"
        }
		
		if selectedCoauthors.count > 0{
			let coAuthorsNames = selectedCoauthors.map { $0["full_name"] as? String ?? "" }
			if coAuthorsNames.count >= 2 {
				selectedCoAuthorsTextLabel.text = "\(coAuthorsNames[0]) +\(coAuthorsNames.count - 1)".capitalized
			}
			else {
				selectedCoAuthorsTextLabel.text = "\(coAuthorsNames[0])".capitalized
			}
		}
		else{
			selectedCoAuthorsTextLabel.text = "No co-author added"
		}
		descriptionTF.text = dict["description"] as? String ?? ""
		universityTF.text = dict["university"] as? String ?? ""
		allowDownloadableTF.text = (dict["is_downloadable"] as? Bool ?? false) ? "Yes" : "No"
		selectedSubsections = dict["sub_sections"] as? [String] ?? []
		isSubSectionEmpty = selectedSubsections.isEmpty ? true : false
		subSectionTextLabel.text = isSubSectionEmpty ? " Sub-section(s)*" : "Sub-section(s)*".uppercased()
		subSectionsCV.reloadData()
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func editButtonAction(_ sender: UIButton) {
		delegate?.editButtonEnabled(isEnabled: true)
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		var isValidatedAllFields = true
		if titleTF.text == "" {
			isValidatedAllFields = false
        }
        else if sectionTitleTF.text == "" {
            isValidatedAllFields = false
        }
        else if selectedSubsections.count == 0 {
            isValidatedAllFields = false
        }
		else if keywordsTF.text == "" {
			isValidatedAllFields = false
		}
		else if descriptionTF.text == "" {
			isValidatedAllFields = false
		}
		if isValidatedAllFields{
			delegate?.updatePresentationDetails()
		}
		else{
			ILUtility.showAlert(message: "Please enter all mandatory fields.", controller: myController!)
		}
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		delegate?.editButtonEnabled(isEnabled: false)
	}
	
	@IBAction func selectSectionsAndSubSections(_ sender: UIButton) {
		delegate?.sectionsAndSubSections(tag: sender.tag, sectionName: sectionTitleTF.text!)
    }
	
	@IBAction func textDidChange(_ textFeild: UITextField) {
		if textFeild == titleTF{
			delegate?.updateTitle(title: titleTF.text!)
		}
		if textFeild == keywordsTF{
			delegate?.updateKeywords(keywords: keywordsTF.text?.components(separatedBy: ",") ?? [])
		}
		if textFeild == descriptionTF{
			delegate?.updateDescription(description: descriptionTF.text!)
		}
		if textFeild == universityTF{
			delegate?.updateUniverisity(univerisity: universityTF.text!)
		}
	}
	
	@IBAction func selectDownloadStatus(_ sender: UIButton) {
		delegate?.updateDownloadStatus(tag: sender.tag)
    }
	
	@IBAction func selectCoAuthors(_ sender: UIButton) {
		delegate?.selectCoAuthorsFromDropDown(tag: sender.tag)
    }
	
	@IBAction func addCoAuthors(_ sender: UIButton) {
		delegate?.addCoAuthorsToPresentation()
    }
	
	@objc func removeSubSectionAction(_ sender: UIButton){
		selectedSubsections.remove(at: sender.tag)
		delegate?.removeSubSection(subSections: selectedSubsections)
		isSubSectionEmpty = selectedSubsections.isEmpty ? true : false
		subSectionsCV.reloadData()
	}
}

extension EditPresentationTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! KeywordsCVCell
        cell.nameButton.setTitle("    \(selectedSubsections[indexPath.item])   ✕    ", for: .normal)
		cell.nameButton.tag = indexPath.item
		cell.nameButton.addTarget(self, action: #selector(removeSubSectionAction), for: .touchUpInside)
        cell.SetUI()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSubsections.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ("    \(selectedSubsections[indexPath.item])    ✕    ").size(withAttributes: nil)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
