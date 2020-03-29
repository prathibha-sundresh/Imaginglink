//
//  PresentationDetailViewcontroller.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 05/11/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import Alamofire

class CommentListWithOutReplyTableViewCell : UITableViewCell {
	@IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var ImageView: UIImageView!
	
	func setUI(dic: [String:Any]) {
        
        if let comment = dic["comment"] as? String {
            commentLbl?.text = comment
        }
        if let createdAt = dic["created_at"] as? String {
            timeLabel?.text = createdAt
        }
		setUpProfileImage()
    }
    
    func setUpProfileImage() {
        ImageView.layer.borderWidth = 1.0
        ImageView.layer.borderColor = UIColor.white.cgColor
        ImageView.layer.cornerRadius = ImageView.frame.size.width / 2
        ImageView.clipsToBounds = true
    }
}

class PresentationDetailViewcontroller: BaseHamburgerViewController, UITableViewDataSource, UITableViewDelegate, CreateCommentDelegate {
    func clickonReplay(index: Int) {
        let dict = ParentAndChildComments[index]
        let id = dict["id"] as? String ?? ""
        clickonReplay(parentID: id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == CommentListCell) {
            if isCommentedSelected{
                return ParentAndChildComments.count
            }
            else{
               return 0
            }
        }
		if (section == CommentCell) {
			if isEditorModified {
				return 0
			} else {
				return 1
			}
		}
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
    
        if (indexPath.section == ImageViewCell) {
            let ImageCell : ImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCellId", for: indexPath) as! ImageTableViewCell
            if (dicData != nil) {
                ImageCell.currentPage = fullSizeCurrentIndex
				ImageCell.editorModifiedCard = isEditorModified
                ImageCell.setupUI(dic: dicData!)
                ImageCell.myViewcontroller = self
                ImageCell.delegate = self
            }
            tableViewCell = ImageCell
        } else if(indexPath.section == PresentationCell) {
            let presentationCell : PresentationDetailTextCell = tableView.dequeueReusableCell(withIdentifier: "PresentationDetailTextCellId", for: indexPath) as! PresentationDetailTextCell
			presentationCell.editorModifiedCard = isEditorModified
            if (dicData != nil) {
                presentationCell.setupValue(dic: dicData!)
            }
            presentationCell.delegate = self
            presentationCell.controller = self
            tableViewCell = presentationCell
        } else if(indexPath.section == CommentCell) {
            let commentCell : CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCellId", for: indexPath) as! CommentTableViewCell
            if (dicData != nil) {
                commentCell.delegate = self
                commentCell.myViewcontroller = self
                commentCell.setupUI(dic: dicData!)
            }
            commentCell.commentButton.isSelected = isCommentedSelected
            tableViewCell = commentCell
        } else if(indexPath.section == CommentListCell) {
            
			if isEditorModified {
				let commentListWithOutReplyCell : CommentListWithOutReplyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentListWithOutReplyCellId", for: indexPath) as! CommentListWithOutReplyTableViewCell
				commentListWithOutReplyCell.setUI(dic: ParentAndChildComments[indexPath.row])
				tableViewCell = commentListWithOutReplyCell
			}
			else {
				let commentListCell : CommentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentListTableViewCellId", for: indexPath) as! CommentListTableViewCell
				commentListCell.delegate = self
				commentListCell.replyButton.tag = indexPath.row
				commentListCell.setupUI(dic: ParentAndChildComments[indexPath.row])
				commentListCell.separatorInset = UIEdgeInsets(top: 0, left: commentListCell.bounds.size.width, bottom: 0, right: 0);
				tableViewCell = commentListCell
			}
            
        }
        tableViewCell.selectionStyle = UITableViewCell.SelectionStyle.none
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    fileprivate func determineParentAndChildComments(_ response: AnyObject) {
        if let dic = response as? [String: Any]{
            self.dicData?["parent_comments_count"] = dic["parent_comment_count"] as? Int ?? 0
            self.dicData?["child_comments_count"] = dic["child_comment_count"] as? Int ?? 0
            if let Commentarray : [[String:Any]] = dic["data"] as? [[String : Any]]{
                self.getParentAndChildComments(dataArray: Commentarray)
                self.presentationDetailTableView.reloadSections([2,3], with: .fade)
            }
        }
    }
    
    func clickonReplay(parentID: String) {
		self.performSegue(withIdentifier: "AddCommentReplyVCID", sender: parentID)
    }
    @objc func textChanged(_ sender:UITextField) {
        self.saveAction?.isEnabled  = (sender.text! != "")
    }
    var ImageViewCell = 0
    let PresentationCell = 1
    let CommentCell = 2
    let CommentListCell = 3
    
    var saveAction : UIAlertAction?
    var isCommentedSelected = false
	var isComingFromMyPresentation = false
	var isEditorModified = false
    var alomafireRequest: Alamofire.Request?
    @IBOutlet weak var presentationDetailTableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    var userID : String?
    var dicData : [String:Any]?
    var commentData : [[String:Any]] = []
    var ParentAndChildComments : [[String:Any]] = []
    var fullSizeCurrentIndex: Int = 0
	var parentCommentID: String = ""
	
	func parseData(_ response: AnyObject) {
		let value = response as! String
		let dic : [String : Any] = value.convertToDictionary()!
		self.dicData = dic["data"] as? [String : Any]
		if isEditorModified {
			ILUtility.hideProgressIndicator(controller: self)
			if let commentarray = self.dicData?["review_comments"] as? [[String:Any]] {
				self.getParentAndChildComments(dataArray: commentarray)
				isCommentedSelected = true
				self.presentationDetailTableView.reloadData()
			}
			return
		}
		if let authorId : String = self.dicData?["id"] as? String {
			
			CoreAPI.sharedManaged.getCommentListWithId(presentationId: authorId, successResponse: {(response) in
				self.presentationDetailTableView.isHidden = false
				ILUtility.hideProgressIndicator(controller: self)
				let value = response as! String
				let dic : [String : Any] = value.convertToDictionary()!
				let commentarray : [[String:Any]] = dic["data"] as! [[String : Any]]
				if (commentarray.count != 0) {
					self.getParentAndChildComments(dataArray: commentarray)
				}
				self.presentationDetailTableView.reloadData()
			}, faliure: {(error) in
				ILUtility.hideProgressIndicator(controller: self)
			})
		}
	}
	
	fileprivate func getPublicPresentationDetails() {
        presentationDetailTableView.isHidden = true
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.getUserPresentationWithId(UserID: userID!, successResponse: {(response) in
			self.parseData(response)
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
    
	func getUserPresentationDetails() {
		presentationDetailTableView.isHidden = true
		ILUtility.showProgressIndicator(controller: self)
		CoreAPI.sharedManaged.getUserPresentationDetails(presentationID: userID!, successResponse: { (response) in
			self.presentationDetailTableView.isHidden = false
			self.parseData(response)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
    func getParentAndChildComments(dataArray: [[String: Any]]){
		//review_comments
        commentData = dataArray
        var totalCommentsArray = [[String: Any]]()
        for dict in commentData{
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
        ParentAndChildComments = totalCommentsArray
        //print(commentData.count, ParentAndChildComments.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationDetailTableView.tableFooterView = footerView
        addSlideMenuButton(showBackButton: true,backbuttonTitle: "Presentation")
        self.presentationDetailTableView.delegate = self
        presentationDetailTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: presentationDetailTableView.frame.width, height: 25))
		isComingFromMyPresentation ? getUserPresentationDetails() : getPublicPresentationDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
		self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        alomafireRequest?.cancel()
		self.navigationController?.isNavigationBarHidden = true
		self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func menuPressedButtonAction(_ sender: UIButton){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        var title = ""
        if let IsFollowed = dicData?["is_followed_by_me"] as? Int, IsFollowed == 0{
            title = "Follow this post"
        }
        else{
            title = "UnFollow this post"
        }
        
        let followPostAction = UIAlertAction(title: title, style: .default, handler: { (action) -> Void in
            self.followAndUnfollow()
        })
        let image = UIImage(named: "FollowPost_Icon")
        followPostAction.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
        followPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
        actionsheet.addAction(followPostAction)
        
        let reportPostAction = UIAlertAction(title: "Report post", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "ReportPostID", sender: self.userID)
        })
        let image1 = UIImage(named: "ReportPost_Icon")
        reportPostAction.setValue(image1?.withRenderingMode(.alwaysOriginal), forKey: "image")
        reportPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
        actionsheet.addAction(reportPostAction)
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    func followAndUnfollow(){
        
        let presentationID = dicData?["id"] as? String ?? ""
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.requestFollowUnFollow(presentationID: presentationID, successResponse: {(response) in
            ILUtility.hideProgressIndicator(controller: self)
            let value = response as! [String:Any]
            ILUtility.showAlert(title: self.dicData?["title"] as? String ?? "Imaginglink",message: value["message"] as? String ?? "", controller: self)
            if let IsFollowed = self.dicData?["is_followed_by_me"] as? Int, IsFollowed == 0{
                self.dicData?["is_followed_by_me"] = 1
            }
            else{
                self.dicData?["is_followed_by_me"] = 0
            }
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ReportPostID") {
            let vc : ReportPostViewController = segue.destination as! ReportPostViewController
            vc.userID = sender as? String ?? ""
            vc.presentationTitle = self.dicData?["title"] as? String ?? "Imaginglink"
        }
        else if segue.identifier == "fullImageVCID" {
            let vc : FullSizeImageViewController = segue.destination as! FullSizeImageViewController
            vc.imagesDict = sender as! [String: Any]
            vc.delegate = self
        }
		else if segue.identifier == "AddCommentReplyVCID" {
			let vc : AddCommentReplyViewController = segue.destination as! AddCommentReplyViewController
			vc.callBack = { (replyMessage) in
				ILUtility.showProgressIndicator(controller: self)
				CoreAPI.sharedManaged.requestForcomments(comment: replyMessage, parentcommentid: sender as? String ?? "", commentedcondition: "PUBLISHED", presentationid: self.userID!, successResponse: {(response) in
					ILUtility.hideProgressIndicator(controller: self)
					self.determineParentAndChildComments(response)
				}, faliure: {(error) in
					ILUtility.hideProgressIndicator(controller: self)
				})
			}
		}
    }

}
extension PresentationDetailViewcontroller: CommentDelegate{
    func sendCommentsToAPI(comments: String) {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.requestForcomments(comment: comments, parentcommentid: "0", commentedcondition: "PUBLISHED", presentationid: userID ?? "", successResponse: {(response) in
            
            ILUtility.hideProgressIndicator(controller: self)
            if let dic = response as? [String: Any]{
                self.dicData?["parent_comments_count"] = dic["parent_comment_count"] as? Int ?? 0
                self.dicData?["child_comments_count"] = dic["child_comment_count"] as? Int ?? 0
                if let Commentarray : [[String:Any]] = dic["data"] as? [[String : Any]]{
                    self.getParentAndChildComments(dataArray: Commentarray)
                    self.presentationDetailTableView.reloadSections([2,3], with: .fade)
                }
            }
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
    func updatePresentationDict(dict: [String : Any]) {
        dicData = dict
        let indexPath = IndexPath(item: 0, section: CommentCell)
        presentationDetailTableView.reloadRows(at: [indexPath], with: .fade)
    }
    func clickOnCommentButton(isSelected: Bool) {
        isCommentedSelected = isSelected
        presentationDetailTableView.reloadSections([2,3], with: .fade)
        if ParentAndChildComments.count > 0 && isSelected{
            let indexPath = IndexPath(row: 0, section: 3)
            presentationDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension PresentationDetailViewcontroller: FullSizeImageViewDelegate{
    func showFullImage(imagesUrls: [String],index: Int) {
        let tmpDict = ["index": index, "images": imagesUrls] as [String : Any]
        self.performSegue(withIdentifier: "fullImageVCID", sender: tmpDict)
        
    }
    func updatePresentationDictForFavourite(dict: [String : Any]) {
        dicData = dict
        let indexPath = IndexPath(item: 0, section: ImageViewCell)
        presentationDetailTableView.reloadRows(at: [indexPath], with: .fade)
    }
}
extension PresentationDetailViewcontroller: PresentationDetailTextCellDelegate{
    func cancelRequest(request: Request) {
        alomafireRequest = request
    }
}
extension PresentationDetailViewcontroller: FullSizeImageViewControllerDelegate{
    func currentPageIndex(index: Int) {
        fullSizeCurrentIndex = index
        let indexPath = IndexPath(item: 0, section: ImageViewCell)
        presentationDetailTableView.reloadRows(at: [indexPath], with: .fade)
    }
}
