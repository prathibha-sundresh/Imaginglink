//
//  PresentationDetailTextCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import Alamofire

protocol PresentationDetailTextCellDelegate: class {
    func cancelRequest(request: Alamofire.Request)
}

class PresentationDetailTextCell : UITableViewCell {
    
    @IBOutlet weak var AllowToDownloadLabel: UILabel!
	@IBOutlet weak var AllowToDownloadHintLabel: UILabel!
	@IBOutlet weak var DownloadButtonY: NSLayoutConstraint!
    @IBOutlet weak var univercityValueLabel: UILabel!
    @IBOutlet weak var PrimaryAuthorValueLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var SampleKeywordLabel: UILabel!
    @IBOutlet weak var SubSectionLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var DescriptionTitleLabel: UILabel!
    @IBOutlet weak var univercityLabel: UILabel!
    @IBOutlet weak var coAuthorsLabel: UILabel!
    @IBOutlet weak var coAuthorsValueLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadH: NSLayoutConstraint!
    @IBOutlet weak var downloadW: NSLayoutConstraint!
    @IBOutlet weak var downloadProgressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var downloadCancelButton: UIButton!
    var downloadableLink : String = ""
    var request: Alamofire.Request?
    weak var controller: UIViewController?
    weak var delegate: PresentationDetailTextCellDelegate?
    func setupValue(dic: [String:Any]) {
        
        setProgressUI(isBool: true)
        if var isDownloadable = dic["is_downloadable"] as? Int
        {
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                isDownloadable = 0
            }
            if (isDownloadable == 1)
            {
                if let downloadLink = dic["downloadable_file_link"] as? String {
                    downloadableLink = downloadLink
                }
            }
        }
        
        if let description = dic["description"] as? String
        {
            DescriptionLabel?.text = "\(description)"
            DescriptionLabel.numberOfLines = 0
        }
        
        if let section = dic["section"] as? String
        {
            sectionLabel?.text = section
        }
        if let subsections = dic["sub_sections"] as? [String]
        {
			SubSectionLabel?.text = subsections.joined(separator: ",")
//            if keywords.count == 1{
//                SubSectionLabel?.text = keywords[0]
//            }
//            else if keywords.count == 2{
//                SubSectionLabel?.text = keywords[0] + "," + keywords[1]
//            }
//            else if keywords.count >= 2{
//                SubSectionLabel?.text = keywords[0] + "," + keywords[1] + " " + "+\(keywords.count - 2)"
//            }
        }
        if let coAuthors = dic["co_authors"] as? [[String: Any]], coAuthors.count > 0
        {
            var str = coAuthors.reduce("") { (result, dict) -> String in
                return result + "\(dict["name"] as? String ?? "")" + ","
            }
            if str[str.index(before: str.endIndex)] == ","{
                str.removeLast()
            }
            coAuthorsValueLabel.text = str
        }
        else{
            coAuthorsLabel.text = ""
            coAuthorsValueLabel.text = ""
        }
        if let keywords = dic["keywords"] as? [String]
        {
            SampleKeywordLabel?.text = keywords.joined(separator: ",")
        }
        
