//
//  UpdatePresentationViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/20/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
	@IBOutlet weak var UserNameLbl: UILabel!
	@IBOutlet weak var UserImageView: UIImageView!
	@IBOutlet weak var deleteFileBtn: UIButton!
	func setUI(dict: [String: Any]) {
		
		let status = dict["status"] as? String ?? ""
		if status == "REVIEW_EDITED" {
			deleteFileBtn.isHidden = true
		}
		else {
			deleteFileBtn.isHidden = false
		}
		if let author : [String : Any] = dict["author"] as? [String:Any] {
			UserNameLbl.text! = (author["name"] as! String).capitalized
            if let photo : String = author["profile_photo"] as? String {
                UserImageView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            }
        }
		UserImageView.layer.cornerRadius = UserImageView.frame.height / 2
		UserImageView.clipsToBounds = true
	}
}

class ImageViewCell: UITableViewCell,UIScrollViewDelegate {
	@IBOutlet weak var currentPageLabel: UILabel!
	@IBOutlet weak var leftButton: UIButton!
	@IBOutlet weak var rightButton: UIButton!
	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var imageScrollView: UIScrollView!
	@IBOutlet weak var imagesView: UIView!
	var images: [String] = []
    var currentPage: Int = 0
	var delegate : FullSizeImageViewDelegate?
	
	func setUI(dict: [String: Any]) {
		imageScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
		if dict["presentation_type"] as? String  == "video"{
			webView.loadRequest(URLRequest(url: URL(string: dict["presentation_master_url"] as? String ?? "")!))
			imagesView.isHidden = true
			webView.isHidden = false
		}
		else{
			if let tmpPhotos = dict["presentation_jpg_files"] as? [[String: Any]] {
				let photos = tmpPhotos.map{ $0["image"] as? String ?? "" }
				webView.isHidden = true
				imagesView.isHidden = false
				images = photos
				addImagesToScroll(images: photos)
				
			}
		}
	}
	
	func addImagesToScroll(images: [String]){
        
        if images.count > 1{
            currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
            leftButton.isHidden = true
            rightButton.isHidden = false
			currentPageLabel.isHidden = false
        }
        else{
            currentPageLabel.isHidden = true
            leftButton.isHidden = true
            rightButton.isHidden = true
        }
        
        for (index,image) in images.enumerated(){
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * imageScrollView.frame.width, y: 0.0, width: imageScrollView.frame.width, height: 200))
            
            imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            imageScrollView.addSubview(imageView)
        }
        imageScrollView.contentSize = CGSize(width: CGFloat(images.count) * imageScrollView.frame.width, height: imageScrollView.frame.height)
        let x = CGFloat(currentPage) * CGFloat(imageScrollView.frame.width)
        
        imageScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
        showHideLeftButton()
        showHideRightButton()
    }
    
    @IBAction func scrollLeft(_ sender: UIButton) {
        
        if currentPage != 0{
            currentPage = currentPage - 1
            currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
            var frame = imageScrollView.frame
            frame.origin.x = frame.size.width * CGFloat(currentPage)
            imageScrollView.scrollRectToVisible(frame, animated: true)
        }
        showHideLeftButton()
        showHideRightButton()
    }
    
    @IBAction func scrollRight(_ sender: UIButton) {
        
        if images.count - 1 > currentPage{
            var frame = imageScrollView.frame
            currentPage = currentPage + 1
            currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
            frame.origin.x = frame.size.width * CGFloat(currentPage)
            imageScrollView.scrollRectToVisible(frame, animated: true)
        }
        showHideLeftButton()
        showHideRightButton()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(imageScrollView.contentOffset.x / imageScrollView.frame.size.width)
        currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
        showHideLeftButton()
        showHideRightButton()
    }
    func showHideLeftButton(){
        if currentPage > 0{
            leftButton.isHidden = false
        }
        else{
            leftButton.isHidden = true
        }
		delegate?.getCurrentIndex?(index: currentPage)
    }
    func showHideRightButton(){
        if images.count - 1 > currentPage{
            rightButton.isHidden = false
        }
        else{
            rightButton.isHidden = true
        }
		delegate?.getCurrentIndex?(index: currentPage)
    }
    @IBAction func showFullSizeImage(_ sender: UIButton){
        delegate?.showFullImage(imagesUrls: images,index: currentPage)
    }
}

