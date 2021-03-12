//
//  GroupFolderDetailViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/7/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit

class UploadedTableViewCellImage: UITableViewCell {
	@IBOutlet weak var borderView: UIView!
	@IBOutlet weak var fileImageView: UIImageView!
	@IBOutlet weak var fileName: UILabel!
	@IBOutlet weak var createdTimeLabel: UILabel!
	@IBOutlet weak var deleteButton: UIButton!
	
	func setUI(dict: [String: Any]) {
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		fileName.text = dict["name"] as? String ?? ""
		let uploadedUser = dict["uploaded_user"] as? [String: Any] ?? [:]
		let userName = "\(uploadedUser["first_name"] as? String ?? "")" + " " + "\(uploadedUser["last_name"] as? String ?? "")"
		let fileName = dict["name"] as? String ?? ""
		let type = dict["type"] as? String ?? ""
		let url = URL(string: fileName)
		let fileExtension = url?.pathExtension
		if fileExtension == "pdf" {
			fileImageView.image = UIImage(named: "pdf_icon")
		}
		else if fileExtension == "doc" || fileExtension == "docx" {
			fileImageView.image = UIImage(named: "doc_icon")
		}
		else if fileExtension == "ppt" || fileExtension == "pptx" {
			fileImageView.image = UIImage(named: "ppt_icon")
		}
		else if fileExtension == "xlsx" {
			fileImageView.image = UIImage(named: "xls_icon")
		}
		else if fileExtension == "png" || fileExtension == "jpg" || fileExtension == "jpeg"{
			fileImageView.image = UIImage(named: "png_icon")
		}
		if type == "youtube" {
			fileImageView.image = UIImage(named: "youtube")
		}
		if let dateStr = dict["uploaded_at"] as? String {
			let df = DateFormatter()
			df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			let date = df.date(from: dateStr)
			df.dateFormat = "MMMM dd"
			let monthStr = df.string(from: date!)
			df.dateFormat = "h:mm a"
			let timeStr = df.string(from: date!)
			createdTimeLabel.text = "\(monthStr) at \(timeStr) by \(userName)"
		}
	}
	
}

class GroupFolderDetailViewController: BaseHamburgerViewController {
	@IBOutlet weak var filesTableView: UITableView!
	var attachments: [[String: Any]] = []
	var selectedDict = [String: Any]()
	@IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var addYoutubeUrlView: UIView!
	@IBOutlet weak var videoUrlTF: UITextField!
	@IBOutlet weak var descriptionTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(selectedDict["folder"] as? String ?? "")".capitalized)
		addYoutubeUrlView.frame = self.view.frame
		self.view.addSubview(addYoutubeUrlView)
		addYoutubeUrlView.isHidden = true
		enableDisableSaveButton()
        // Do any additional setup after loading the view.
    }
	
	func getAttachments() {
		let results = (selectedDict["resource"] as? [[String: Any]])?.filter({ (dict) -> Bool in
			return (dict["status"] as? String ?? "") != "DELETED"
		})
		attachments = results ?? []
		self.filesTableView.reloadData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		getResourceFolderList()
	}
	func getResourceFolderList() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getGroupGetAllResources(groupId: selectedDict["group_id"] as? String ?? "", successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				let filter = array.filter { (dict) -> Bool in
					return (dict["_id"] as? String ?? "") == (self.selectedDict["_id"] as? String ?? "")
				}
				self.selectedDict = filter[0]
				self.getAttachments()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func enableDisableSaveButton() {
		let isBool = descriptionTF.text! != "" && videoUrlTF.text! != ""
		saveButton.isEnabled = isBool
		saveButton.alpha = isBool ? 1.0 : 0.6
	}
	
	@IBAction func uploadFileButtonAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: "UploadFoldersFilesSegue", sender: nil)
	}
	
	@IBAction func addYouTubeVideoButtonAction(_ sender: UIButton) {
		addYoutubeUrlView.isHidden = false
	}
	
	@IBAction func cancelButtonAction(_ sender: UIButton) {
		addYoutubeUrlView.isHidden = true
		videoUrlTF.resignFirstResponder()
		descriptionTF.resignFirstResponder()
	}
	
	@IBAction func saveButtonAction(_ sender: UIButton) {
		if videoUrlTF.text != "" && !videoUrlTF.text!.canOpenURL() {
			ILUtility.showAlert(message: "Please upload valid youtube url", controller:  self)
			return
		}
		let dic = ["resource_id": selectedDict["_id"] as? String ?? "","url": videoUrlTF.text!,"description": descriptionTF.text!] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.AddYouTubeUrlToGroupResourcesFolder(parameterDict: dic) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.descriptionTF.text = ""
			self.videoUrlTF.text = ""
			self.addYoutubeUrlView.isHidden = true
			self.videoUrlTF.resignFirstResponder()
			self.descriptionTF.resignFirstResponder()
			self.getResourceFolderList()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		enableDisableSaveButton()
	}
	
	func deleteFile(by Index: Int) {
		let dic = ["resource_id": selectedDict["_id"] as? String ?? "","file_id": "\(Index)"] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.deleteFileFromFolder(parameterDict: dic) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.attachments.remove(at: Index)
			self.filesTableView.reloadData()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "UploadFoldersFilesSegue" {
			let vc = segue.destination as! UploadFilesToFolderViewController
			vc.selectedDict = selectedDict
		}
    }
    
	@objc func menuButtonAction(_ sender: UIButton) {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let deleteFileAction = UIAlertAction(title: "Delete File", style: .default, handler: { (action) -> Void in
			self.deleteFile(by: sender.tag)
		})
		deleteFileAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(deleteFileAction)
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
			
		}))
		self.present(actionsheet, animated: true, completion: nil)
	}
}

extension GroupFolderDetailViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if attachments.count == 0 {
			let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyPostTableviewCellID", for: indexPath) as! EmptyPostTableviewCell
			return emptyCell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "UploadedTableViewCellImageID", for: indexPath) as! UploadedTableViewCellImage
		cell.setUI(dict: attachments[indexPath.row])
		cell.deleteButton.tag = indexPath.row
		cell.deleteButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if attachments.count == 0 {
			return 1
		}
		return attachments.count
	}
}
