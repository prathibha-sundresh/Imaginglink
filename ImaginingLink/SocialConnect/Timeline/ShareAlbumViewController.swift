//
//  ShareAlbumViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 6/6/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

class AddImageTableViewCell: UITableViewCell {
	@IBOutlet weak var borderView: UIView!
	@IBOutlet weak var fileImageView: UIImageView!
	@IBOutlet weak var fileName: UILabel!
	@IBOutlet weak var deleteButton: UIButton!
	
	func setUI(dict : [String: Any], msgID: String) {
		
		borderView.layer.cornerRadius = 4.0
		borderView.clipsToBounds = true
		if let info = dict["locaDict"] as? [UIImagePickerController.InfoKey : Any] {
			if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
				fileName.text = url.lastPathComponent
			}
			if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
				fileImageView.image = pickedImage
			}
		}
		else {
			let name = dict["file"] as? String ?? ""
			fileName.text = name
			let urlstr = "\(kImageAndFileBaseUrl)\(msgID)/\(name)"
			fileImageView.sd_setImage(with: URL(string: urlstr), placeholderImage: nil)
		}
	}
	
	func setUIForFile(urlDict : [String :Any]) {
		
		borderView.layer.cornerRadius = 4.0
		borderView.clipsToBounds = true
		var tmpUrl = URL(string: "")
		if let finalUrl = urlDict["serverUrl"] as? URL {
			tmpUrl = finalUrl
		}
		else {
			tmpUrl = urlDict["localUrl"] as? URL
		}
		
		updateUI(url: tmpUrl)
	}
	
	func setUIForUploadedFile(urlStr : String) {
		if let fileUrl = URL(string: urlStr) {
			updateUI(url: fileUrl)
		}
	}
	func updateUI(url : URL?){
		fileName.text = url?.lastPathComponent
		if url?.pathExtension == "pdf" {
			fileImageView.image = UIImage(named: "pdf_icon")
		}
		else if url?.pathExtension == "doc" || url?.pathExtension == "docx" {
			fileImageView.image = UIImage(named: "doc_icon")
		}
		else if url?.pathExtension == "ppt" || url?.pathExtension == "pptx" {
			fileImageView.image = UIImage(named: "ppt_icon")
		}
		else if url?.pathExtension == "xlsx" {
			fileImageView.image = UIImage(named: "xls_icon")
		}
	}
}

class ShareAlbumViewController: BaseHamburgerViewController {
	@IBOutlet weak var statusTextView: SZTextView!
	@IBOutlet weak var publicButton: UIButton!
	@IBOutlet weak var postButton: UIButton!
	@IBOutlet weak var addImageView: UIView!
	@IBOutlet weak var addImageTableView: UITableView!
	@IBOutlet weak var addImageButton: UIButton!
	
