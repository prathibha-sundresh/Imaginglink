//
//  MyPresentationsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/4/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import WebKit

class MyPresentationsTableViewCell: UITableViewCell {

	@IBOutlet weak var borderView: UIView!
	@IBOutlet weak var wkWebview: WKWebView!
	@IBOutlet weak var URLImageView: UIImageView!
	@IBOutlet weak var UserImageView: UIImageView!
	@IBOutlet weak var UsernameLabel: UILabel!
	@IBOutlet weak var ImaginingLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var presentationTypeLabel: UILabel!
	@IBOutlet weak var HeadingTitleLabel: UILabel!
	weak var myVC : UIViewController?
	@IBOutlet weak var previewAndSubmitBtnView: UIView!
	@IBOutlet weak var previewBtnView: UIView!
	@IBOutlet weak var previewSubmitRejectBtnView: UIView!
	@IBOutlet weak var previewBtn: UIButton!
	@IBOutlet weak var submitForReviewButton: UIButton!
	@IBOutlet weak var onlyPreviewBtn1: UIButton!
	@IBOutlet weak var previewBtn2: UIButton!
	@IBOutlet weak var approveBtn: UIButton!
	@IBOutlet weak var rejectBtn: UIButton!
	@IBOutlet weak var commentView: UIView!
	@IBOutlet weak var viewsAndCommentLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
	enum PresentationStatus: String {
		case All = "ALL"
		case Draft = "DRAFT"
		case CoAuthored = "CO-AUTHORED"
		case Published = "PUBLISHED"
		case EditorModified = "REVIEW_EDITED"
		case PendingReview = "REVIEW"
		case NeedModification = "NEED MODIFICATION"
		case Rejected = "REJECTED"
	}
	
	func setupUI(dic: [String:Any]) {
        
		self.selectionStyle = .none
		previewBtn.layer.borderColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
		onlyPreviewBtn1.layer.borderColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        borderView.layer.borderWidth = 1.0
        borderView.layer.cornerRadius = 4.0
		borderView.layer.borderColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha: 0.5).cgColor
        setUpProfileImage()
        ImaginingLabel.layer.borderColor = UIColor(red:0.98, green:0.58, blue:0.00, alpha:1.0).cgColor
        ImaginingLabel.layer.cornerRadius = 10
        ImaginingLabel.layer.borderWidth = 1
        
		HeadingTitleLabel.text = (dic["title"] as? String ?? "").capitalized
		presentationTypeLabel.layer.cornerRadius = presentationTypeLabel.frame.size.height / 2
        presentationTypeLabel.clipsToBounds = true
        timeLabel.text = dic["created_at"] as? String ?? ""
        ImaginingLabel.text! = "     \(dic["section_short"] as? String ?? "")     ".uppercased()
        if let author : [String : Any] = dic["author"] as? [String:Any] {
            let authorName = author["name"] as? String ?? ""
            UsernameLabel.text! = authorName.capitalized
            if let photo : String = author["profile_photo"] as? String {
                UserImageView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            }
        }
        if let imageURL : String = dic["presentation_master_url"] as? String {
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                
                let url : URL = URL(string: imageURL)!
                wkWebview.isHidden = false
                wkWebview.load(URLRequest(url: url))
                if (URLImageView != nil) {
                    URLImageView.isHidden = true
                }
            } else {
                URLImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "ImagingLinkLogo"))
                wkWebview.isHidden = true
                if (URLImageView != nil) {
                    URLImageView.isHidden = false
                }
            }
        }
		
		let views = "\((dic["views_count"] as? NSNumber ?? 0).stringValue)"
        let totalComments = dic["total_comments_count"] as? Int ?? 0
        viewsAndCommentLabel.text = "\(totalComments) Comments      \(views) Views"
        LikeLabel.text = "\((dic["likes_count"] as? NSNumber ?? 0).stringValue)"
		
		var statusStr = dic["status"] as? String ?? ""
		let status = PresentationStatus.init(rawValue: statusStr)
		var statusColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
		previewAndSubmitBtnView.isHidden = true
		previewBtnView.isHidden = true
		previewSubmitRejectBtnView.isHidden = true
		commentView.isHidden = true
		switch status {
		case .All:
			break
		case .Draft:
			previewAndSubmitBtnView.isHidden = false
		case .CoAuthored, .NeedModification:
			previewBtnView.isHidden = false
		case .Published:
			statusColor = UIColor(red:0.15, green:0.31, blue:0.07, alpha:1.0)
			commentView.isHidden = false
		case .EditorModified:
			previewSubmitRejectBtnView.isHidden = false
			statusStr = "Editor Modified"
			statusColor = UIColor(red:0.06, green:0.33, blue:0.80, alpha:1.0)
		case .PendingReview , .Rejected:
			statusStr = (status == .PendingReview) ? "Pending Review" : "Rejected"
			statusColor = (status == .PendingReview) ? UIColor(red:0.97, green:0.70, blue:0.42, alpha:1.0) : UIColor(red:0.82, green:0.17, blue:0.17, alpha:1.0)
		default:
			break
		}
		presentationTypeLabel.text = "     \(statusStr.capitalized)     "
		presentationTypeLabel.textColor = statusColor
    }
    
    func setUpProfileImage() {
        UserImageView.layer.borderWidth = 1.0
        UserImageView.layer.masksToBounds = false
        UserImageView.layer.borderColor = UIColor.white.cgColor
        UserImageView.layer.cornerRadius = UserImageView.frame.size.height / 2
        UserImageView.clipsToBounds = true
    }
}