        if var isDownloadable = dic["is_downloadable"] as? Int
        {
			var isFileTypeVideo = false
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                isDownloadable = 0
				isFileTypeVideo = true
            }
            if isDownloadable == 1{
                AllowToDownloadLabel?.text = "Yes"
                downloadButton.layer.cornerRadius = 18
                downloadButton.clipsToBounds = true
                downloadButton.isHidden = false
                downloadH.constant = 36
            }
            else{
				AllowToDownloadLabel?.text = isFileTypeVideo ? "" : "No"
				AllowToDownloadHintLabel.text = isFileTypeVideo ? "" : "Allow other to download"
				DownloadButtonY.constant = isFileTypeVideo ? -12 : 12
                downloadButton.isHidden = true
                downloadH.constant = 0
            }
        }
        else{
			if ((dic["presentation_type"] as? String)?.contains("video"))! {
				AllowToDownloadHintLabel.text = ""
				AllowToDownloadLabel?.text = ""
				DownloadButtonY.constant = -30
			}
			else{
				AllowToDownloadLabel?.text = "No"
				AllowToDownloadHintLabel.text = "Allow other to download"
				DownloadButtonY.constant = 12
			}
            downloadButton.isHidden = true
            downloadH.constant = 0
        }
        if let title = dic["title"] as? String
        {
			DescriptionTitleLabel?.text = title.capitalized
        }
        
        if let author : [String : Any] = dic["author"] as? [String:Any] {
            PrimaryAuthorValueLabel?.text = author["name"] as? String
            if let university = author["university"] as? String {
                univercityValueLabel?.text = university
            } else {
                univercityValueLabel?.text = ""
                univercityLabel?.text = ""
            }
        }
     }
    func setProgressUI(isBool: Bool){
        downloadProgressView.layer.cornerRadius = 10
        downloadProgressView.clipsToBounds = true
        downloadProgressView.isHidden = isBool
        downloadCancelButton.isHidden = isBool
        progressLabel.isHidden = isBool
    }
    @IBAction func tapOnDownloadCancel(_ sender: UIButton){
        request?.cancel()
        request = nil
        downloadProgressView.progress = 0.0
        setProgressUI(isBool: true)
        downloadButton.isSelected = false
        downloadButton.setTitle("Download", for: .normal)
        progressLabel.text = "0%"
    }
    @IBAction func tapOnDownload(_ sender: UIButton){
        
        downloadCancelButton.layer.cornerRadius = 10
        downloadCancelButton.layer.borderWidth = 1.0
        downloadCancelButton.layer.borderColor = UIColor(red:0.89, green:0.00, blue:0.00, alpha:1.0).cgColor
        downloadCancelButton.clipsToBounds = true
        
        if checkFileExistsOrNot(){
            ILUtility.showAlert(message: "Already file downloaded", controller: controller!)
            return
        }
        else{
            setProgressUI(isBool: false)
            if request != nil{
                if !downloadButton.isSelected{
                    downloadButton.isSelected = true
                    downloadButton.setTitle("Downloading", for: .normal)
                    request?.resume()
                }
                else{
                    downloadButton.isSelected = false
                    downloadButton.setTitle("Download", for: .normal)
                    request?.suspend()
                }
                return
            }
            else{
                downloadButton.isSelected = true
                downloadButton.setTitle("Downloading", for: .normal)
            }
            request = Alamofire.request("\(downloadableLink)").downloadProgress(closure : { (progress) in
                //print(progress.fractionCompleted)
                self.downloadProgressView.progress = Float(progress.fractionCompleted)
                let percentageValue = Int((Float(progress.fractionCompleted) * 100).rounded())
                self.progressLabel.text = "\(percentageValue)%"
            }).responseData{ (response) in
                
                if let data = response.result.value {
                    
                    let array = self.downloadableLink.components(separatedBy: "/")
                    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destinationFileUrl = documentsUrl.appendingPathComponent(array.last!)
                    do {
                        try data.write(to: destinationFileUrl)
                        self.setProgressUI(isBool: true)
                        self.downloadButton.setTitle("Downloaded", for: .normal)
                        self.downloadButton.isEnabled = false
                        self.downloadButton.alpha = 0.8
                    } catch {
                        print("Something went wrong!")
                    }
                }
            }
            self.delegate?.cancelRequest(request: request!)
        }
    }
    
    func createDirectory(){
        
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: documentsUrl.path, isDirectory: &isDirectory)
        if exists && isDirectory.boolValue{
            return
        }
        
        let destinationFileUrl = documentsUrl.appendingPathComponent("Imaginglink")
        do
        {
            try FileManager.default.createDirectory(atPath: destinationFileUrl.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
    }
    func checkFileExistsOrNot()-> Bool{
        createDirectory()
        let array = downloadableLink.components(separatedBy: "/")
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(array.last!)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationFileUrl.path) {
            return true
        } else {
            return false
        }
    }
}

