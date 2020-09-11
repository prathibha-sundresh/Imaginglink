//
//  EducationTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol EducationTableViewCellDelegate {
	func saveSchool(requestdict: [String: Any])
	func deleteSchool(requestdict: [String : Any])
	func updateCellHeight(height: CGFloat, section: Int)
}

class EducationTableViewCell: UITableViewCell {
	@IBOutlet weak var tableview: UITableView!
	var sectionArray = ["PRE MEDICAL SCHOOL", "MEDICAL SCHOOL","INTERNSHIP"]
	var expandedArray: [Int] = []
	var dataDict = [String: Any]()
	var dataArray: [[String: Any]] = []
	var commonArray: [[String: Any]] = []
	var delegate: AddOrUpdatePGEducationTvCellDelegate?
	var cellDelegate: EducationTableViewCellDelegate?
	var addUGEducationTableViewCell: AddUGEducationTableViewCell!
	@IBOutlet weak var tableviewH: NSLayoutConstraint!
	var vc: UIViewController?
	var editRowForSecction : Int = -1
    override func awakeFromNib() {
        super.awakeFromNib()
		
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI(height: CGFloat, section: Int) {
		tableview.tableFooterView = UIView(frame: .zero)
		setData(at: section)
		let sectionHeight = CGFloat((commonArray.count + 1) * 430)
		tableviewH.constant = expandedArray.count > 0 ? sectionHeight : 150
	}
}

extension EducationTableViewCell: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var type = "pre-medical"
		if indexPath.section == 1 {
			type = "medical"
		}
		else if indexPath.section == 2 {
			type = "internship"
		}
		if indexPath.row == commonArray.count {
			let cell : AddUGEducationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddUGEducationTableViewCellID", for: indexPath) as! AddUGEducationTableViewCell
			cell.schoolType = type
			cell.delegate = self
			cell.vc = vc
			cell.setUI()
			addUGEducationTableViewCell = cell
			return cell
		}
		else {
			let cell : EditUGEducationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditUGEducationTableViewCellID", for: indexPath) as! EditUGEducationTableViewCell
			cell.delegate = self
			cell.schoolType = type
			cell.vc = vc
			cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
			cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
			return cell
		}
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if expandedArray.contains(section) {
			return commonArray.count + 1
			
		}
		else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerTitle = sectionArray[section]
		let view = UIView(frame: CGRect(x: 10, y: 0, width: tableview.frame.width - 50, height: 50))
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		view.clipsToBounds = true
		let label = UILabel(frame: view.frame)
		label.font = UIFont(name: "GoogleSans-Medium", size: 13.0)!
		label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
		label.numberOfLines = 0
		label.text          = headerTitle
		view.addSubview(label)
		let btn = UIButton(type: .custom)
		btn.frame = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 50)
		btn.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
		btn.tag = section
		view.addSubview(btn)
		let plusImage = UIImageView(frame: CGRect(x: tableview.frame.width - 25, y: 18, width: 15, height: 15))
		plusImage.contentMode = .scaleAspectFit
		if expandedArray.contains(section) {
			plusImage.image = UIImage(named: "expand_arrow_image")
		}
		else {
			plusImage.image = UIImage(named: "collapse_arrow_image")
		}
		view.backgroundColor = .white
		view.addSubview(plusImage)
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func setData(at section: Int) {
		if !expandedArray.contains(section) {
			expandedArray.removeAll()
			expandedArray.append(section)
		}
		
		commonArray = []
		var schoolType = "pre-medical"
		if section == 1 {
			schoolType = "medical"
		}
		else if section == 2 {
			schoolType = "internship"
		}
		let results = dataArray.filter { (dict) -> Bool in
			return dict["school_type"] as? String ?? "" == schoolType
		}
		commonArray = results
		tableview.reloadData()
	}
	
	@objc func expandButtonAction(_ sender: UIButton) {
		setData(at: sender.tag)
		let sectionHeight = CGFloat((commonArray.count + 1) * 430)
		cellDelegate?.updateCellHeight(height: expandedArray.count > 0 ? sectionHeight : 150, section: sender.tag)
	}
}

extension EducationTableViewCell: AddUGEducationTvCellDelegate, EditUGEducationTvCellDelegate {
	func saveUgSection(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["post_id"] = id
			editRowForSecction = -1
			cellDelegate?.saveSchool(requestdict: requestValues)
		}
	}
	
	func deleteUgSection(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["obj_id"] = id
			cellDelegate?.deleteSchool(requestdict: requestValues)
			editRowForSecction = -1
		}
	}
	
	func editUgSection(at index: Int) {
		editRowForSecction = index
		tableview.reloadData()
	}
	
	func cancelUgSection() {
		editRowForSecction = -1
		tableview.reloadData()
	}
	
	func addUG(dict: [String : Any]) {
		delegate?.AddOrUpdatePGEducation(dict: dict)
	}
}
