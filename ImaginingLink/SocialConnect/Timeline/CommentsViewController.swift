//
//  CommentsViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 6/3/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

class CommentsViewController: UIViewController {

	@IBOutlet weak var commentTableview: UITableView!
	var dataDict: [String: Any] = [:]
	var commentsArray: [[String: Any]] = []
	@IBOutlet weak var commentTextView: SZTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
		getParentAndChildComments()
		commentTableview.tableFooterView = UIView(frame: CGRect.zero)
		commentTextView.placeholder = "Write your comment"
		commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        commentTextView.placeholderTextColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1)
        commentTextView.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
        commentTextView.layer.borderColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 16
		
        // Do any additional setup after loading the view.
    }
    
	@IBAction func closeButtonAction(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
    
	func getTimelineDetails() {
		let postID = dataDict["_id"] as? String ?? ""
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.getTimelineDetails(timeLineID: postID, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let tmpDict = dic["data"] as? [String : Any] {
				self.dataDict = tmpDict
				self.getParentAndChildComments()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "AddCommentReplyVCID" {
			let vc : AddCommentReplyViewController = segue.destination as! AddCommentReplyViewController
			vc.callBack = { (replyMessage) in
				self.makeAPICallForComment(isReplied: true, comment: replyMessage, parentID: (sender as! String))
			}
		}
    }
    
	func getParentAndChildComments(){
		if let comments = dataDict["comments"] as? [[String: Any]], comments.count > 0 {
			var totalCommentsArray = [[String: Any]]()
			for var parentDict in comments {
				if let tmpDict = parentDict["user"] as? [String: Any] {
					let fName = tmpDict["first_name"] as? String ?? ""
					let lName = tmpDict["last_name"] as? String ?? ""
					parentDict["commented_user_full_name"] = fName + " " + lName
					parentDict["profile_photo"] = tmpDict["profile_picture"] as? String ?? ""
				}
				
				totalCommentsArray.append(parentDict)
				if let tmpArray = parentDict["childComments"] as? [[String: Any]], tmpArray.count > 0{
					let childArray = tmpArray.map { (tempDict) -> [String : Any] in
						var dict1 = tempDict
						dict1["commentType"] = "Child"
						if let tmpDict = tempDict["user"] as? [String: Any] {
							let fName = tmpDict["first_name"] as? String ?? ""
							let lName = tmpDict["last_name"] as? String ?? ""
							dict1["commented_user_full_name"] = fName + " " + lName
							dict1["profile_photo"] = tmpDict["profile_picture"] as? String ?? ""
						}
						return dict1
					}
					totalCommentsArray.append(contentsOf: childArray)
				}
			}
			commentsArray = totalCommentsArray
			commentTableview.reloadData()
		}
    }
	
	func makeAPICallForComment(isReplied: Bool, comment: String, parentID: String? = "0") {
		ILUtility.showProgressIndicator(controller: self)
		let detailsDict = dataDict["details"] as? [String : Any] ?? [:]
		let typeOfPost = detailsDict["message_type"] as? String ?? ""
		let postID = dataDict["_id"] as? String ?? ""
		let commentRequestValues = ["comment" : comment, "parent_id" : parentID!, "obj_type" : typeOfPost, "obj_id" : postID ]  as [String:Any]
		
		SocialConnectAPI.sharedManaged.sendComments(requestDict: commentRequestValues, successResponse: {(response) in
			
			ILUtility.hideProgressIndicator(controller: self)
			self.commentTextView.text = ""
			if let dic = response as? [String: Any]{
				if isReplied {
					self.getTimelineDetails()
					return
				}
				if let Commentarray : [[String:Any]] = dic["data"] as? [[String : Any]] {
					self.dataDict["comments"] = Commentarray
					self.getParentAndChildComments()
				}
			}
		}, faliure: {(error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
	}
	
	@IBAction func sendCommentButton(_ sender: UIButton) {
		
		if (commentTextView.text!.count != 0) {
			makeAPICallForComment(isReplied: false, comment: commentTextView.text!)
		}
	}
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let commentListCell : CommentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentListTableViewCellId", for: indexPath) as! CommentListTableViewCell
		commentListCell.replyButton.tag = indexPath.row
		commentListCell.setupUI(dic: commentsArray[indexPath.row])
		commentListCell.delegate = self
		commentListCell.separatorInset = UIEdgeInsets(top: 0, left: commentListCell.bounds.size.width, bottom: 0, right: 0);
		return commentListCell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return commentsArray.count
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		
		let loggedInUserID = dataDict["logged_in_user_id"] as? String ?? ""
		if let selectedDict = commentsArray[indexPath.row] as? [String: Any] {
			if let tmpDict = selectedDict["user"] as? [String: Any] {
				let commentUserID = tmpDict["user_id"] as? String ?? ""
				if commentUserID == loggedInUserID {
					return true
				}
			}
		}
		return false
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
	  if editingStyle == .delete {
		ILUtility.showProgressIndicator(controller: self)
		let requestValues = ["comment_id" : commentsArray[indexPath.row]["_id"] as? String ?? ""]  as [String:Any]
		SocialConnectAPI.sharedManaged.deleteTimelinePostComment(requestDict: requestValues, successResponse: {(response) in
			
			ILUtility.hideProgressIndicator(controller: self)
			if let dic = response as? [String: Any]{
				if let Commentarray : [[String:Any]] = dic["data"] as? [[String : Any]] {
					self.dataDict["comments"] = Commentarray
					self.getParentAndChildComments()
				}
			}
		}, faliure: {(error) in
			ILUtility.hideProgressIndicator(controller: self)
		})
		
	  }
	}
}

extension CommentsViewController: CreateCommentDelegate{
	func clickonReplay(index: Int) {
//        let dict = commentsArray[index]
//        let id = dict["_id"] as? String ?? ""
//        self.performSegue(withIdentifier: "AddCommentReplyVCID", sender: id)
    }
}
