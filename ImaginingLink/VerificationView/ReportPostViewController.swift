//
//  ReportPostViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/24/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class ReportPostViewController: BaseHamburgerViewController {
    
    var userID : String = ""
    var selectedIssue: String = "Copied content"
    @IBOutlet weak var reportTF: FloatingLabel!
    let reports: [String] = ["Copied content","False News","Spam","Others","inappropriate","Violence"]
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "Report Post")
        addBodersForButtons()
        selectReportButton(self.view.viewWithTag(100) as! UIButton)
        reportTF.setUpLabel(WithText: "Few lines on why you are reporting")
        // Do any additional setup after loading the view.
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
        for tagValue in 100...105{
            let btn = self.view.viewWithTag(tagValue)
            btn?.layer.borderColor = UIColor(red:0.91, green:0.92, blue:0.93, alpha:1.0).cgColor
        }
        let btn = self.view.viewWithTag(sender.tag)
        btn?.layer.borderColor = UIColor(red:0.82, green:0.01, blue:0.11, alpha:1.0).cgColor
        let index = sender.tag - 100
        selectedIssue = reports[index]
    }
    @IBAction func submitReport(_ sender: UIButton){
        if reportTF.text == ""{
            ILUtility.showAlert(message: "Please enter the text for reporting post", controller: self)
        }
        else{
            ILUtility.showProgressIndicator(controller: self)
            CoreAPI.sharedManaged.requestReportPost(presentationID: userID, selectedIssue: selectedIssue, reportedIssue: reportTF.text!, successResponse: { (response) in
                ILUtility.hideProgressIndicator(controller: self)
                let value = response as! [String:Any]
                
                let alert = UIAlertController(title: "Imaginglink", message: value["message"] as? String, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: false)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }) { (erorr) in
                ILUtility.hideProgressIndicator(controller: self)
            }
        }
    }
}
