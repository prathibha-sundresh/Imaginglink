//
//  UserPortFolioViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class UserPortFolioViewController: UIViewController {
	@IBOutlet weak var userPortFolioTableview: UITableView!
	@IBOutlet weak var folioProgressView: UIProgressView!
	@IBOutlet weak var folioProgressLabel: UILabel!
	var contactPersonalInfoCell: ContactPersonalInfoTableViewCell!
	
	var userPortFolioArray: [String] = ["Summary", "Contact & Personal Info", "Under Graduate","Post Graduate","Subspecialties", "Recreational Interests", "Academic Appointments", "Hospital Appointments","Honor/Awards", "Certifications","Licenses","Committees","Teaching Responsibilities","Major Mentoring Activities","Administrative Responsibilities","Professional Societies","Editorial Boards","Grant Or Fund details","Invited Lectures & Presentations","Congressional Testimony","Congressional Testimony","Media Appearances","Custom Fields","Bibliography","CME Tracking"]
	var expandedArray: [Int] = []
	var dataDict = [String: Any]()
	var commonArray: [[String: Any]] = []
	var editRowForSecction : Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
		getFolioDetails()
		
        // Do any additional setup after loading the view.
    }
	
	func getFolioDetails() {
		ILUtility.showProgressIndicator(controller: self)
		PortFolioAPI.sharedManaged.getPortFolioDetails(successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any]{
				self.dataDict = dict1
				self.setUIResponse()
            }
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func addPortFolioDetails(requestDict: [String: Any], of type: String) {
		ILUtility.showProgressIndicator(controller: self)
		PortFolioAPI.sharedManaged.addPortFolioDetails(requestDict: requestDict, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let responseDict = response["data"] as? [String: Any] {
				self.updateSectionResponse(for: type, responseTypeDict: responseDict)
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func setUIResponse(_ type: String = "") {
		let portfolioCompletion = dataDict["portfolioCompletion"] as? Int ?? 0
		folioProgressLabel.text = "\(portfolioCompletion)% Profile Completed"
		folioProgressView.progress = Float(30) / Float(100)
		folioProgressView.layer.cornerRadius = 4.0
		folioProgressView.clipsToBounds = true
		if let tmpDict = self.dataDict[type] as? [String: Any]{
			self.commonArray = tmpDict["data"] as? [[String: Any]] ?? []
		}
		getSectionTypeData(type)
	}
    
	func updateSectionResponse(for type: String, responseTypeDict: [String: Any]) {
		if let typeDict = responseTypeDict[type] as? [String: Any] {
			self.dataDict[type] = typeDict
		}
		if let portfolioCompletion = responseTypeDict["portfolioCompletion"] as? Int {
			self.dataDict["portfolioCompletion"] = portfolioCompletion
		}
		setUIResponse(type)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "DatePickerVCID" {

			let vc = segue.destination as! SelectDateViewController
			vc.callBack = { (day, month, year) in
				let contactPersonalInfoCell: ContactPersonalInfoTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: 0, section: 1)) as! ContactPersonalInfoTableViewCell
				contactPersonalInfoCell.dayTF.text = day
				contactPersonalInfoCell.monthTF.text = month
				contactPersonalInfoCell.yearTF.text = year
			}
		}
		if segue.identifier == "PopUpVCID" {
			
			let vc = segue.destination as! CustomPopUpViewController
//			if let tag = sender as? Int {
//				switch tag {
//				case 100:
//					let y = Int(contactPersonalInfoCell.yearTF.text!)
//					let m = Int(contactPersonalInfoCell.monthTF.text!)
//					let dateComponents = DateComponents(year: 1992, month: 2)
//					let calendar = Calendar.current
//					let date = calendar.date(from: dateComponents)!
//
//					let range = calendar.range(of: .day, in: .month, for: date)!
//					var daysArray = [String]()
//					for i in 1...range.count {
//						daysArray.append("\(i)")
//					}
//					vc.titleArray = daysArray
//				case 101:
//					vc.titleArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
//				case 102:
//					let format = DateFormatter()
//					format.dateFormat = "yyyy"
//					var yearsArray = [String]()
//					if let currentYear = Int(format.string(from: Date())) {
//						for i in 1900...currentYear {
//							yearsArray.append("\(i)")
//						}
//					}
//					vc.titleArray = yearsArray
//				default:
//					vc.titleArray = ["Male", "Female"]
//					vc.selectedRowTitles = [contactPersonalInfoCell.genderTF.text!]
//				}
//			}
			vc.titleArray = ["Male", "Female"]
			vc.selectedRowTitles = [contactPersonalInfoCell.genderTF.text!]
			vc.selectionType = .Single
            vc.callBack = { (titles) in
				self.contactPersonalInfoCell.genderTF.text = titles[0]
            }
		}
    }
	
}

extension UserPortFolioViewController: UITableViewDataSource,UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			let cell : SummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCellID", for: indexPath) as! SummaryTableViewCell
			cell.delegate = self
			cell.setUI(dict: dataDict)
			return cell
		}
		else if indexPath.section == 4 {
			if indexPath.row == commonArray.count {
				let cell : AddSubSpecialitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddSubSpecialitiesTableViewCellID", for: indexPath) as! AddSubSpecialitiesTableViewCell
				cell.delegate = self
				cell.setUI()
				return cell
			}
			else {
				let cell : EditSubSpecialitiesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditSubSpecialitiesTableViewCellID", for: indexPath) as! EditSubSpecialitiesTableViewCell
				cell.delegate = self
				cell.deleteButton.tag = indexPath.row
				cell.isEditForSubSpecialties = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 5 {
			let cell : AddAdditionalInterestsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddAdditionalInterestsTableViewCellID", for: indexPath) as! AddAdditionalInterestsTableViewCell
			cell.delegate = self
			cell.setUI(dict: dataDict)
			return cell
		}
		else if indexPath.section == 6 || indexPath.section == 7 {
			
			if indexPath.row == commonArray.count {
				let cell : AddHospitalAppointmentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddHospitalAppointmentsTableViewCellID", for: indexPath) as! AddHospitalAppointmentsTableViewCell
				cell.delegate = self
				indexPath.section == 6 ? (cell.sectionType) = "academic_appointments" : (cell.sectionType = "hospital_appointments")
				cell.setUI()
				return cell
			}
			else {
				let cell : EditHospitalORAcademicAppointmentsTVCell = tableView.dequeueReusableCell(withIdentifier: "EditHospitalORAcademicAppointmentsTVCellID", for: indexPath) as! EditHospitalORAcademicAppointmentsTVCell
				cell.delegate = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				indexPath.section == 6 ? (cell.sectionType) = "academic_appointments" : (cell.sectionType = "hospital_appointments")
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 8 {
			if indexPath.row == commonArray.count {
				let cell : AddHonorAwardsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddHonorAwardsTableViewCellID", for: indexPath) as! AddHonorAwardsTableViewCell
				cell.delegate = self
				cell.setUI()
				return cell
			}
			else {
				let cell : EditHonorAwardsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditHonorAwardsTableViewCellID", for: indexPath) as! EditHonorAwardsTableViewCell
				cell.delegate = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else {
			contactPersonalInfoCell = tableView.dequeueReusableCell(withIdentifier: "ContactPersonalInfoTableViewCellID", for: indexPath) as? ContactPersonalInfoTableViewCell
			contactPersonalInfoCell.delegate = self
			contactPersonalInfoCell.setUI(dict: dataDict)
			return contactPersonalInfoCell
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return userPortFolioArray.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if expandedArray.contains(section) {
			if section == 0 || section == 1 {
				return 1
			}
			return commonArray.count + 1
			
		}
		else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerTitle = userPortFolioArray[section]
		//let height = headerTitle.height(withConstrainedWidth: userPortFolioTableview.frame.width - 50, font: UIFont(name: "GoogleSans-Medium", size: 14.0)!) + 30
		let view = UIView(frame: CGRect(x: 10, y: 0, width: userPortFolioTableview.frame.width - 50, height: 50))
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		view.clipsToBounds = true
		let label = UILabel(frame: view.frame)
		label.font = UIFont(name: "GoogleSans-Medium", size: 16.0)!
		label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
		label.numberOfLines = 0
		label.text          = headerTitle
		view.addSubview(label)
		let btn = UIButton(type: .custom)
		btn.frame = CGRect(x: 0, y: 0, width: userPortFolioTableview.frame.width, height: 50)
		btn.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
		btn.tag = section
		view.addSubview(btn)
		let plusImage = UIImageView(frame: CGRect(x: userPortFolioTableview.frame.width - 25, y: 18, width: 15, height: 15))
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
	
	@objc func expandButtonAction(_ sender: UIButton) {
		
		if expandedArray.contains(sender.tag) {
			expandedArray.removeAll()
		}
		else{
			expandedArray.removeAll()
			expandedArray.append(sender.tag)
		}
		
		if sender.tag == 0 {
			userPortFolioTableview.reloadData()
		}
		else if sender.tag == 1 {
			userPortFolioTableview.reloadData()
		}
		else if sender.tag == 2 {
			
		}
		else if sender.tag == 3 {
			
		}
		else if sender.tag == 4 {
			getSectionTypeData("sub_speciality")
		}
		else if sender.tag == 5 {
			getSectionTypeData("recreational_interests")
		}
		else if sender.tag == 6 {
			getSectionTypeData("academic_appointments")
		}
		else if sender.tag == 7 {
			getSectionTypeData("hospital_appointments")
		}
		else if sender.tag == 8 {
			getSectionTypeData("honor_awards")
		}
		else if sender.tag == 9 {
			
		}
	}
	
	func getSectionTypeData(_ sectionType: String) {
		commonArray = []
		if let dict = self.dataDict[sectionType] as? [String: Any]{
			commonArray = dict["data"] as? [[String: Any]] ?? []
		}
		editRowForSecction = -1
		userPortFolioTableview.reloadData()
	}
}

extension UserPortFolioViewController: SummaryTableViewCellDelegate {
	func saveSummaryText(dict: [String : Any]) {
		addPortFolioDetails(requestDict: dict, of: "overview")
	}
}

extension UserPortFolioViewController: ContactPersonalInfoTableViewCellDelegate {
	func openDate() {
		//self.performSegue(withIdentifier: "PopUpVCID", sender: 100)
		self.performSegue(withIdentifier: "DatePickerVCID", sender: nil)
	}
	
	func openMonth() {
		//self.performSegue(withIdentifier: "PopUpVCID", sender: 101)
		self.performSegue(withIdentifier: "DatePickerVCID", sender: nil)
	}
	
	func openYear() {
		//self.performSegue(withIdentifier: "PopUpVCID", sender: 102)
		self.performSegue(withIdentifier: "DatePickerVCID", sender: nil)
	}
	
	func saveContactPersonalInfo(dict: [String : Any]) {
		addPortFolioDetails(requestDict: dict, of: "contact_and_personal_info")
	}
	
	func openGender() {
		self.performSegue(withIdentifier: "PopUpVCID", sender: nil)
	}

}

extension UserPortFolioViewController: EditSubSpecialitiesTableViewCellDelegate {
	
	func saveSubSpecialities(dict: [String : Any], at index: Int) {
		let tmpDict = commonArray[index]
		var requestValues = dict
		if let id = tmpDict["id"] as? String {
			requestValues["post_id"] = id
			addPortFolioDetails(requestDict: requestValues, of: "sub_speciality")
			editRowForSecction = -1
		}
	}
	
	func deleteSubSpecialities(at index: Int) {
		let dict = commonArray[index]
		if let id = dict["id"] as? String {
			let requestDict = ["type" : "sub_speciality", "obj_id": id,"status":"delete"]
			deletePortFolioDetails(inputDict: requestDict, section: "sub_speciality")
		}
	}
	
	func deletePortFolioDetails(inputDict: [String: Any], section: String) {
		ILUtility.showProgressIndicator(controller: self)
		PortFolioAPI.sharedManaged.deletePortFolioDetails(requestDict: inputDict, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			if let responseDict = response as? [String: Any] {
				self.updateSectionResponse(for: section, responseTypeDict: responseDict)
			}
		}, faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	func editSubSpecialities(at index: Int) {
		editRowForSecction = index
		userPortFolioTableview.reloadData()
	}
	
	func cancelSubSpecialities() {
		editRowForSecction = -1
		userPortFolioTableview.reloadData()
	}
}

extension UserPortFolioViewController: AddSubSpecialitiesTableViewCellDelegate {
	func addSubSpecialities(dict: [String : Any]) {
		addPortFolioDetails(requestDict: dict, of: "sub_speciality")
	}
}

extension UserPortFolioViewController: AddAdditionalInterestsTableViewCellDelegate {
	func addOrRemoveRecreationalInterests(dict: [String : Any]) {
		addPortFolioDetails(requestDict: dict, of: "recreational_interests")
	}
}

extension UserPortFolioViewController: EditAppointmentsTVCellDelegate {
	
	func deleteAppointments(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["obj_id"] = id
			deletePortFolioDetails(inputDict: requestValues, section: dict["type"] as! String)
			editRowForSecction = -1
		}
	}
	
	func editAppointments(at index: Int) {
		editRowForSecction = index
		userPortFolioTableview.reloadData()
	}
	
	func cancelAppointments() {
		editRowForSecction = -1
		userPortFolioTableview.reloadData()
	}
	
	func saveAppointments(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["post_id"] = id
			addPortFolioDetails(requestDict: requestValues, of: dict["type"] as! String)
			editRowForSecction = -1
		}
	}
}

extension UserPortFolioViewController: AddAppointmentsTVCellDelegate {
	func addAppointments(dict: [String: Any]) {
		addPortFolioDetails(requestDict: dict, of: dict["type"] as! String)
	}
}

extension UserPortFolioViewController: EditHonorAwardsTvCellDelegate {
	
	func deleteHonorAwards(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["obj_id"] = id
			deletePortFolioDetails(inputDict: requestValues, section: dict["type"] as! String)
			editRowForSecction = -1
		}
	}
	
	func editHonorAwards(at index: Int) {
		editRowForSecction = index
		userPortFolioTableview.reloadData()
	}
	
	func cancelHonorAwards() {
		editRowForSecction = -1
		userPortFolioTableview.reloadData()
	}
	
	func saveHonorAwards(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["post_id"] = id
			addPortFolioDetails(requestDict: requestValues, of: dict["type"] as! String)
			editRowForSecction = -1
		}
	}
}

extension UserPortFolioViewController: AddHonorAwardsTvCellDelegate {
	func addHonorAwards(dict: [String: Any]) {
		addPortFolioDetails(requestDict: dict, of: dict["type"] as! String)
	}
}
