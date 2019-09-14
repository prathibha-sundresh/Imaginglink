//
//  PresentationDetailViewcontroller.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 05/11/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import Alamofire

class PresentationDetailViewcontroller: BaseHamburgerViewController, UITableViewDataSource, UITableViewDelegate, CreateCommentDelegate {
    func clickonReplay(ParentId: String) {
        clickonReplay()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == CommentListCell) {
            if isCommentedSelected{
                if commentData != nil{
                    return commentData!.count
                }
                else{
                    return 0
                }
            }
            else{
               return 0
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
                ImageCell.setupUI(dic: dicData!)
                ImageCell.myViewcontroller = self
                ImageCell.delegate = self
            }
            tableViewCell = ImageCell
        } else if(indexPath.section == PresentationCell) {
            let presentationCell : PresentationDetailTextCell = tableView.dequeueReusableCell(withIdentifier: "PresentationDetailTextCellId", for: indexPath) as! PresentationDetailTextCell
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
            
                let commentListCell : CommentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentListTableViewCellId", for: indexPath) as! CommentListTableViewCell
                if (commentData != nil) {
                    commentListCell.delegate = self
                    commentListCell.setupUI(dic: commentData![indexPath.row])
                }
                tableViewCell = commentListCell
           
        }
        
        
        tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
//        if (indexPath.row == ImageViewCell) {
//            return 226
//        } else if (indexPath.row == PresentationCell) {
//            return UITableViewAutomaticDimension
//        } else if (indexPath.row == CommentCell) {
//            return 124
//        } else {
//            return 348
//        }
    }
    
    func clickonReplay() {
        let alertController = UIAlertController(title: "Add New Comment", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter message"
        }
        let saveAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            CoreAPI.sharedManaged.requestForcomments(comment: firstTextField.text!, parentcommentid: self.parentCommentId!, commentedcondition: "PUBLISHED", presentationid: self.userID!, successResponse: {(response) in
                self.presentationDetailTableView.reloadData()
            }, faliure: {(error) in
                
            })
        })
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
                    alert -> Void in
                })
    
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    var ImageViewCell = 0
    let PresentationCell = 1
    let CommentCell = 2
    let CommentListCell = 3
    
    var isCommentedSelected = false
    var alomafireRequest: Alamofire.Request?
    @IBOutlet weak var presentationDetailTableView: UITableView!
    var userID : String?
    var parentCommentId : String?
    var dicData : [String:Any]?
    var commentData : [[String:Any]]?
    fileprivate func getPresentationDetails() {
        presentationDetailTableView.isHidden = true
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.getUserPresentationWithId(UserID: userID!, successResponse: {(response) in
            let value = response as! String
            let dic : [String : Any] = value.convertToDictionary()!
            self.dicData = dic["data"] as? [String : Any]
            if let authorId : String = self.dicData?["id"] as? String {
                
                CoreAPI.sharedManaged.getCommentListWithId(presentationId: authorId, successResponse: {(response) in
                    self.presentationDetailTableView.isHidden = false
                    ILUtility.hideProgressIndicator(controller: self)
                    let value = response as! String
                    let dic : [String : Any] = value.convertToDictionary()!
                    let Commentarray : [[String:Any]] = dic["data"] as! [[String : Any]]
                    if (Commentarray.count != 0) {
                        let parentId = Commentarray[0]
                        self.parentCommentId = parentId["id"] as? String
                        self.commentData = Commentarray
                    }
                    self.presentationDetailTableView.reloadData()
                }, faliure: {(error) in
                    ILUtility.hideProgressIndicator(controller: self)
                })
            }
      
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton(showBackButton: true,backbuttonTitle: "Presentation")
        self.presentationDetailTableView.delegate = self
        presentationDetailTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: presentationDetailTableView.frame.width, height: 25))
        getPresentationDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        alomafireRequest?.cancel()
    }
    @IBAction func menuPressedButtonAction(_ sender: UIButton){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
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
        else if segue.identifier == "fullImageVCID"{
            let vc : FullSizeImageViewController = segue.destination as! FullSizeImageViewController
            vc.imagesDict = sender as! [String: Any]
        }
    }
    
}
extension PresentationDetailViewcontroller: CommentDelegate{
    func sendCommentsToAPI(comments: String) {
        CoreAPI.sharedManaged.requestForcomments(comment: comments, parentcommentid: self.parentCommentId ?? "", commentedcondition: "PUBLISHED", presentationid: userID ?? "", successResponse: {(response) in
            self.presentationDetailTableView.reloadData()
        }, faliure: {(error) in
            
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
        if let comments = commentData?.count, comments > 0 && isSelected{
            let indexPath = IndexPath(row: 0, section: 3)
            presentationDetailTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
extension PresentationDetailViewcontroller: ImagePressDelegate{
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
