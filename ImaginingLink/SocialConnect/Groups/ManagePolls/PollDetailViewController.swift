//
//  PollDetailViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 3/4/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit

class PollQuesionCell: UITableViewCell {
	@IBOutlet weak var questionLabel: UILabel!
}

class AnsweredPollCell: UITableViewCell {
	@IBOutlet weak var optionLabel: UILabel!
	@IBOutlet weak var optionPercentage: UIProgressView!
	
}

class ChooseOptionCell: UITableViewCell {
	@IBOutlet weak var optionRadioButton: UIButton!
}

class PollDetailViewController: BaseHamburgerViewController {

	var groupId = ""
	var activePollsArray: [[String: Any]] = []
	var optionsArray: [String] = []
	var pollsResultArray: [[String: Any]] = []
	@IBOutlet weak var activePollsTableView: UITableView!
	@IBOutlet weak var previousPollButton: UIButton!
	@IBOutlet weak var nextPollButton: UIButton!
	@IBOutlet weak var submitButton: UIButton!
	var pollDict = [String: Any]()
	var currentIndex = 0
	var optionSelected = -1
	var pollId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
		activePollsTableView.tableFooterView = UIView(frame: .zero)
		activePollsTableView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		previousPollButton.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		nextPollButton.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		getActivePolls()
        // Do any additional setup after loading the view.
    }
    
	func getActivePolls() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getLoadActiveGroupPolls(groupId: groupId, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			self.activePollsArray = dic["data"] as? [[String : Any]] ?? []
			for (index, value) in self.activePollsArray.enumerated() {
				if value["_id"] as! String == self.pollId {
					self.currentIndex = index
					break
				}
			}
			
			self.getPollData()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func getPollData() {
		optionSelected = -1
		pollDict = activePollsArray[currentIndex]
		submitButton.isHidden = pollDict["user_poll_added"] as? Bool ?? false
		optionsArray = pollDict["options"] as? [String] ?? []
		pollsResultArray = pollDict["poll_result"] as? [[String: Any]] ?? []
		activePollsTableView.reloadData()
		previousPollButton.isHidden = (currentIndex == 0) ? true : false
		nextPollButton.isHidden = (currentIndex == activePollsArray.count - 1) ? true : false
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		backAction()
	}
	
	@IBAction func menuButtonAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
	}
	
	@IBAction func previousPollButtonAction(_ sender: UIButton) {
		if currentIndex == 0 {
			return
		}
		currentIndex -= 1
		getPollData()
	}
	
	@IBAction func nextPollButtonAction(_ sender: UIButton) {
		if currentIndex > activePollsArray.count {
			return
		}
		currentIndex += 1
		getPollData()
	}
	
	@IBAction func submitPollButtonAction(_ sender: UIButton) {
		let reqDict = ["group_id": groupId, "poll_id": pollDict["_id"] as? String ?? "", "opinion_id": "\(optionSelected - 1)"]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.storeUserOpinionGroupPoll(parameterDict: reqDict, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getActivePolls()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@objc func toggleImage(_ sender: UIButton) {
		optionSelected = sender.tag
		activePollsTableView.reloadData()
	}
}

extension PollDetailViewController: UITableViewDataSource,UITableViewDelegate {

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			let pollQuesionCell = tableView.dequeueReusableCell(withIdentifier: "PollQuesionCellID", for: indexPath) as! PollQuesionCell
			pollQuesionCell.questionLabel.text = pollDict["question"] as? String ?? ""
			return pollQuesionCell
		}
		else {
			let isBool = pollDict["user_poll_added"] as? Bool ?? false
			if isBool {
				let answeredPollCell = tableView.dequeueReusableCell(withIdentifier: "AnsweredPollCellID", for: indexPath) as! AnsweredPollCell
				var serialNo = ""
				for (index,value) in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated() {
					if (indexPath.row - 1) == index {
						serialNo = "\(value)"
						break
					}
				}
				let resultDict = pollsResultArray[indexPath.row - 1]
				answeredPollCell.optionPercentage.progress = Float(resultDict["percent"] as? Int ?? 0)
				answeredPollCell.optionLabel.text = "\(serialNo).  \(optionsArray[indexPath.row - 1].capitalized)  (\(resultDict["percent"] as? Int ?? 0)%)"
				return answeredPollCell
			}
			else {
				let chooseOptionCell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionCellID", for: indexPath) as! ChooseOptionCell
				chooseOptionCell.optionRadioButton.setTitle(optionsArray[indexPath.row - 1].capitalized, for: .normal)
				chooseOptionCell.optionRadioButton.tag = indexPath.row
				chooseOptionCell.optionRadioButton.addTarget(self, action: #selector(toggleImage), for: .touchUpInside)
				chooseOptionCell.optionRadioButton.isSelected = false
				if optionSelected == indexPath.row {
					chooseOptionCell.optionRadioButton.isSelected = true
				}
				return chooseOptionCell
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return optionsArray.count >= 1 ? optionsArray.count + 1 : 0
	}
}
