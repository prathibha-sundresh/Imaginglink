//
//  ReportPostViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/24/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class ReportPostViewController: BaseHamburgerViewController {
	var isFromVC = ""
    var userID : String = ""
    var presentationTitle = ""
    var selectedIssue: String = ""
	var selectedIssueIndex = 0
	var groupId = ""
    @IBOutlet weak var reportTF: FloatingLabel!
	@IBOutlet weak var reportsCv: UICollectionView!
    var reports: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "Report Post")
		if isFromVC == "Groups" || isFromVC == "Timeline" {
			reports = ["It's annoying or not interesting","I think it shouldn't be on imaginglink","It's spam"]
		}
		else {
			reports = ["Copied content","False News","Spam","Others","inappropriate","Violence"]
		}
		selectedIssue = reports[0]
        reportTF.setUpLabel(WithText: "Few lines on why you are reporting")
        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addBodersForButtons(){
        for tagValue in 100...105{
            let btn = self.view.viewWithTag(tagValue)
            btn?.layer.borderWidth = 1.0
            btn?.layer.cornerRadius = 18
            btn?.layer.borderColor = UIColor(red:0.91, green:0.92, blue:0.93, alpha:1.0).cgColor
            btn?.layer.masksToBounds = true
        }
    }
    @IBAction func selectReportButton(_ sender: UIButton){
		selectedIssueIndex = sender.tag
		selectedIssue = reports[sender.tag]
		reportsCv.reloadData()
    }
    @IBAction func submitReport(_ sender: UIButton){
        if reportTF.text == ""{
            ILUtility.showAlert(message: "Please enter the text for reporting post", controller: self)
        }
        else{
			callReportPostAPI()
        }
    }
	
	func callReportPostAPI() {
		var typeUrl = ""
		var OTPRequestValues = [String: Any]()
		if isFromVC == "Groups" {
			typeUrl = kReportGroupSharedPost
			OTPRequestValues = ["group_id": groupId,"post_id" : userID, "selected_issue": selectedIssue, "reported_issue":reportTF.text!]
		}
		else if isFromVC == "Timeline" {
			typeUrl = kReportTimeLinePost
			OTPRequestValues = ["post_id" : userID, "selected_issue": selectedIssue, "reported_issue":reportTF.text!]
		}
		else {
			typeUrl = kReportPost
			OTPRequestValues = ["presentation_id" : userID, "selected_issue": selectedIssue, "reported_issue":reportTF.text!]
		}
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.requestReportPost(parameterDict: OTPRequestValues,type: typeUrl, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.showAlertMessage(response: response)
		}) { (erorr) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	
	func showAlertMessage(title: String? = "Imaginglink", response: AnyObject) {
		let value = response as! [String:Any]
		let alert = UIAlertController(title: title, message: value["message"] as? String ?? "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
			self.navigationController?.popViewController(animated: false)
		}))
		self.present(alert, animated: true, completion: nil)
	}
}

extension ReportPostViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! KeywordsCVCell
		cell.nameButton.tag = indexPath.item
		cell.nameButton.setTitle("       \(reports[indexPath.item])       ", for: .normal)
		cell.nameButton.addTarget(self, action: #selector(selectReportButton), for: .touchUpInside)
		cell.nameButton.layer.borderWidth = 1.0
		if selectedIssueIndex == indexPath.item {
			cell.nameButton.layer.borderColor = UIColor(red:0.82, green:0.01, blue:0.11, alpha:1.0).cgColor
		}
		else {
			cell.nameButton.layer.borderColor = UIColor(red:0.91, green:0.92, blue:0.93, alpha:1.0).cgColor
		}
		cell.nameButton.layer.cornerRadius = cell.nameButton.frame.height / 2
		cell.nameButton.clipsToBounds = true
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return reports.count
	}
	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		let size = ("\(reports[indexPath.item])").size(withAttributes: nil)
//		return size
//	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 20.0
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20.0
	}
}