class MyPresentationsViewController: BaseHamburgerViewController {
	@IBOutlet weak var myPresenationTableView: UITableView!
	@IBOutlet weak var noPresentationsFoundView: UIImageView!
	@IBOutlet weak var footerView: UIView!
	var dataArray : [[String:Any]] = []
	var sections: [[String: Any]] = []
    var subSections: [String: Any] = [:]
	var isClickedOnEditModified = false
	var isShowHideResutlsLbl: Bool = false {
		didSet {
			noPresentationsFoundView.isHidden = isShowHideResutlsLbl
			myPresenationTableView.isHidden = !isShowHideResutlsLbl
		}
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		myPresenationTableView.tableFooterView = footerView
		isShowHideResutlsLbl = dataArray.count > 0
        // Do any additional setup after loading the view.
    }
    
	@IBAction func backButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func menuAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "UpdatePresentationVCID" {
			let vc = segue.destination as! UpdatePresentationViewController
			vc.presentationID = sender as? String ?? ""
			vc.isFromFilterCard = true
			vc.sections = sections
			vc.subSections = subSections
			vc.delegate = self
		}
		else if segue.identifier == "FinalSubmissionVCID" {
			let vc : FinalSubmissionViewController = segue.destination as! FinalSubmissionViewController
			vc.presentationID = sender as? String ?? ""
			vc.isFromPresentationsFiltered = true
			vc.delegate = self
		}
		else if (segue.identifier == "PresentationDetail") {
            let vc : PresentationDetailViewcontroller = segue.destination as! PresentationDetailViewcontroller
            vc.userID = sender as? String
			vc.isComingFromMyPresentation = true
			vc.isEditorModified = isClickedOnEditModified
        }
    }
    
	func navigateToSegue(_ dict: [String: Any], identifier: String) {
		self.performSegue(withIdentifier: identifier, sender: dict["id"] as? String ?? "")
	}
	
	@objc func previewBtnAction(_ sender: UIButton) {
		navigateToSegue(dataArray[sender.tag], identifier: "UpdatePresentationVCID")
	}
	
	@objc func previewBtn2Action(_ sender: UIButton) {
		isClickedOnEditModified = true
		navigateToSegue(dataArray[sender.tag], identifier: "PresentationDetail")
	}
	
	@objc func submitForReviewAction(_ sender: UIButton) {
		navigateToSegue(dataArray[sender.tag], identifier: "FinalSubmissionVCID")
	}
	
	@objc func acceptAction(_ sender: UIButton) {
		let dict = dataArray[sender.tag]
		let tempDict = ["presentation_id": dict["id"] as? String ?? "", "is_approved": 1] as [String : Any]
		acceptOrRejectAction(requestDict: tempDict, index: sender.tag)
	}
	
	@objc func rejectAction(_ sender: UIButton) {
		let dict = dataArray[sender.tag]
		let tempDict = ["presentation_id": dict["id"] as? String ?? "", "is_approved": 0] as [String : Any]
		acceptOrRejectAction(requestDict: tempDict, index: sender.tag)
	}
	
	func acceptOrRejectAction(requestDict: [String: Any], index: Int) {
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.authorApproveOrRejectEditorChangesToPresentation(params: requestDict, successResponse: { (response) in
			self.dataArray.remove(at: index)
			self.myPresenationTableView.reloadData()
			self.isShowHideResutlsLbl = self.dataArray.count > 0
			ILUtility.hideProgressIndicator(controller: self)
			let isApproved = requestDict["is_approved"] as? Int ?? 0
			if isApproved == 0 {
				ILUtility.showAlert(message: "Rejected editor changes and presentation will move to rejected list", controller: self)
			}
			else{
				ILUtility.showAlert(message: "Approved to editor changes and published", controller: self)
			}
			
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
}

extension MyPresentationsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataArray.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MyPresentationsTableViewCell", for: indexPath) as! MyPresentationsTableViewCell
		cell.setupUI(dic: dataArray[indexPath.row])
		cell.previewBtn.tag = indexPath.row
		cell.submitForReviewButton.tag = indexPath.row
		cell.onlyPreviewBtn1.tag = indexPath.row
		cell.previewBtn2.tag = indexPath.row
		cell.previewBtn.addTarget(self, action: #selector(previewBtnAction), for: .touchUpInside)
		cell.onlyPreviewBtn1.addTarget(self, action: #selector(previewBtnAction), for: .touchUpInside)
		cell.previewBtn2.addTarget(self, action: #selector(previewBtn2Action), for: .touchUpInside)
		cell.approveBtn.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
		cell.rejectBtn.addTarget(self, action: #selector(rejectAction), for: .touchUpInside)
		cell.submitForReviewButton.addTarget(self, action: #selector(submitForReviewAction), for: .touchUpInside)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if dataArray[indexPath.row]["status"] as? String ?? "" == "PUBLISHED" {
			navigateToSegue(dataArray[indexPath.row], identifier: "PresentationDetail")
		}
	}
}

extension MyPresentationsViewController: FinalSubmissionViewControllerDelegate{
	func removePresentationCard(id: String) {
		if let index = dataArray.firstIndex(where: {$0["id"] as! String == id}) {
			self.dataArray.remove(at: index)
			self.isShowHideResutlsLbl = self.dataArray.count > 0
			self.myPresenationTableView.reloadData()
		}
	}
}

extension MyPresentationsViewController: UpdatePresentationViewControllerDelegate{
	func sendPresentationToRemove(id: String) {
		removePresentationCard(id: id)
	}
}
