//
//  CreatePresentationViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/19/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class KeywordsCVCell: UICollectionViewCell {
    @IBOutlet weak var nameButton: UIButton!
    func SetUI() {
        nameButton.layer.borderWidth = 1.0
        nameButton.layer.borderColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        nameButton.layer.cornerRadius = 15.0
        nameButton.clipsToBounds = true
        
    }
}
class CreatePresentationViewController: UIViewController {
    var selectedSubsections: [String] = []
    @IBOutlet weak var subSectionsCV: UICollectionView!
    @IBOutlet weak var subSectionConstraintY: NSLayoutConstraint!
	@IBOutlet weak var downloadableConstraintH: NSLayoutConstraint!
    var sections: [[String: Any]] = []
    var subSections: [String: Any] = [:]
    @IBOutlet weak var sectionTitleTF: UITextField!
    @IBOutlet weak var keywordsTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var addVideoUrlTF: UITextField!
	@IBOutlet weak var fileNameButton: UIButton!
	@IBOutlet weak var downloadableButton: UIButton!
	@IBOutlet weak var subSectionTextLabel: UILabel!
	var isDownloadable = 0
    var isFileUploaded: Bool = false
	var fileExtension: String = ""
	var fileName: String = ""
	var fileUrl: URL?
	var isSubSectionEmpty: Bool = false {
		didSet{
			self.subSectionConstraintY.constant = isSubSectionEmpty ? 60 : 20
			subSectionTextLabel.text = isSubSectionEmpty ? " Sub-section(s)*" : "Sub-section(s)*".uppercased()
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		getSections()
		fileNameButton.isHidden = true
		downloadableConstraintH.constant = 0
		subSectionConstraintY.constant = 60
        // Do any additional setup after loading the view.
    }
    
	@IBAction func textDidchange(_ textField: UITextField) {
		
		if textField == addVideoUrlTF{
			if textField.text != "" {
				isFileUploaded = false
				fileNameButton.setTitle("", for: .normal)
				fileNameButton.isHidden = true
				downloadableConstraintH.constant = 0
				downloadableButton.isSelected = false
			}
		}
		
	}
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PopUpVCID" {
            
            let vc = segue.destination as! CustomPopUpViewController
            var subSectionsTmpArray = [[String: Any]]()
            if sectionTitleTF.text != "" {
                if let tmpArray = subSections[sectionTitleTF.text!] as? [[String: Any]]{
                    subSectionsTmpArray = tmpArray
                }
            }
			vc.selectionType = sender as? Int == 100 ? .Single : .Multiple
			vc.selectedRowTitles = sender as? Int == 100 ? [sectionTitleTF.text!] : selectedSubsections
            let tmpArray = sender as? Int == 100 ? sections : subSectionsTmpArray
            vc.titleArray = tmpArray.map({ (dict) -> String in
                return dict["title"] as? String ?? ""
            })
            vc.callBack = { (titles) in
                if sender as? Int == 100{
					self.sectionTitleTF.text = titles[0]
					self.selectedSubsections.removeAll()
                }
                else{
					self.selectedSubsections = titles
                }
				self.isSubSectionEmpty = self.selectedSubsections.isEmpty ? true : false
				self.subSectionsCV.reloadData()
            }
        }
		else if segue.identifier == "UpdatePresentationVCID" {
			let vc = segue.destination as! UpdatePresentationViewController
			vc.presentationID = sender as? String ?? ""
			vc.sections = sections
			vc.subSections = subSections
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
	
    @IBAction func nextButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "UpdatePresentationVCID", sender: "5e02fcdd4b0f60212a570d71")
//		return
//		//isFileUploaded = true
        let subSectionsStr = selectedSubsections.joined(separator: ",")
        