extension UpdatePresentationViewController: FullSizeImageViewDelegate{
    func showFullImage(imagesUrls: [String],index: Int) {
        let tmpDict = ["index": index, "images": imagesUrls] as [String : Any]
        self.performSegue(withIdentifier: "fullImageVCID", sender: tmpDict)
    }
	
	func getCurrentIndex(index: Int) {
		fullSizeCurrentIndex = index
	}
}

@objc protocol UpdatePresentationViewControllerDelegate {
	@objc optional func sendPresentationToRemove(id: String)
}

class UpdatePresentationViewController: UIViewController {
	
	enum PresentationType: String{
		case Video = "video"
		case Pdf = "pdf"
		case Others = "others"
		
		func type() {
			return
		}
	}
	var delegate: UpdatePresentationViewControllerDelegate?
    @IBOutlet weak var updatePresentationTV: UITableView!
	var responseDict = [String: Any]()
	var originalResponseDict = [String: Any]()
	var sections: [[String: Any]] = []
	var subSections: [String: Any] = [:]
	var selectedSubsections: [String] = []
	var selectedCoauthors: [[String: Any]] = []
	var presentationTypeStr: PresentationType = PresentationType.Others
	var presentationID: String = ""
	var parentAndChildComments : [[String:Any]] = []
	var isDeletedFile = false
	var fullSizeCurrentIndex: Int = 0
	var isFileUploaded: Bool = false
	var fileExtension: String = ""
	var fileName: String = ""
	var fileUrl: URL?
	var addVideoUrlTF: String = ""
	var isEditButtonEnabled: Bool = true
	var sectionTitle: String = ""
	var coAuthors: [[String: Any]] = []
	@IBOutlet weak var saveAsDraftButton: UIButton!
	@IBOutlet weak var submitForReviewButton: UIButton!
	@IBOutlet weak var submitForReviewViewH: NSLayoutConstraint!
	var isFromFilterCard: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
		
		updatePresentationTV.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
		getCoAuthors()
		getUserPresentationDetails()
		updatePresentationTV.tableFooterView = UIView(frame: .zero)

