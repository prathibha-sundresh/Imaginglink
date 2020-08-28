//
//  UserPortFolioViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class UserPortFolioViewController: UIViewController {
	@IBOutlet weak var userPortFolioTableview: UITableView!
	@IBOutlet weak var folioProgressView: UIProgressView!
	@IBOutlet weak var folioProgressLabel: UILabel!
	var contactPersonalInfoCell: ContactPersonalInfoTableViewCell!
	var addPGEducationTableViewCell: AddPGEducationTableViewCell!
	var userPortFolioArray: [String] = ["Summary", "Contact & Personal Info", "Under Graduate","Post Graduate","Subspecialties", "Recreational Interests", "Academic Appointments", "Hospital Appointments","Honor/Awards", "Certifications","Licenses","Committees","Teaching Responsibilities","Major Mentoring Activities","Administrative Responsibilities","Professional Societies","Editorial Boards","Grant Or Fund details","Invited Lectures & Presentations","Congressional Testimony","Media Appearances","Custom Fields","Bibliography","CME Tracking"]
	var expandedArray: [Int] = []
	var dataDict = [String: Any]()
	var commonArray: [[String: Any]] = []
	var pgDataArray: [[String: Any]] = []
	var countryListArray: [String] = []
	var editRowForSecction : Int = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getFolioDetails()
		getPGList()
        // Do any additional setup after loading the view.
    }
	
	func getPGList() {
		if let url = Bundle.main.url(forResource: "portfolio_pg_countries", withExtension: "json") {
			do {
				let data = try Data(contentsOf: url)
				let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				if let dictionary = object as? [String: Any] {
					pgDataArray = dictionary["data"] as? [[String: Any]] ?? []
					let countries = Array(Set(pgDataArray.map({$0["country"] as! String})))
					countryListArray = countries.sorted(by: <)
				}
			} catch {
			}
		}
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
		getSectionTypeData(type)
	}
    
	func updateSectionResponse(for type: String, responseTypeDict: [String: Any]) {
		var typeDict = responseTypeDict[type] as? [String: Any] ?? [:]
		var typeStr = type
		if type == "UG" || type == "PG" {
			typeDict = responseTypeDict["education"] as? [String: Any] ?? [:]
			typeStr = "education"
		}
		self.dataDict[typeStr] = typeDict
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
			if let dict = sender as? [String: Any] {
				let dropDowntype = dict["type"] as? String ?? ""
				if dropDowntype == "selectGender" {
					vc.titleArray = ["Male", "Female"]
					vc.selectedRowTitles = [contactPersonalInfoCell.genderTF.text!]
				}
				else if dropDowntype == "selectCountry" {
					vc.titleArray = countryListArray
				}
				else if dropDowntype == "selectCity" {
					let countryName = dict["country"] as? String ?? ""
					let cityArray = Array(Set(pgDataArray.filter({$0["country"] as! String == countryName}).map({$0["city"] as! String}))).sorted(by: <)
					if cityArray.count > 0 {
						vc.titleArray = cityArray
					}
				}
				else if dropDowntype == "selectSchool" {
					let country = dict["country"] as? String ?? ""
					let city = dict["city"] as? String ?? ""
					let colleges = pgDataArray.filter({$0["country"] as! String == country && $0["city"] as! String == city}).map({$0["college"] as! String})
					if colleges.count > 0 {
						vc.titleArray = colleges
					}
				}
				vc.selectionType = .Single
				vc.callBack = { (titles) in
					if titles.count == 0 {
						return
					}
					
					if dropDowntype == "selectGender" {
						self.contactPersonalInfoCell.genderTF.text = titles[0]
						self.contactPersonalInfoCell.enableOrDisableSaveButton()
					}
					else if dropDowntype == "selectCountry" {
						if self.editRowForSecction == -1 {
							self.addPGEducationTableViewCell.countryTF.text = titles[0]
						}
						else {
							let cell: EditPGEducationTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 3)) as! EditPGEducationTableViewCell
							cell.countryTF.text = titles[0]
							cell.cityTF.text = ""
							cell.schoolTF.text = ""
						}
					}
					else if dropDowntype == "selectCity" {
						if self.editRowForSecction == -1 {
							self.addPGEducationTableViewCell.cityTF.text = titles[0]
						}
						else {
							let cell: EditPGEducationTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 3)) as! EditPGEducationTableViewCell
							cell.cityTF.text = titles[0]
							cell.schoolTF.text = ""
						}
					}
					else if dropDowntype == "selectSchool" {
						if self.editRowForSecction == -1 {
							self.addPGEducationTableViewCell.schoolTF.text = titles[0]
						}
						else {
							let cell: EditPGEducationTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 3)) as! EditPGEducationTableViewCell
							cell.schoolTF.text = titles[0]
						}
					}
				}
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
		else if indexPath.section == 3 {
			if indexPath.row == commonArray.count {
				let cell : AddPGEducationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddPGEducationTableViewCellID", for: indexPath) as! AddPGEducationTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.setUI()
				addPGEducationTableViewCell = cell
				return cell
			}
			else {
				let cell : EditPGEducationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditPGEducationTableViewCellID", for: indexPath) as! EditPGEducationTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.editPGEducationdelegate = self
				cell.deleteButton.tag = indexPath.row
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
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
				cell.vc = self
				indexPath.section == 6 ? (cell.sectionType) = "academic_appointments" : (cell.sectionType = "hospital_appointments")
				cell.setUI()
				return cell
			}
			else {
				let cell : EditHospitalORAcademicAppointmentsTVCell = tableView.dequeueReusableCell(withIdentifier: "EditHospitalORAcademicAppointmentsTVCellID", for: indexPath) as! EditHospitalORAcademicAppointmentsTVCell
				cell.delegate = self
				cell.vc = self
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
				cell.vc = self
				cell.setUI()
				return cell
			}
			else {
				let cell : EditHonorAwardsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditHonorAwardsTableViewCellID", for: indexPath) as! EditHonorAwardsTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 9 || indexPath.section == 14 || indexPath.section == 21 {
			if indexPath.row == commonArray.count {
				let cell : AddCertificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddCertificationsTableViewCellID", for: indexPath) as! AddCertificationsTableViewCell
				cell.delegate = self
				cell.vc = self
				if indexPath.section == 9 {
					cell.sectionType = "certifications"
				}
				else if indexPath.section == 14 {
					cell.sectionType = "administrative_responsibility"
				}
				else if indexPath.section == 21 {
					cell.sectionType = "custom_fields"
				}
				cell.setUI()
				return cell
			}
			else {
				let cell : EditCertificationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditCertificationsTableViewCellID", for: indexPath) as! EditCertificationsTableViewCell
				cell.delegate = self
				cell.vc = self
				if indexPath.section == 9 {
					cell.sectionType = "certifications"
				}
				else if indexPath.section == 14 {
					cell.sectionType = "administrative_responsibility"
				}
				else if indexPath.section == 21 {
					cell.sectionType = "custom_fields"
				}
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 10 {
			if indexPath.row == commonArray.count {
				let cell : AddLicensesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddLicensesTableViewCellID", for: indexPath) as! AddLicensesTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.setUI()
				return cell
			}
			else {
				let cell : EditLicensesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditLicensesTableViewCellID", for: indexPath) as! EditLicensesTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 11 {
			if indexPath.row == commonArray.count {
				let cell : AddCommitteesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddCommitteesTableViewCellID", for: indexPath) as! AddCommitteesTableViewCell
				cell.delegate = self
				cell.setUI()
				return cell
			}
			else {
				let cell : EditCommitteesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditCommitteesTableViewCellID", for: indexPath) as! EditCommitteesTableViewCell
				cell.delegate = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 12 || indexPath.section == 13 || indexPath.section == 15 || indexPath.section == 16 {
			
			if indexPath.row == commonArray.count {
				let cell : AddTeachingResponsibilitiesTvCell = tableView.dequeueReusableCell(withIdentifier: "AddTeachingResponsibilitiesTvCellID", for: indexPath) as! AddTeachingResponsibilitiesTvCell
				cell.delegate = self
				cell.vc = self
				if indexPath.section == 12 {
					cell.sectionType = "teaching"
				}
				else if indexPath.section == 13 {
					cell.sectionType = "major_mentoring_activities"
				}
				else if indexPath.section == 15 {
					cell.sectionType = "professional_societies"
				}
				else if indexPath.section == 16 {
					cell.sectionType = "educational_boards"
				}
				cell.setUI()
				return cell
			}
			else {
				let cell : EditTeachingResponsibilitiesTvCell = tableView.dequeueReusableCell(withIdentifier: "EditTeachingResponsibilitiesTvCellID", for: indexPath) as! EditTeachingResponsibilitiesTvCell
				cell.delegate = self
				cell.vc = self
				if indexPath.section == 12 {
					cell.sectionType = "teaching"
				}
				else if indexPath.section == 13 {
					cell.sectionType = "major_mentoring_activities"
				}
				else if indexPath.section == 15 {
					cell.sectionType = "professional_societies"
				}
				else if indexPath.section == 16 {
					cell.sectionType = "educational_boards"
				}
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 18 {
			if indexPath.row == commonArray.count {
				let cell : AddInvitedLecturesPresentationsTvCell = tableView.dequeueReusableCell(withIdentifier: "AddInvitedLecturesPresentationsTvCellID", for: indexPath) as! AddInvitedLecturesPresentationsTvCell
				cell.delegate = self
				cell.setUI()
				return cell
			}
			else {
				let cell : EditInvitedLecturesPresentationsTvCell = tableView.dequeueReusableCell(withIdentifier: "EditInvitedLecturesPresentationsTvCellID", for: indexPath) as! EditInvitedLecturesPresentationsTvCell
				cell.delegate = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 19 || indexPath.section == 20 {
			if indexPath.row == commonArray.count {
				let cell : AddCongressionalAndMediaTVCell = tableView.dequeueReusableCell(withIdentifier: "AddCongressionalAndMediaTVCellID", for: indexPath) as! AddCongressionalAndMediaTVCell
				cell.delegate = self
				cell.vc = self
				if indexPath.section == 19 {
					cell.sectionType = "congressional_testimony"
				}
				else if indexPath.section == 20 {
					cell.sectionType = "media_appearances"
				}
				cell.setUI()
				return cell
			}
			else {
				let cell : EditCongressionalAndMediaTVCell = tableView.dequeueReusableCell(withIdentifier: "EditCongressionalAndMediaTVCellID", for: indexPath) as! EditCongressionalAndMediaTVCell
				cell.delegate = self
				cell.vc = self
				if indexPath.section == 19 {
					cell.sectionType = "congressional_testimony"
				}
				else if indexPath.section == 20 {
					cell.sectionType = "media_appearances"
				}
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
			getSectionTypeData("UG")
		}
		else if sender.tag == 3 {
			getSectionTypeData("PG")
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
			getSectionTypeData("certifications")
		}
		else if sender.tag == 10 {
			getSectionTypeData("licences")
		}
		else if sender.tag == 11 {
			getSectionTypeData("committees")
		}
		else if sender.tag == 12 {
			getSectionTypeData("teaching")
		}
		else if sender.tag == 13 {
			getSectionTypeData("major_mentoring_activities")
		}
		else if sender.tag == 14 {
			getSectionTypeData("administrative_responsibility")
		}
		else if sender.tag == 15 {
			getSectionTypeData("professional_societies")
		}
		else if sender.tag == 16 {
			getSectionTypeData("educational_boards")
		}
		else if sender.tag == 17 {
			
		}
		else if sender.tag == 18 {
			getSectionTypeData("invited_lectures_and_presentations")
		}
		else if sender.tag == 19 {
			getSectionTypeData("congressional_testimony")
		}
		else if sender.tag == 20 {
			getSectionTypeData("media_appearances")
		}
		else if sender.tag == 21 {
			getSectionTypeData("custom_fields")
		}
	}
	
	func getSectionTypeData(_ sectionType: String) {
		commonArray = []
		if let dict = self.dataDict[sectionType] as? [String: Any]{
			commonArray = dict["data"] as? [[String: Any]] ?? []
		}
		if sectionType == "UG" || sectionType == "PG" {
			let educationDict = self.dataDict["education"] as? [String: Any] ?? [:]
			let tmpDict = educationDict["data"] as? [String: Any] ?? [:]
			commonArray = tmpDict[sectionType] as? [[String: Any]] ?? []
		}
		editRowForSecction = -1
////		let contentOffset = self.userPortFolioTableview.contentOffset
		self.userPortFolioTableview.reloadData()
//		self.userPortFolioTableview.layoutIfNeeded()
////		self.userPortFolioTableview.setContentOffset(contentOffset, animated: false)
		
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
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectGender"])
	}
}

extension UserPortFolioViewController: AddOrUpdatePGEducationTvCellDelegate,EditPGEducationTableViewCellDelegate {
	func savePGEducation(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["post_id"] = id
			addPortFolioDetails(requestDict: requestValues, of: dict["education_type"] as! String)
		}
	}
	
	func deletePGEducation(dict: [String : Any], at index: Int) {
		deletePortFolioSection(inputDict: dict, at: index)
	}
	
	func editPGEducation(at index: Int) {
		editRowForSecction = index
		userPortFolioTableview.reloadData()
	}
	
	func cancelPGEducation() {
		editRowForSecction = -1
		userPortFolioTableview.reloadData()
	}
	
	func chooseCountry() {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectCountry"])
	}
	
	func chooseCity(of country: String) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectCity", "country": country])
	}
	
	func chooseSchool(of country: String, and city: String) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "selectSchool", "country": country, "city": city])
	}
	
	func AddOrUpdatePGEducation(dict: [String: Any]) {
		addPortFolioDetails(requestDict: dict, of: dict["education_type"] as! String)
	}
}

extension UserPortFolioViewController: AddSectionTvCellDelegate {
	func addSection(dict: [String: Any]) {
		addPortFolioDetails(requestDict: dict, of: dict["type"] as! String)
	}
}

extension UserPortFolioViewController: EditSectionTvCellDelegate {
	func saveSection(dict: [String : Any], at index: Int) {
		var requestValues = dict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["post_id"] = id
			addPortFolioDetails(requestDict: requestValues, of: dict["type"] as! String)
			editRowForSecction = -1
		}
	}
	
	func deleteSection(dict: [String : Any], at index: Int) {
		deletePortFolioSection(inputDict: dict, at: index)
	}
	
	func deletePortFolioSection(inputDict: [String : Any], at index: Int) {
		var requestValues = inputDict
		let tmpDict = commonArray[index]
		if let id = tmpDict["id"] as? String {
			requestValues["obj_id"] = id
			var sectionType = ""
			if inputDict["type"] as! String == "education" {
				sectionType = inputDict["subtype"] as! String
			}
			else {
				sectionType = inputDict["type"] as! String
			}
			deletePortFolioDetailsAPI(inputDict: requestValues, section: sectionType)
			editRowForSecction = -1
		}
	}
	
	func deletePortFolioDetailsAPI(inputDict: [String: Any], section: String) {
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
	
	func editSection(at index: Int) {
		editRowForSecction = index
		userPortFolioTableview.reloadData()
	}
	
	func cancelSection() {
		editRowForSecction = -1
		userPortFolioTableview.reloadData()
	}
}
