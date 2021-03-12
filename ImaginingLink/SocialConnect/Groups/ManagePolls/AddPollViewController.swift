//
//  AddPollViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/23/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit

class AddPollViewController: BaseHamburgerViewController {
	@IBOutlet weak var pollNameTextView: UITextView!
	@IBOutlet weak var optionsTV: UITableView!
	@IBOutlet weak var publishButton: UIButton!
	@IBOutlet weak var endDateLabel: UILabel!
	@IBOutlet weak var headerTitleLabel: UILabel!
	@IBOutlet weak var visibilityButton: UIButton!
	@IBOutlet weak var endDateView: UIView!
	@IBOutlet weak var endDatePickerView: UIDatePicker!
	@IBOutlet weak var optionsTVHeight: NSLayoutConstraint!
	
	var pollsArray = [[String: Any]]()
	var optionArray = ["ans"]
	var groupId = ""
	var pollId = ""
	var isEditPoll = false
	var selectedDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if isEditPoll {
			pollNameTextView.text = selectedDict["question"] as? String ?? ""
			optionArray = selectedDict["options"] as? [String] ?? []
			pollId = selectedDict["_id"] as? String ?? ""
			
			if let dateStr = selectedDict["expiry"] as? String {
				let expiry = dateStr.replacingOccurrences(of: " ", with: "T")
				let df = DateFormatter()
				df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
				let date = df.date(from: expiry)
				endDatePickerView.date = date!
				df.dateFormat = "hh:mm a"
				let timeStr = df.string(from: endDatePickerView.date)
				df.dateFormat = "dd MMM yyyy"
				let dateStr = df.string(from: endDatePickerView.date)
				endDateLabel.text = "\(dateStr) at \(timeStr)"
			}
			
			var visibility = selectedDict["visibility"] as? String ?? "public"
			if visibility == "only_me" {
				visibility = "Only Me"
			}
			else {
				visibility = "Public"
			}
			self.visibilityButton.setTitle(visibility, for: .normal)
			optionsTVHeight.constant = CGFloat(65 * optionArray.count)
			optionsTV.reloadData()
		}
		else {
			endDatePickerView.date = Date()
			endDatePickerChanged(endDatePickerView!)
		}
		pollNameTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		visibilityButton.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		pollNameTextView.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		
		endDateView.frame = CGRect(x: 0, y: self.view.frame.height - 240, width: self.view.frame.width, height: 240)
		self.view.addSubview(endDateView)
		endDateView.isHidden = true
		optionsTV.tableFooterView = UIView(frame: .zero)
		endDatePickerView.minimumDate = Date()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func backButtonAction(_ sender: UIButton) {
		backAction()
	}
	
	@IBAction func menuButtonAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
	}
	
	@IBAction func addOptionButtonAction(_ sender: UIButton) {
		optionArray.append("")
		optionsTVHeight.constant = CGFloat(65 * optionArray.count)
		optionsTV.reloadData()
	}
	
	@IBAction func endDateButtonAction(_ sender: UIButton) {
		endDateView.isHidden = false
	}
	
	@IBAction func visibilityButtonAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: nil)
	}

	@IBAction func endDatePickerChanged(_ sender: Any) {
		let df = DateFormatter()
		df.dateFormat = "hh:mm a"
		let timeStr = df.string(from: endDatePickerView.date)
		df.dateFormat = "dd MMM yyyy"
		let dateStr = df.string(from: endDatePickerView.date)
		endDateLabel.text = "\(dateStr) at \(timeStr)"
	}
	
	@IBAction func doneButtonAction(_ sender: UIButton) {
		endDateView.isHidden = true
	}
	
	@IBAction func publishButtonAction(_ sender: UIButton) {
		
		if pollNameTextView.text == "" {
			ILUtility.showAlert(title: "Imaginglink",message: "Please fill the question field", controller: self)
			return
		}
		else if optionArray.count < 2 {
			ILUtility.showAlert(title: "Imaginglink",message: "Please add at least two options", controller: self)
			return
		}
		
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let endDateStr = df.string(from: endDatePickerView.date)
		let visibility = (visibilityButton.titleLabel!.text == "Public") ? "public" : "only_me"
		var requestDict = ["question": pollNameTextView.text!, "expiry_date": endDateStr,"group_id": groupId,"visibility": visibility] as [String: Any]
		for i in 0 ..< optionArray.count {
			requestDict["options[\(i)]"] = optionArray[i]
		}
		if isEditPoll {
			requestDict["poll_id"] = pollId
		}
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.createOrUpdateGroupPoll(parameterDict: requestDict, isUpdate: isEditPoll) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.backAction()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@objc func deleteButtonAction(_ sender: UIButton) {
		optionArray.remove(at: sender.tag)
		optionsTVHeight.constant = CGFloat(65 * optionArray.count)
		optionsTV.reloadData()
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PopUpVCID" {
			let vc = segue.destination as! CustomPopUpViewController
			vc.selectedRowTitles = [visibilityButton.titleLabel?.text ?? ""]
			vc.selectionType = .Single
			vc.titleArray = ["Public", "Only Me"]
			vc.callBack = { (titles) in
				self.visibilityButton.setTitle(titles[0], for: .normal)
			}
		}
    }
}

extension AddPollViewController: UITableViewDataSource,UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCellID", for: indexPath) as! OptionTableViewCell
		cell.setUI(answer: optionArray[indexPath.row], row: indexPath.row, isEditMode: isEditPoll)
		cell.delegate = self
		cell.deleteButtonButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return optionArray.count
	}
}

extension AddPollViewController :OptionTableViewCellDelegate {
	func updateAnswerText(text: String, at row: Int) {
		optionArray[row] = text
	}
}