        if titleTF.text == "" {
            ILUtility.showAlert(message: "Title is mandatory", controller: self)
        }
        else if sectionTitleTF.text == "" {
            ILUtility.showAlert(message: "Section is mandatory", controller: self)
        }
        else if selectedSubsections.count == 0 {
            ILUtility.showAlert(message: "Sub-Section(s) is mandatory", controller: self)
        }
		else if keywordsTF.text == "" {
			ILUtility.showAlert(message: "Keyword(s) are mandatory", controller: self)
		}
		else if descriptionTF.text == "" {
			ILUtility.showAlert(message: "Description is mandatory", controller: self)
		}
        else if !isFileUploaded && addVideoUrlTF.text == ""{
            ILUtility.showAlert(message: "PDF or YoutubeURL is mandatory", controller: self)
        }
		else if addVideoUrlTF.text != "" && !addVideoUrlTF.text!.canOpenURL() {
			ILUtility.showAlert(message: "Please upload valid youtube url", controller: self)
			return
		}
        else{
			var requestDict = ["title": titleTF.text!, "section": sectionTitleTF.text!, "sub_sections": subSectionsStr, "is_downloadable": isDownloadable, "keywords": keywordsTF.text!, "description": descriptionTF.text!, "university": "", "isFromFileUpdate": false] as [String : Any]
            
            if addVideoUrlTF.text != "" {
				requestDict["is_file_upload"] = 0
                requestDict["youtube_url"] = addVideoUrlTF.text! //"https://www.youtube.com/watch?v=JczSfmRpwUQ"//
            }
            else{
                //file upload
//				fileUrl = URL(string: Bundle.main.path(forResource: "sample", ofType: "pdf")!)
//				fileName = "sample.pdf"
//				fileExtension = "pdf"
                requestDict["is_file_upload"] = 1
				requestDict["fileUrl"] = fileUrl
				requestDict["fileName"] = fileName
				requestDict["fileExtension"] = fileExtension
            }
			
			ILUtility.showProgressIndicator(controller: self)
			CoreAPI.sharedManaged.createOrFileUpdatePresentation(params: requestDict, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				if let dict = response["data"] as? [String: Any]{
					self.performSegue(withIdentifier: "UpdatePresentationVCID", sender: dict["presentation_id"] as? String ?? "")
				}
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
        }
        
        
    }
    
    @IBAction func selectSectionsAndSubSections(_ sender: UIButton) {
        
        if sender.tag == 100 {
            self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
        }
        else if sender.tag == 101{
            self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
        }
        
    }
    
    func getSections() {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.getSectionsAndSubSections(successResponse: { (response) in
            
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any] {
                self.sections = dict1["sections"] as? [[String: Any]] ?? []
                self.subSections = dict1["sub_sections"] as? [String: Any] ?? [:]
            }
            ILUtility.hideProgressIndicator(controller: self)
        }) { (errorMessage) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
    @IBAction func uploadFileButtonAction(_ sender: Any) {
		
		let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
	
	@objc func removeSubSection(_ sender: UIButton){
		selectedSubsections.remove(at: sender.tag)
		self.isSubSectionEmpty = self.selectedSubsections.isEmpty ? true : false
		subSectionsCV.reloadData()
	}
	
}
extension CreatePresentationViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! KeywordsCVCell
		cell.nameButton.tag = indexPath.item
        cell.nameButton.setTitle("    \(selectedSubsections[indexPath.item])   ✕    ", for: .normal)
		cell.nameButton.addTarget(self, action: #selector(removeSubSection), for: .touchUpInside)
        cell.SetUI()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSubsections.count
    }
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ("    \(selectedSubsections[indexPath.item])    ✕    ").size(withAttributes: nil)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension CreatePresentationViewController: UIDocumentPickerDelegate{

	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		
		isFileUploaded = true
		addVideoUrlTF.text = ""
		print(url)
		print(url.lastPathComponent)
		print(url.pathExtension)
		
		fileUrl = url
		fileName = url.lastPathComponent
		fileExtension = url.pathExtension
		fileNameButton.setTitle("  \(fileName)", for: .normal)
		fileNameButton.isHidden = false
		downloadableConstraintH.constant = 20
		downloadableButton.isSelected = false
	}
}

extension String{
	func canOpenURL() -> Bool {
		if let url = NSURL(string: self) {
			// check if your application can open the NSURL instance
			return UIApplication.shared.canOpenURL(url as URL)
		}
		return false
	}
}