	var msg_id = ""
	@IBOutlet weak var albumTypeTF: UITextField!
	@IBOutlet weak var albumNameTF: UITextField!
	@IBOutlet weak var videoUrlTF: UITextField!
	var dataDict: [String: Any] = [:]
	var imagesInfo: [[String: Any]] = []
	var isUpdateStatus = false
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Share Album")
		enableDisablePostButton(isBool: false)
		publicButton.layer.borderWidth = 1.0
		publicButton.layer.borderColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.00).cgColor
		publicButton.layer.cornerRadius = 15.0
		publicButton.clipsToBounds = true
		
		addImageButton.layer.cornerRadius = addImageButton.frame.height / 2
		addImageButton.clipsToBounds = true
		
		addImageTableView.tableFooterView = UIView(frame: .zero)
		statusTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		
		setUI()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func postButton(_ sender: UIButton) {
		self.addImageView.isHidden ? postAlbumVideo() : postAlbumImages()
	}
	
	@IBAction func selectVisibilityDropdown(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
	}
	
	@IBAction func selectalbumTypeDropdown(_ sender: UIButton) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
	}
	
	@IBAction func addImageButtonAction(_ sender: UIButton){
        let alert = UIAlertController(title: "Select any option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
	
	func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
	
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PopUpVCID" {
            let vc = segue.destination as! CustomPopUpViewController
			vc.selectionType = .Single
			if sender as? Int == 100 {
				vc.titleArray = ["Public", "Only Me"]
				vc.selectedRowTitles = [publicButton.titleLabel?.text ?? ""]
			}
			else {
				vc.titleArray = ["Video", "Images"]
				vc.selectedRowTitles = [albumTypeTF.text!]
			}
            vc.callBack = { (titles) in
				
				if self.albumTypeTF.text != titles[0] {
					self.videoUrlTF.text = ""
					self.albumNameTF.text = ""
				}
				(sender as? Int == 100) ? self.publicButton.setTitle(titles[0], for: .normal) : (self.albumTypeTF.text = titles[0])
				if sender as? Int == 101 && titles[0] == "Images"{
					self.addImageView.isHidden = false
					self.statusTextView.isHidden = true
					self.videoUrlTF.placeholder = "Say something about this album"
				}
				else if sender as? Int == 101 && titles[0] == "Video"{
					self.addImageView.isHidden = true
					self.statusTextView.isHidden = false
					self.videoUrlTF.placeholder = "Attach Video URL"
				}
				if self.isUpdateStatus {
					let detailsDict = self.dataDict["details"] as? [String : Any] ?? [:]
					let album_type = detailsDict["album_type"] as? String ?? ""
					let selectedAlbumType = titles[0] == "Video" ? "video" : "image"
					if album_type == selectedAlbumType {
						self.setUI()
					}
					else {
						self.videoUrlTF.text = ""
						self.albumNameTF.text = ""
					}
				}
            }
        }
    }
    
	func postAlbumVideo(){
		
		ILUtility.showProgressIndicator(controller: self)
		let visibility = (publicButton.titleLabel!.text == "Public") ? "public" : "only_me"
		if isUpdateStatus {
			let timeline_id = dataDict["_id"] as? String ?? ""
			let requestDict = ["post_type": "album","timeline_id": timeline_id,"post_id": msg_id,"album_type":"video","album_name": albumNameTF.text!,"album_description": statusTextView.text!,"visibility":visibility,"video_url": videoUrlTF.text!]
			SocialConnectAPI.sharedManaged.updatePost(requestDict: requestDict, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		else {
			let requestDict = ["album_type":"video","album_name": albumNameTF.text!,"album_description": statusTextView.text!,"visibility":visibility,"video_url": videoUrlTF.text!]
			SocialConnectAPI.sharedManaged.createVideoAlbumtypeForTimelinePost(requestDict: requestDict, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		
	}
	
	func postAlbumImages() {
		
		var dataArray: [[String: Any]] = []
		var existingFiles: [String] = []
		for dict in imagesInfo {
			if let info = dict["locaDict"] as? [UIImagePickerController.InfoKey : Any] {
				if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
					if let imgData = pickedImage.jpegData(compressionQuality: 0.5) {
						var mimeType = ""
						var fileName = ""
						if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
							fileName = url.lastPathComponent
							if url.pathExtension == "png" {
								mimeType = "image/png"
							}
							else if url.pathExtension == "bmp" {
								mimeType = "image/bmp"
							}
							else {
								mimeType = "image/jpeg"
							}
						}
						let dict = ["data": imgData, "fileName" : fileName, "mimeType" : mimeType] as [String: Any]
						dataArray.append(dict)
					}
				}
			}
			else {
				let name = dict["file"] as? String ?? ""
				existingFiles.append(name)
			}
		}
		
		ILUtility.showProgressIndicator(controller: self)
		let visibility = (publicButton.titleLabel!.text == "Public") ? "public" : "only_me"
		var requestDict = ["album_type":"image","album_name": albumNameTF.text!,"album_description": videoUrlTF.text!,"visibility": visibility] as [String : Any]
		if isUpdateStatus {
			let timeline_id = dataDict["_id"] as? String ?? ""
			requestDict["existing_files[]"] = existingFiles
			requestDict["timeline_id"] = timeline_id
			requestDict["post_id"] = msg_id
			requestDict["post_type"] = "album"
			SocialConnectAPI.sharedManaged.updateImageAlbumtypeOrFilesForTimelinePost(parameters:requestDict, imagesInfo: dataArray, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		else {
			SocialConnectAPI.sharedManaged.createImageAlbumtypeForTimelinePost(parameters:requestDict, imagesInfo: dataArray, successResponse: { (response) in
				self.navigationController?.popViewController(animated: false)
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		validateFields()
	}
	
	func validateFields(){
		if albumTypeTF.text == "Images" && albumNameTF.text != "" && videoUrlTF.text != "" && imagesInfo.count > 0 {
			enableDisablePostButton(isBool: true)
		}
		else if albumTypeTF.text == "Video" && albumNameTF.text != "" && videoUrlTF.text != "" && statusTextView.text != "" {
				enableDisablePostButton(isBool: true)
		}
		else {
			enableDisablePostButton(isBool: false)
		}
	}
	
	@objc func removeImageButtonAction(_ sender: UIButton) {
		imagesInfo.remove(at: sender.tag)
		addImageTableView.reloadData()
		textDidChange(albumTypeTF)
	}
	
	func enableDisablePostButton(isBool: Bool) {
		postButton.isEnabled = isBool
		postButton.alpha = isBool ? 1.0 : 0.6
	}
	
	func setUI(){
		isUpdateStatus = dataDict["isUpdateMode"] as? Bool ?? false
		let detailsDict = dataDict["details"] as? [String : Any] ?? [:]
		var visibility = dataDict["visibility"] as? String ?? "public"
		msg_id = detailsDict["message_id"] as? String ?? ""
		if visibility == "only_me" {
			visibility = "Only Me"
		}
		else {
			visibility = "Public"
		}
		let album_type = detailsDict["album_type"] as? String ?? ""
		if album_type == "video" {
			if let videosUrls = detailsDict["attachments"] as? [String], videosUrls.count > 0 {
				videoUrlTF.text = videosUrls[0]
			}
			else{
				videoUrlTF.text = detailsDict["attachments"] as? String ?? ""
			}
			self.videoUrlTF.placeholder = "Attach Video URL"
			albumNameTF.text = detailsDict["message"] as? String ?? ""
			albumTypeTF.text = "Video"
			addImageView.isHidden = true
			statusTextView.isHidden = false
		}
		else {
			self.videoUrlTF.placeholder = "Say something about this album"
			albumNameTF.text = detailsDict["message"] as? String ?? ""
			albumTypeTF.text = "Images"
			addImageView.isHidden = false
			statusTextView.isHidden = true
			let files = detailsDict["attachments"] as? [String] ?? []
			let tmparay = files.map { (str) -> [String: Any] in
				return ["file" : str]
			}
			imagesInfo = tmparay
			addImageTableView.reloadData()
		}
		self.publicButton.setTitle(visibility, for: .normal)
	}

}

extension ShareAlbumViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCellID", for: indexPath) as! AddImageTableViewCell
		cell.setUI(dict: imagesInfo[indexPath.row], msgID: msg_id)
		cell.deleteButton.tag = indexPath.row
		cell.deleteButton.addTarget(self, action: #selector(removeImageButtonAction), for: .touchUpInside)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return imagesInfo.count
	}
}

extension ShareAlbumViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
	
		imagesInfo.append(["locaDict": info])
		addImageTableView.reloadData()
		textDidChange(albumTypeTF)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ShareAlbumViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		validateFields()
	}
}
