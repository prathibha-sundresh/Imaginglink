//
//  UploadFilesToFolderViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/8/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class UploadFilesToFolderViewController: BaseHamburgerViewController {
	@IBOutlet weak var filesTableView: UITableView!
	@IBOutlet weak var descriptionTF: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	var filesInfo: [[String: Any]] = []
	var selectedDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Share files")
		enableDisableSaveButton()
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = false
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		enableDisableSaveButton()
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	func enableDisableSaveButton() {
		let isBool = filesInfo.count > 0 && descriptionTF.text! != ""
		saveButton.isEnabled = isBool
		saveButton.alpha = isBool ? 1.0 : 0.6
	}
	@objc func removeImageButtonAction(_ sender: UIButton) {
		filesInfo.remove(at: sender.tag)
		filesTableView.reloadData()
	}
	
	@IBAction func saveFilesButtonAction(_ sender: UIButton) {
		var dataArray: [[String: Any]] = []
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
		}
		let dic = ["group_id": selectedDict["group_id"] as? String ?? "", "resource_id": selectedDict["_id"] as? String ?? "","description": descriptionTF.text!] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.uploadResourceFilesToFolder(parameters: dic, filesInfo: dataArray, successResponse: { (response) in
			self.navigationController?.popViewController(animated: false)
			ILUtility.hideProgressIndicator(controller: self)
			self.descriptionTF.resignFirstResponder()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func shareFilesButtonAction(_ sender: UIButton) {
		let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
		documentPicker.delegate = self
		documentPicker.modalPresentationStyle = .overFullScreen
		present(documentPicker, animated: true, completion: nil)
	}
}

extension UploadFilesToFolderViewController: UITableViewDataSource, UITableViewDelegate {
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

extension UploadFilesToFolderViewController: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		filesInfo.append(["localUrl": url])
		filesTableView.reloadData()
		enableDisableSaveButton()
	}
}
