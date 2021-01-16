//
//  ShareFileViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 6/8/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class ShareFileViewController: BaseHamburgerViewController {
	
	@IBOutlet weak var publicButton: UIButton!
	@IBOutlet weak var postButton: UIButton!
	@IBOutlet weak var filesTableView: UITableView!
	@IBOutlet weak var addFileButton: UIButton!
	var filesInfo: [[String: Any]] = []
	var dataDict: [String: Any] = [:]
	var msg_id = ""
	var isFrom = ""
	var groupID = ""
	var isUpdateFile = false
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Share File")
		enableDisablePostButton(isBool: false)
		publicButton.layer.borderWidth = 1.0
		publicButton.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		publicButton.layer.cornerRadius = 15.0
		publicButton.clipsToBounds = true
		
		addFileButton.layer.cornerRadius = addFileButton.frame.height / 2
		addFileButton.clipsToBounds = true
		filesTableView.tableFooterView = UIView(frame: .zero)
		setUI()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func postButton(_ sender: UIButton) {
		var dataArray: [[String: Any]] = []
		var existingFiles: [[String: Any]] = []
		for urlDict in filesInfo {
			if let url = urlDict["localUrl"] as? URL {
				var urlConvertedData: Data?
				do {
					urlConvertedData = try Data(contentsOf: url)
					
				} catch {
					print ("loading image file error")
				}
				if let data = urlConvertedData {
					let mimeType = (url.pathExtension == "pdf") ? "application/pdf" : "application/vnd"
					let dict = ["data": data, "fileName" : url.lastPathComponent, "mimeType" : mimeType] as [String: Any]
					dataArray.append(dict)
				}
			}
			else {
				let detailsDict = dataDict["details"] as? [String : Any] ?? [:]
				let files = detailsDict["attachments"] as? [[String: Any]] ?? []
				if let url = urlDict["serverUrl"] as? URL {
					let filterArray = files.filter { (dict) -> Bool in
						return url.lastPathComponent == dict["name"] as? String ?? ""
					}
					if filterArray.count > 0{
						existingFiles.append(filterArray[0])
					}
				}
			}
		}
		ILUtility.showProgressIndicator(controller: self)
		let visibility = (publicButton.titleLabel!.text == "Public") ? "public" : "only_me"
		var requestDict = ["visibility": visibility] as [String : Any]
		if isFrom == "Group" {
			requestDict["group_id"] = groupID
		}
		if isUpdateFile {
			let timeline_id = dataDict["_id"] as? String ?? ""
			requestDict["existing_files[]"] = existingFiles
			requestDict["timeline_id"] = timeline_id
			requestDict["post_id"] = msg_id
			requestDict["post_type"] = "user_file"
			SocialConnectAPI.sharedManaged.updateImageAlbumtypeOrFilesForTimelinePost(true,parameters:requestDict, imagesInfo: dataArray, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		else {
			SocialConnectAPI.sharedManaged.shareFilesForTimelinePost(parameters: requestDict, filesInfo: dataArray, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	@IBAction func addFileButtonAction(_ sender: UIButton){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
		documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true, completion: nil)
    }
	
	@IBAction func selectVisibilityDropdown(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
	}
	
    // MARK: - Navigation
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PopUpVCID" {
            let vc = segue.destination as! CustomPopUpViewController
			vc.selectedRowTitles = [publicButton.titleLabel?.text ?? ""]
			vc.selectionType = .Single
            vc.titleArray = ["Public", "Only Me"]
            vc.callBack = { (titles) in
				self.publicButton.setTitle(titles[0], for: .normal)
            }
        }
    }
	
	@objc func removeImageButtonAction(_ sender: UIButton) {
		filesInfo.remove(at: sender.tag)
		filesTableView.reloadData()
		enableDisablePostButton(isBool: filesInfo.count > 0)
	}
	
	func enableDisablePostButton(isBool: Bool) {
		postButton.isEnabled = isBool
		postButton.alpha = isBool ? 1.0 : 0.6
	}
	
	func setUI(){
		isUpdateFile = dataDict["isUpdateMode"] as? Bool ?? false
		let detailsDict = dataDict["details"] as? [String : Any] ?? [:]
		var visibility = dataDict["visibility"] as? String ?? "public"
		msg_id = detailsDict["message_id"] as? String ?? ""
		if visibility == "only_me" {
			visibility = "Only Me"
		}
		else {
			visibility = "Public"
		}
		
		let files = detailsDict["attachments"] as? [[String: Any]] ?? []
		let tmparay = files.map { (dict) -> [String: Any] in
			return ["serverUrl" : URL(string: "\(kImageAndFileBaseUrl)\(msg_id)/\(dict["name"] as! String)")!]
		}
		filesInfo = tmparay
		filesTableView.reloadData()
		self.publicButton.setTitle(visibility, for: .normal)
	}
}

extension ShareFileViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCellID", for: indexPath) as! AddImageTableViewCell
		cell.setUIForFile(urlDict: filesInfo[indexPath.row])
		cell.deleteButton.tag = indexPath.row
		cell.deleteButton.addTarget(self, action: #selector(removeImageButtonAction), for: .touchUpInside)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filesInfo.count
	}
}

extension ShareFileViewController: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		filesInfo.append(["localUrl": url])
		filesTableView.reloadData()
		enableDisablePostButton(isBool: filesInfo.count > 0)
	}
}
