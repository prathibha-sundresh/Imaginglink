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
	var addCMETrackingTableViewCell: AddCMETrackingTableViewCell!
	var addPGEducationTableViewCell: AddPGEducationTableViewCell!
	var addBibliographyTableViewCell: AddBibliographyTableViewCell!
	var educationTableViewCell: EducationTableViewCell!
	var addFundingTableViewCell: AddFundingTableViewCell!
	
	var userPortFolioArray: [String] = ["Summary", "Contact & Personal Info", "Under Graduate","Post Graduate","Subspecialties", "Recreational Interests", "Academic Appointments", "Hospital Appointments","Honor/Awards", "Certifications","Licenses","Committees","Teaching Responsibilities","Major Mentoring Activities","Administrative Responsibilities","Professional Societies","Editorial Boards","Grant Or Fund details","Invited Lectures & Presentations","Congressional Testimony","Media Appearances","Custom Fields","Bibliography","CME Tracking"]
	var sectionTypes = ["Overview","contact_and_personal_info","UG","PG","sub_speciality","recreational_interests","academic_appointments","hospital_appointments","honor_awards","certifications","licences","committees","teaching","major_mentoring_activities","administrative_responsibility","professional_societies","educational_boards","grant_or_fund_details","invited_lectures_and_presentations","congressional_testimony","media_appearances","custom_fields","bibliography","cme_tracking"]
	var expandedArray: [Int] = []
	var dataDict = [String: Any]()
	var commonArray: [[String: Any]] = []
	var pgDataArray: [[String: Any]] = []
	var ugDataArray: [[String: Any]] = []
	var ugCountryListArray: [String] = []
	var pgCountryListArray: [String] = []
	var editRowForSecction : Int = -1
	var ugSectionIndex : Int = 0
	var educationTableViewH : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
		getFolioDetails()
		getPGList()
		getUGList()
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
					pgCountryListArray = countries.sorted(by: <)
				}
			} catch {
			}
		}
	}
	
	func getUGList() {
		if let url = Bundle.main.url(forResource: "portfolio_ug_countries", withExtension: "json") {
			do {
				let data = try Data(contentsOf: url)
				let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				if let dictionary = object as? [String: Any] {
					ugDataArray = dictionary["data"] as? [[String: Any]] ?? []
					let countries = Array(Set(pgDataArray.map({$0["country"] as! String})))
					ugCountryListArray = countries.sorted(by: <)
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
			if let senderDict = sender as? [String: Any] {
				let dropDowntype = senderDict["type"] as? String ?? ""
				var section = 0
				if expandedArray.count > 0 {
					section = expandedArray[0]
				}
				if dropDowntype == "selectGender" {
					vc.titleArray = ["Male", "Female"]
					vc.selectedRowTitles = [contactPersonalInfoCell.genderTF.text!]
				}
				else if dropDowntype == "Credit type" {
					vc.titleArray = ["Cat1 CME","SA-CME","SAM"]
					vc.isCapitalizedRequired = false
					vc.selectedRowTitles = [addCMETrackingTableViewCell.textField3.text!]
				}
				else if dropDowntype == "Funding Type" {
					vc.titleArray = ["Award","Contract","Grant","Salary award"]
					//vc.selectedRowTitles = [addCMETrackingTableViewCell.textField3.text!]
				}
				else if dropDowntype == "Bibliography Type" {
					vc.titleArray = ["Pubmed articles","Journal article(s)","Editorials", "Scientific abstract(s)","Educational exhibit(s)","Case report(s)","Book(s)","Book chapter(s)","Patent","Thesis","Others"]
					vc.selectedRowTitles = [addBibliographyTableViewCell.textField1.text!]
					vc.isCapitalizedRequired = false
				}
				else if dropDowntype == "Bibliography Status" {
					vc.titleArray = ["Published","In review","In press"]
					vc.selectedRowTitles = [addBibliographyTableViewCell.textField13.text!]
					vc.isCapitalizedRequired = false
				}
				else if dropDowntype == "selectCountry" {
					vc.titleArray = section == 2 ? ugCountryListArray : pgCountryListArray
				}
				else if dropDowntype == "selectCity" {
					let countryName = senderDict["country"] as? String ?? ""
					let array = (section == 2) ? ugDataArray : pgDataArray
					let cityArray = Array(Set(array.filter({$0["country"] as! String == countryName}).map({$0["city"] as! String}))).sorted(by: <)
					if cityArray.count > 0 {
						vc.titleArray = cityArray
					}
				}
				else if dropDowntype == "selectSchool" {
					let country = senderDict["country"] as? String ?? ""
					let city = senderDict["city"] as? String ?? ""
					let array = (section == 2) ? ugDataArray : pgDataArray
					let colleges = array.filter({$0["country"] as! String == country && $0["city"] as! String == city}).map({$0["college"] as! String})
					if colleges.count > 0 {
						vc.titleArray = colleges
					}
				}
				vc.selectionType = .Single
				vc.callBack = { (titles) in
					if titles.count == 0 {
						return
					}
					self.editRowForSecction = senderDict["index"] as? Int ?? self.editRowForSecction
					if dropDowntype == "selectGender" {
						self.contactPersonalInfoCell.genderTF.text = titles[0]
						self.contactPersonalInfoCell.enableOrDisableSaveButton()
					}
					else if dropDowntype == "Funding Type" {
						if self.editRowForSecction == -1 {
							self.addFundingTableViewCell.textField1.text = titles[0]
							self.addFundingTableViewCell.enableOrDisableSaveButton()
						}
						else {
							let cell: EditFundingTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 17)) as! EditFundingTableViewCell
							cell.textField1.text = titles[0]
							cell.enableOrDisableSaveButton()
						}
					}
					else if dropDowntype == "Bibliography Type" {
						if self.editRowForSecction == -1 {
							self.addBibliographyTableViewCell.textField1.text = titles[0]
							self.addBibliographyTableViewCell.enableOrDisableSaveButton()
						}
						else {
							let cell: EditBibliographyTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 22)) as! EditBibliographyTableViewCell
							cell.textField1.text = titles[0]
							cell.enableOrDisableSaveButton()
						}
					}
					else if dropDowntype == "Bibliography Status" {
						if self.editRowForSecction == -1 {
							self.addBibliographyTableViewCell.textField13.text = titles[0]
							self.addBibliographyTableViewCell.enableOrDisableSaveButton()
						}
						else {
							let cell: EditBibliographyTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 22)) as! EditBibliographyTableViewCell
							cell.textField13.text = titles[0]
							cell.enableOrDisableSaveButton()
						}
					}
					else if dropDowntype == "Credit type" {
						if self.editRowForSecction == -1 {
							self.addCMETrackingTableViewCell.textField3.text = titles[0]
							self.addCMETrackingTableViewCell.enableOrDisableSaveButton()
						}
						else {
							let cell: EditCMETrackingTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 23)) as! EditCMETrackingTableViewCell
							cell.textField3.text = titles[0]
							cell.enableOrDisableSaveButton()
						}
					}
					else if dropDowntype == "selectCountry" {
						if self.editRowForSecction == -1 {
							if section == 2 {
								self.educationTableViewCell.addUGEducationTableViewCell.countryTF.text = titles[0]
								self.educationTableViewCell.addUGEducationTableViewCell.enableOrDisableSaveButton()
							}
							else {
								self.addPGEducationTableViewCell.countryTF.text = titles[0]
								self.addPGEducationTableViewCell.enableOrDisableSaveButton()
							}
						}
						else {
							if section == 2 {
								let cell: EditUGEducationTableViewCell = senderDict["cell"] as! EditUGEducationTableViewCell
								cell.countryTF.text = titles[0]
								cell.cityTF.text = ""
								cell.schoolTF.text = ""
								cell.enableOrDisableSaveButton()
							}
							else {
								let cell: EditPGEducationTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 3)) as! EditPGEducationTableViewCell
								cell.countryTF.text = titles[0]
								cell.cityTF.text = ""
								cell.schoolTF.text = ""
								cell.enableOrDisableSaveButton()
							}
							
						}
					}
					else if dropDowntype == "selectCity" {
						if self.editRowForSecction == -1 {
							if section == 2 {
								self.educationTableViewCell.addUGEducationTableViewCell.cityTF.text = titles[0]
								self.educationTableViewCell.addUGEducationTableViewCell.enableOrDisableSaveButton()
							}
							else {
								self.addPGEducationTableViewCell.cityTF.text = titles[0]
								self.addPGEducationTableViewCell.enableOrDisableSaveButton()
							}
						}
						else {
							if section == 2 {
								let cell: EditUGEducationTableViewCell = senderDict["cell"] as! EditUGEducationTableViewCell
								cell.cityTF.text = titles[0]
								cell.schoolTF.text = ""
								cell.enableOrDisableSaveButton()
							}
							else {
								let cell: EditPGEducationTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 3)) as! EditPGEducationTableViewCell
								cell.cityTF.text = titles[0]
								cell.schoolTF.text = ""
								cell.enableOrDisableSaveButton()
							}
						}
					}
					else if dropDowntype == "selectSchool" {
						if self.editRowForSecction == -1 {
							if section == 2 {
								self.educationTableViewCell.addUGEducationTableViewCell.schoolTF.text = titles[0]
								self.educationTableViewCell.addUGEducationTableViewCell.enableOrDisableSaveButton()
							}
							else {
								self.addPGEducationTableViewCell.schoolTF.text = titles[0]
								self.addPGEducationTableViewCell.enableOrDisableSaveButton()
							}
						}
						else {
							if section == 2 {
								let cell: EditUGEducationTableViewCell = senderDict["cell"] as! EditUGEducationTableViewCell
								cell.schoolTF.text = titles[0]
								cell.enableOrDisableSaveButton()
							}
							else {
								let cell: EditPGEducationTableViewCell = self.userPortFolioTableview.cellForRow(at: IndexPath(row: self.editRowForSecction, section: 3)) as! EditPGEducationTableViewCell
								cell.schoolTF.text = titles[0]
								cell.enableOrDisableSaveButton()
							}
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
		else if indexPath.section == 2 {
			let cell : EducationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EducationTableViewCellID", for: indexPath) as! EducationTableViewCell
			cell.dataArray = commonArray
			cell.delegate = self
			cell.cellDelegate = self
			cell.vc = self
			cell.setUI(height: educationTableViewH, section: ugSectionIndex)
			educationTableViewCell =  cell
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
		else if indexPath.section == 17 {
			if indexPath.row == commonArray.count {
				let cell : AddFundingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddFundingTableViewCellID", for: indexPath) as! AddFundingTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.setUI()
				addFundingTableViewCell = cell
				return cell
			}
			else {
				let cell : EditFundingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditFundingTableViewCellID", for: indexPath) as! EditFundingTableViewCell
				cell.delegate = self
				cell.vc = self
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
		else if indexPath.section == 22 {
			if indexPath.row == commonArray.count {
				let cell : AddBibliographyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddBibliographyTableViewCellID", for: indexPath) as! AddBibliographyTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.cellDelegate = self
				cell.setUI()
				addBibliographyTableViewCell = cell
				return cell
			}
			else {
				let cell : EditBibliographyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditBibliographyTableViewCellID", for: indexPath) as! EditBibliographyTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.cellDelegate = self
				cell.isEditMode = (indexPath.row == editRowForSecction ? true: false)
				cell.setUI(dict: commonArray[indexPath.row] ,btnTag: indexPath.row)
				return cell
			}
		}
		else if indexPath.section == 23 {
			if indexPath.row == commonArray.count {
				let cell : AddCMETrackingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddCMETrackingTableViewCellID", for: indexPath) as! AddCMETrackingTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.trackingTvCellDelegate = self
				cell.setUI()
				addCMETrackingTableViewCell = cell
				return cell
			}
			else {
				let cell : EditCMETrackingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditCMETrackingTableViewCellID", for: indexPath) as! EditCMETrackingTableViewCell
				cell.delegate = self
				cell.vc = self
				cell.trackingTvCellDelegate = self
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
			if section == 0 || section == 1 || section == 2 {
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
		btn.frame = CGRect(x: view.frame.width, y: 0, width: 50, height: 50)
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
	
		if section != 0 {
			let showHideBtn = UIButton(type: .custom)
			showHideBtn.frame = CGRect(x: view.frame.width - 50, y: 0, width: 50, height: 50)
			showHideBtn.addTarget(self, action: #selector(showHideBtnAction), for: .touchUpInside)
			showHideBtn.tag = section
			view.addSubview(showHideBtn)
			let eyeImage = UIImageView(frame: CGRect(x: showHideBtn.frame.width - 25, y: 12, width: 25, height: 25))
			eyeImage.contentMode = .scaleAspectFit
			let sectionType = sectionTypes[section]
			var status = false
			if let dict = self.dataDict[sectionType] as? [String: Any] {
				if let stringS1 = dict["status"] as? String {
					status = stringS1 == "true" ? true : false
				}
				if let boolenS1 = dict["status"] as? Bool {
					status = boolenS1
				}
			}
			if sectionType == "UG" || sectionType == "PG" {
				let educationDict = self.dataDict["education"] as? [String: Any] ?? [:]
				if let stringS1 = educationDict["status"] as? String {
					status = stringS1 == "true" ? true : false
				}
				if let boolenS1 = educationDict["status"] as? Bool {
					status = boolenS1
				}
			}
			if status {
				if #available(iOS 13.0, *) {
					eyeImage.image = UIImage(systemName: "eye.slash")
				}
			}
			else {
				if #available(iOS 13.0, *) {
					eyeImage.image = UIImage(systemName: "eye")
				}
			}
			eyeImage.tintColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
			showHideBtn.addSubview(eyeImage)
		}
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	@objc func showHideBtnAction(_ sender: UIButton) {
		var status = false
		var sectionType = sectionTypes[sender.tag]
		if let dict = self.dataDict[sectionType] as? [String: Any] {
			if let stringS1 = dict["status"] as? String {
				status = stringS1 == "true" ? true : false
			}
			if let boolenS1 = dict["status"] as? Bool {
				status = boolenS1
			}
		}
		if sectionType == "UG" || sectionType == "PG" {
			sectionType = "education"
			let educationDict = self.dataDict["education"] as? [String: Any] ?? [:]
			if let stringS1 = educationDict["status"] as? String {
				status = stringS1 == "true" ? true : false
			}
			if let boolenS1 = educationDict["status"] as? Bool {
				status = boolenS1
			}
		}
		ILUtility.showProgressIndicator(controller: self)
		let inputDict = ["type": sectionType, "hide_and_show_status": !status] as [String : Any]
		PortFolioAPI.sharedManaged.showHidePortFolioType(requestDict: inputDict, successResponse: { (response) in
			if let dict = response["data"] as? [String: Any] {
				var typeDict = self.dataDict[sectionType] as? [String: Any] ?? [:]
				typeDict["status"] = dict["status"] as? String ?? "false"
				self.dataDict[sectionType] = typeDict
				self.userPortFolioTableview.reloadData()
			}
			ILUtility.hideProgressIndicator(controller: self)
		}, faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
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
			getSectionTypeData("UG", section: sender.tag)
		}
		else if sender.tag == 3 {
			getSectionTypeData("PG", section: sender.tag)
		}
		else if sender.tag == 4 {
			getSectionTypeData("sub_speciality", section: sender.tag)
		}
		else if sender.tag == 5 {
			getSectionTypeData("recreational_interests", section: sender.tag)
		}
		else if sender.tag == 6 {
			getSectionTypeData("academic_appointments", section: sender.tag)
		}
		else if sender.tag == 7 {
			getSectionTypeData("hospital_appointments", section: sender.tag)
		}
		else if sender.tag == 8 {
			getSectionTypeData("honor_awards", section: sender.tag)
		}
		else if sender.tag == 9 {
			getSectionTypeData("certifications", section: sender.tag)
		}
		else if sender.tag == 10 {
			getSectionTypeData("licences", section: sender.tag)
		}
		else if sender.tag == 11 {
			getSectionTypeData("committees", section: sender.tag)
		}
		else if sender.tag == 12 {
			getSectionTypeData("teaching", section: sender.tag)
		}
		else if sender.tag == 13 {
			getSectionTypeData("major_mentoring_activities", section: sender.tag)
		}
		else if sender.tag == 14 {
			getSectionTypeData("administrative_responsibility", section: sender.tag)
		}
		else if sender.tag == 15 {
			getSectionTypeData("professional_societies", section: sender.tag)
		}
		else if sender.tag == 16 {
			getSectionTypeData("educational_boards", section: sender.tag)
		}
		else if sender.tag == 17 {
			getSectionTypeData("grant_or_fund_details", section: sender.tag)
		}
		else if sender.tag == 18 {
			getSectionTypeData("invited_lectures_and_presentations", section: sender.tag)
		}
		else if sender.tag == 19 {
			getSectionTypeData("congressional_testimony", section: sender.tag)
		}
		else if sender.tag == 20 {
			getSectionTypeData("media_appearances", section: sender.tag)
		}
		else if sender.tag == 21 {
			getSectionTypeData("custom_fields", section: sender.tag)
		}
		else if sender.tag == 22 {
			getSectionTypeData("bibliography", section: sender.tag)
		}
		else if sender.tag == 23 {
			getSectionTypeData("cme_tracking", section: sender.tag)
		}
	}
	
	func getSectionTypeData(_ sectionType: String, section: Int = 0) {
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
		self.userPortFolioTableview.reloadData()
		userPortFolioTableview.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: UITableView.ScrollPosition.none, animated: false)
////		let contentOffset = self.userPortFolioTableview.contentOffset
		
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

extension UserPortFolioViewController: AddCMETrackingTvCellDelegate {
	func chooseCreditType() {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "Credit type"])
	}
}

extension UserPortFolioViewController: AddBibliographyTvCellDelegate {
	func chooseBibliographyType() {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "Bibliography Type"])
	}
	
	func chooseStatusType() {
		self.performSegue(withIdentifier: "PopUpVCID", sender: ["type": "Bibliography Status"])
	}
}

extension UserPortFolioViewController: EducationTableViewCellDelegate {
	func saveSchool(requestdict: [String : Any]) {
		addPortFolioDetails(requestDict: requestdict, of: "UG")
	}
	
	func deleteSchool(requestdict: [String : Any]) {
		deletePortFolioDetailsAPI(inputDict: requestdict, section: "UG")
	}
	
	func updateCellHeight(height: CGFloat, section: Int) {
		educationTableViewH = height
		ugSectionIndex = section
		self.userPortFolioTableview.reloadSections([2], with: .fade)
		userPortFolioTableview.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: UITableView.ScrollPosition.none, animated: false)
	}
}