        // Do any additional setup after loading the view.
    }
    
	override func viewWillAppear(_ animated: Bool) {
		self.tabBarController?.tabBar.isHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		self.tabBarController?.tabBar.isHidden = false
	}
	
    @IBAction func backButtonAction(_ sender: UIButton) {
		if isFromFilterCard{
			self.navigationController?.popViewController(animated: true)
		}
		else {
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			appDelegate.openDashBoardScreen()
		}
    }
    @IBAction func submitForReviewBtnAction(_ sender: UIButton) {
		if isDeletedFile{
			ILUtility.showAlert(message: "Please upload valid pdf/ppt file or youtube url.", controller: self)
		}
		else{
			self.performSegue(withIdentifier: "FinalSubmissionVCID", sender: nil)
		}
    }
	
	func getPresentationFileType(dict: [String: Any]) -> PresentationType{
		
		if dict["presentation_type"] as? String  == "video" {
			presentationTypeStr = PresentationType.Video
		}
		else if dict["presentation_type"] as? String  == "jpeg"{
			if let images = dict["presentation_jpg_files"] as? [[String: Any]], images.count > 0{
				presentationTypeStr = PresentationType.Pdf
			}
			else{
				presentationTypeStr = PresentationType.Others
			}
		}
		return presentationTypeStr
	}
	
	func getCoAuthors() {
		CoreAPI.sharedManaged.getCoAuthors(successResponse: { (response) in
			let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let array = dict["data"] as? [[String: Any]] {
                self.coAuthors = array
            }
		}) { (error) in
			
		}
	}
	
	func getUserPresentationDetails() {
		//5deb53534b0f603e4d7da5c1 - video
		//5e02fcdd4b0f60212a570d71 - pdf
		//5dec98f14b0f6045312a5622 - ppt
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.getUserPresentationDetails(presentationID: presentationID, successResponse: { (response) in
			self.updatePresentationTV.isHidden = false
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any] {
                self.responseDict = dict1
				self.originalResponseDict = dict1
				self.selectedSubsections = self.responseDict["sub_sections"] as? [String] ?? []
				self.selectedCoauthors = self.responseDict["co_authors"] as? [[String: Any]] ?? []
				if self.isFromFilterCard {
					self.showHideSaveAsDraftAndSubmitButton()
				}
				if let reviewComments = dict1["review_comments"] as? [[String: Any]], reviewComments.count > 0 {
					self.getParentAndChildComments(dataArray: reviewComments)
				}
            }
			self.updatePresentationTV.reloadData()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func showHideSaveAsDraftAndSubmitButton() {
		let status = responseDict["status"] as? String ?? ""
		let isCoauthor = responseDict["is_co_author"] as? Bool ?? false
		if status == "DRAFT" && !isCoauthor{
			//Draft
			saveAsDraftButton.isHidden = true
			submitForReviewButton.isHidden = false
		}
		else if (status == "DRAFT" && isCoauthor) ||  status == "REVIEW_EDITED"{
			//Coauthor card or EDITOR MODIFIED
			saveAsDraftButton.isHidden = true
			submitForReviewButton.isHidden = true
			submitForReviewViewH.constant = 0
		}
		else if status == "NEED MODIFICATION" {
			//NEED MODIFICATION
			saveAsDraftButton.isHidden = true
			submitForReviewButton.isHidden = false
		}
	}
	
	@IBAction func saveAsDraftPresentations() {
		
		if isDeletedFile{
			ILUtility.showAlert(message: "Please upload valid pdf/ppt file or youtube url.", controller: self)
		}
		else{
			ILUtility.showProgressIndicator(controller: self)
			CoreAPI.sharedManaged.savePresentation(params: ["presentation_id": presentationID, "is_submit_for_review": 0], successResponse: { (response) in
				ILUtility.showAlert(message: "Presentation saved as draft successfully.", controller: self)
				self.saveAsDraftButton.isHidden = true
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	func getParentAndChildComments(dataArray: [[String: Any]]){
        
        var totalCommentsArray = [[String: Any]]()
        for dict in dataArray{
            totalCommentsArray.append(dict)
            if let tmpArray = dict["child_comments"] as? [[String: Any]], tmpArray.count > 0{
                let childArray = tmpArray.map { (tempDict) -> [String : Any] in
                    var dict1 = tempDict
                    dict1["commentType"] = "Child"
                    return dict1
                }
                totalCommentsArray.append(contentsOf: childArray)
            }
        }
        parentAndChildComments = totalCommentsArray
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "AddCommentReplyVCID" {
			let vc : AddCommentReplyViewController = segue.destination as! AddCommentReplyViewController
			vc.callBack = { (replyMessage) in
				ILUtility.showProgressIndicator(controller: self)
				CoreAPI.sharedManaged.requestForcomments(comment: replyMessage, parentcommentid: sender as? String ?? "", commentedcondition: "REVIEW", presentationid: self.presentationID, successResponse: {(response) in
					ILUtility.hideProgressIndicator(controller: self)
					if let Commentarray : [[String:Any]] = response["data"] as? [[String : Any]]{
						self.getParentAndChildComments(dataArray: Commentarray)
						self.updatePresentationTV.reloadSections([4], with: .fade)
					}
				}, faliure: {(error) in
					ILUtility.hideProgressIndicator(controller: self)
				})
			}
		}
		else if segue.identifier == "fullImageVCID" {
			let vc : FullSizeImageViewController = segue.destination as! FullSizeImageViewController
            vc.imagesDict = sender as! [String: Any]
            vc.delegate = self
		}
		else if segue.identifier == "FinalSubmissionVCID" {
			let vc : FinalSubmissionViewController = segue.destination as! FinalSubmissionViewController
			vc.presentationID = presentationID
			vc.isFromPresentationsFiltered = isFromFilterCard
			vc.delegate = self
		}
		else if segue.identifier == "PopUpVCID" {
            
            let vc = segue.destination as! CustomPopUpViewController
			
			if sender as! Int == 103 {
				vc.selectionType = .Multiple
				vc.sectionType = .AddCoAuthors
				vc.isCoAuthor = true
				if selectedCoauthors.count > 0 {
					let coAuthorsNames = selectedCoauthors.map { $0["full_name"] as? String ?? "" }
					vc.selectedRowTitles = coAuthorsNames
				}
				vc.titleArray = coAuthors.map({ (dict) -> String in
					return dict["full_name"] as? String ?? ""
				})
			}
			else{
				vc.selectionType = sender as? Int == 100 ? .Single : .Multiple
				vc.sectionType = sender as? Int == 100 ? .Section : .SubSection
				var subSectionsTmpArray = [[String: Any]]()
				if sectionTitle != "" {
					if let tmpArray = subSections[sectionTitle] as? [[String: Any]]{
						subSectionsTmpArray = tmpArray
					}
				}
				let tmpArray = sender as? Int == 100 ? sections : subSectionsTmpArray
				vc.titleArray = tmpArray.map({ (dict) -> String in
					return dict["title"] as? String ?? ""
				})
				vc.selectedRowTitles = sender as? Int == 100 ? [sectionTitle] : selectedSubsections
			}
            
            vc.callBack = { (titles) in
				
				var tmpDict = self.responseDict
                if sender as? Int == 100{
					tmpDict["section"] = titles[0]
                    self.sectionTitle = titles[0]
					self.selectedSubsections.removeAll()
					tmpDict["sub_sections"] = self.selectedSubsections
                }
                else if sender as? Int == 101{
					self.selectedSubsections = titles
					tmpDict["sub_sections"] = self.selectedSubsections
                }
				else if sender as? Int == 103{
					
					var idAndauthors = [[String : Any]]()
					for str in titles{
						let tmpArray = self.coAuthors.filter { (dict) -> Bool in
							return (dict["full_name"] as? String ?? "") == str
						}
						if tmpArray.count > 0{
							idAndauthors.append(tmpArray[0])
						}
					}
					self.selectedCoauthors = idAndauthors
				}
				self.responseDict = tmpDict
				self.updatePresentationTV.reloadSections([2], with: .fade)
            }
        }
    }
    
	@objc func deleteFileAction(_ sender: UIButton){
		let alert = UIAlertController(title: "Imaginglink", message: "Are you sure you want to delete this file and upload a new file", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
			self.isDeletedFile = true
			self.fullSizeCurrentIndex = 0
			self.updatePresentationTV.reloadSections([0,1], with: .fade)
		}))
		alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
}

extension UpdatePresentationViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 5
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 4{
			return parentAndChildComments.count
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		if indexPath.section == 0 {
			let userCell: UserDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserCellID", for: indexPath) as! UserDetailsTableViewCell
			userCell.deleteFileBtn.addTarget(self, action: #selector(deleteFileAction), for: .touchUpInside)
			userCell.deleteFileBtn.isHidden = isDeletedFile ? true : false
			userCell.setUI(dict: responseDict)
			cell = userCell
		}
		else if indexPath.section == 1 {
			
			//RemovePresentationsFileCellID
			//PPTorPPtxFileCellID
			//ImageViewCellID
			
			if isDeletedFile {
				let fileUploadCell: RemovePresentationsFileCell = tableView.dequeueReusableCell(withIdentifier: "RemovePresentationsFileCellID", for: indexPath) as! RemovePresentationsFileCell
				fileUploadCell.setUI(fileName: fileName, fileUpload: isFileUploaded)
				fileUploadCell.myController = self
				fileUploadCell.delegate = self
				cell = fileUploadCell
			}
			else{
				var presentationTypeCell: ImageViewCell = ImageViewCell()
				let pType = getPresentationFileType(dict: responseDict)
				switch pType {
				case .Video , .Pdf :
					presentationTypeCell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCellID", for: indexPath) as! ImageViewCell
					presentationTypeCell.currentPage = fullSizeCurrentIndex
					presentationTypeCell.setUI(dict: responseDict)
					presentationTypeCell.delegate = self
					cell = presentationTypeCell
				default:
					cell = tableView.dequeueReusableCell(withIdentifier: "PPTorPPtxFileCellID", for: indexPath)
				}
			}
		}
		else if indexPath.section == 2 {
			let editPresentationCell: EditPresentationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UpdatePresentationsCellID", for: indexPath) as! EditPresentationTableViewCell
			editPresentationCell.editButtonEnabled = isEditButtonEnabled
			editPresentationCell.selectedCoauthors = selectedCoauthors
			editPresentationCell.delegate = self
			editPresentationCell.myController = self
			//editPresentationCell.selectedSubsections = selectedSubsections
			//editPresentationCell.sectionTitleTF.text = sectionTitle
			editPresentationCell.setUI(dict: responseDict)
			cell = editPresentationCell
		}
		else if indexPath.section == 3 {
			let sendCommentPresentationCell: SendCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCellID", for: indexPath) as! SendCommentTableViewCell
			sendCommentPresentationCell.setUI(id: presentationID, dict: responseDict)
			sendCommentPresentationCell.myViewcontroller = self
			sendCommentPresentationCell.delegate = self
			cell = sendCommentPresentationCell
		}
		else if indexPath.section == 4 {
			let commentListCell: CommentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentListTableViewCellId", for: indexPath) as! CommentListTableViewCell
			
			commentListCell.delegate = self
            commentListCell.replyButton.tag = indexPath.row
            commentListCell.setupUI(dic: parentAndChildComments[indexPath.row])
            commentListCell.separatorInset = UIEdgeInsets(top: 0, left: commentListCell.bounds.size.width, bottom: 0, right: 0);
			let status = responseDict["status"] as? String ?? ""
			if status == "REVIEW_EDITED" {
				commentListCell.isUserInteractionEnabled = false
			}
			else {
				commentListCell.isUserInteractionEnabled = true
			}
            cell = commentListCell
		}
		cell.selectionStyle = .none
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

extension UpdatePresentationViewController: SendCommentDelegate {
	func callPresentationAPI(dataArray: [[String : Any]]) {
		getParentAndChildComments(dataArray: dataArray)
		updatePresentationTV.reloadSections([4], with: .fade)
	}
}

extension UpdatePresentationViewController: CreateCommentDelegate {
	func clickonReplay(index: Int) {
        let dict = parentAndChildComments[index]
        let id = dict["id"] as? String ?? ""
        self.performSegue(withIdentifier: "AddCommentReplyVCID", sender: id)
    }
}

extension UpdatePresentationViewController: FullSizeImageViewControllerDelegate{
    func currentPageIndex(index: Int) {
        fullSizeCurrentIndex = index
		updatePresentationTV.reloadSections([1], with: .fade)
    }
}

extension UpdatePresentationViewController: UIDocumentPickerDelegate{

	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
		
		isFileUploaded = true
		
		print(url)
		print(url.lastPathComponent)
		print(url.pathExtension)

		fileUrl = url
		fileName = url.lastPathComponent
		fileExtension = url.pathExtension
		
	}
}

extension UpdatePresentationViewController: RemovePresentationsFileCellDelegate{
	func updateFileUploadStatus(fileUpload: Bool, url: URL?) {
		isFileUploaded = fileUpload
		if isFileUploaded {
			addVideoUrlTF = ""
			if let tempUrl = url{
				fileUrl = tempUrl
				fileName = tempUrl.lastPathComponent
				fileExtension = tempUrl.pathExtension
			}
		}
		else{
			addVideoUrlTF = url?.absoluteString ?? ""
		}
	}
	
	func submitAction(isDownloaded: Int) {
		
		var requestDict = ["presentation_id": presentationID, "is_downloadable": isDownloaded, "isFromFileUpdate": true] as [String : Any]
		
		if addVideoUrlTF != "" {
			requestDict["is_file_upload"] = 0
			requestDict["youtube_url"] = addVideoUrlTF
			//"https://www.youtube.com/watch?v=JczSfmRpwUQ"//
		}
		else{
			//file upload
			requestDict["is_file_upload"] = 1
			requestDict["fileUrl"] = fileUrl
			requestDict["fileName"] = fileName
			requestDict["fileExtension"] = fileExtension
		}
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.createOrFileUpdatePresentation(params: requestDict, successResponse: { (response) in
			self.isDeletedFile = false
			self.fileUrl = URL(string: "")
			self.fileName = ""
			self.fileExtension = ""
			self.addVideoUrlTF = ""
			self.isFileUploaded = false
			ILUtility.hideProgressIndicator(controller: self)
			self.getUserPresentationDetails()
		}, faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
}

extension UpdatePresentationViewController: EditPresentationTableViewCellDelegate {
	func removeSubSection(subSections: [String]) {
		var tmpDict = self.responseDict
		tmpDict["sub_sections"] = self.selectedSubsections
		self.responseDict = tmpDict
	}
	
	func addCoAuthorsToPresentation() {
		if selectedCoauthors.count == 0{
			ILUtility.showAlert(message: "Please select Co-Authors.", controller:self)
			return
		}
		
		let coAuthorsIDs = (selectedCoauthors.map { $0["id"] as? String ?? "" }).joined(separator: ",")
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.addCoAuthors(params: ["co_authors": coAuthorsIDs, "presentation_id": presentationID], successResponse: { (response) in
			ILUtility.showAlert(message: "Co-Authors submitted sucessfully.", controller: self)
			self.getUserPresentationDetails()
			ILUtility.hideProgressIndicator(controller: self)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func selectCoAuthorsFromDropDown(tag: Int) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: tag)
	}
	
	func updateTitle(title: String) {
		var tmpDict = responseDict
		tmpDict["title"] = title
		responseDict = tmpDict
	}
	
	func updateKeywords(keywords: [String]) {
		var tmpDict = responseDict
		tmpDict["keywords"] = keywords
		responseDict = tmpDict
	}
	
	func updateDescription(description: String) {
		var tmpDict = responseDict
		tmpDict["description"] = description
		responseDict = tmpDict
	}
	
	func updateUniverisity(univerisity: String) {
		var tmpDict = responseDict
		tmpDict["university"] = univerisity
		responseDict = tmpDict
	}
	
	func editButtonEnabled(isEnabled: Bool) {
		isEditButtonEnabled = isEnabled
		if isEnabled == false {
			responseDict = originalResponseDict
		}
		updatePresentationTV.reloadSections([2], with: .fade)
	}
	
	func sectionsAndSubSections(tag: Int, sectionName: String) {
		sectionTitle = sectionName
		self.performSegue(withIdentifier: "PopUpVCID", sender: tag)
	}
	
	func updateDownloadStatus(tag: Int) {
		self.performSegue(withIdentifier: "PopUpVCID", sender: tag)
	}
	
	func updatePresentationDetails() {
		
		let subSectionsStr = selectedSubsections.joined(separator: ",")
		let keywords = (responseDict["keywords"] as? [String] ?? []).joined(separator: ",")
		let requestDict = ["presentation_id": presentationID,"title": responseDict["title"]!, "section": responseDict["section"]!,"keywords": keywords, "description": responseDict["description"] as? String ?? "", "university": responseDict["university"] as? String ?? "", "sub_sections": subSectionsStr, "edited_by": "AUTHOR"] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.updateUserPresentationDetails(params: requestDict, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getUserPresentationDetails()
			ILUtility.showAlert(message: "Presentation details are successfully updated.", controller: self)
			self.editButtonEnabled(isEnabled: false)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
}
extension UpdatePresentationViewController: FinalSubmissionViewControllerDelegate{
	func pushToPresentationScreen(){
		let storyBoard = UIStoryboard(name: "DashBoard", bundle: nil)
		let vc = storyBoard.instantiateViewController(withIdentifier: "PresentationViewController") as! PresentationViewController
		vc.isFromPresentations = true
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	func removePresentationCard(id: String){
		self.navigationController?.popViewController(animated: true)
		self.delegate?.sendPresentationToRemove?(id: id)
	}
}
