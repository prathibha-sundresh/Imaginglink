//
//  RemovePresentationsFileCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 12/12/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol RemovePresentationsFileCellDelegate {
	func updateFileUploadStatus(fileUpload: Bool, url: URL?)
	func submitAction(isDownloaded: Int)
}
class RemovePresentationsFileCell: UITableViewCell,UIDocumentPickerDelegate {
	var delegate: RemovePresentationsFileCellDelegate?
	var isFileUploaded: Bool = false
	var myController: UIViewController?
	@IBOutlet weak var downloadableConstraintH: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBOutlet weak var fileNameButton: UIButton!
	@IBOutlet weak var fileUploadButton: UIButton!
	
	@IBOutlet weak var addVideoUrlTF: UITextField!
	@IBOutlet weak var downloadableButton: UIButton!
	var controller: UIViewController?
	var isDownloadable = 0
	
	@IBAction func textDidchange(_ textField: UITextField) {
		
		if textField.text != "" {
			fileNameButton.setTitle("", for: .normal)
			fileNameButton.isHidden = true
			downloadableConstraintH.constant = 0
			downloadableButton.isSelected = false
			delegate?.updateFileUploadStatus(fileUpload: false, url: URL(string: textField.text!))
		}
	}
	
	@IBAction func uploadFileButtonAction(_ sender: Any) {
		
		let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
		documentPicker.delegate = self
		myController?.present(documentPicker, animated: true, completion: nil)
	}
	@IBAction func submitFileButtonAction(_ sender: UIButton){
		
		if !isFileUploaded && addVideoUrlTF.text == ""{
            ILUtility.showAlert(message: "PDF or YoutubeURL is mandatory", controller: myController!)
        }
		else if addVideoUrlTF.text != "" && !addVideoUrlTF.text!.canOpenURL() {
			ILUtility.showAlert(message: "Please upload valid youtube url", controller:  myController!)
			return
		}
		else{
			delegate?.submitAction(isDownloaded: isDownloadable)
		}
	}
	
	@IBAction func downloadableButtonAction(_ sender: UIButton) {
        if !sender.isSelected {
			downloadableButton.isSelected = true
			isDownloadable = 1
        } else {
			downloadableButton.isSelected = false
			isDownloadable = 0
        }
	}
	
	func setUI(fileName: String, fileUpload: Bool){
		
		fileNameButton.setTitle("\(fileName)", for: .normal)
		fileNameButton.isHidden = !fileUpload
		addVideoUrlTF.text = ""
		downloadableConstraintH.constant = fileUpload ? 20 : 0
	}
	
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		
		isFileUploaded = true
		addVideoUrlTF.text = ""
		print(url)
		print(url.lastPathComponent)
		print(url.pathExtension)
		
//		fileUrl = url
//		fileName = url.lastPathComponent
//		fileExtension = url.pathExtension
		fileNameButton.setTitle("  \(url.lastPathComponent)", for: .normal)
		fileNameButton.isHidden = false
		downloadableConstraintH.constant = 20
		downloadableButton.isSelected = false
		let tmpUrl = url
		delegate?.updateFileUploadStatus(fileUpload: isFileUploaded, url: tmpUrl)
	}
}
