//
//  CommentTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

@objc protocol CommentDelegate {
    func sendCommentsToAPI(comments:String)
    func updatePresentationDict(dict: [String: Any])
    @objc optional func clickOnCommentButton(isSelected: Bool)
}

class CommentTableViewCell : UITableViewCell {
    
    @IBOutlet weak var CommentView: UIView!
    @IBOutlet weak var smileyView: UIView!
    @IBOutlet weak var smileyContainerView: UIView!
	@IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    var delegate : CommentDelegate?
    var presentationID: String = ""
    var myViewcontroller: UIViewController?
    var presentationDict: [String: Any] = [:]
    @IBAction func SendComment(_ sender: Any) {
        if (Textview.text!.count != 0) {
            delegate?.sendCommentsToAPI(comments: Textview.text!)
            Textview.text = ""
        }
    }
    @IBAction func ShareButtonPressed(_ sender: Any) {
        
        let title = presentationDict["title"] as? String ?? ""
		let shareUrl = URL(string: kBaseUrl + "presentations/public/\(presentationDict["id"] as? String ?? "")")
        //let pathStr = NSString(string: presentationDict["presentation_master_url"] as? String ?? "").deletingLastPathComponent
        //let myWebsite = URL(string:pathStr)
		//let myWebsite = URL(string:presentationDict["presentation_master_url"] as? String ?? "")
        let shareAll = [title, shareUrl!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = myViewcontroller?.view
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        myViewcontroller?.present(activityViewController, animated: false, completion: nil)
    }
    @IBAction func CommentButtonPressed(_ sender: Any) {
        
        self.delegate?.clickOnCommentButton?(isSelected: !commentButton.isSelected)
    }
    @IBOutlet weak var Textview: SZTextView!
    
    fileprivate func setUIValues(_ dic: [String : Any]) {
        presentationID = dic["id"] as? String ?? ""
        CommentView.layer.borderColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
        Textview.placeholder = "  Write your comment"
        Textview.placeholderTextColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1)
        Textview.textColor = UIColor.gray
        Textview.layer.borderColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
        Textview.layer.borderWidth = 1
        Textview.layer.cornerRadius = 16
		
		if let likedStatus = dic["like_emoji"] as? Int{
			
			let emojiName = LikeEmojies(rawValue: likedStatus)?.getEmojiString() ?? "Like_Unselected"
			
			likeButton.setImage(UIImage(named: "Icon_\(emojiName)"), for: UIControl.State.normal)
			likeButton.setTitle("  \(likedStatus == 0 ? "Like" : emojiName)", for: .normal)
        }
        else{
            likeButton.setImage(UIImage(named: "Icon_Like_Unselected"), for: UIControl.State.normal)
			likeButton.setTitle("Like", for: .normal)
        }
		
        likesCountLabel.text = "\(dic["likes_count"] as? Int ?? 0)"
        let totalComments = Int(dic["parent_comments_count"] as? Int ?? 0) + Int(dic["child_comments_count"] as? Int ?? 0)
        commentButton.setTitle(" \(totalComments) Comments", for: UIControl.State.normal)
        viewsButton.setTitle(" \(dic["views_count"] as? Int ?? 0) Views", for: UIControl.State.normal)
        //ShareButton.setTitle(" \(dic["shared_count"] as? Int ?? 0) Shared", for: UIControl.State.normal)
    }
    
    func setupUI(dic : [String:Any]) {
		addShadowToView()
        presentationDict = dic
        setUIValues(presentationDict)
    }
    @IBAction func ratingButton(_ sender: UIButton){
        ILUtility.showProgressIndicator(controller: myViewcontroller!)
        let rating = sender.tag - 100
//        CoreAPI.sharedManaged.requestAddRatingPost(presentationID: presentationID, rating: rating, successResponse: { (response) in
//            if let data = response["data"] as? [String:Any]{
//                self.presentationDict["likes_count"] = data["rated_members_count"] as? Int
//            }
//            self.delegate?.updatePresentationDict(dict: self.presentationDict)
//            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
//        }) { (error) in
//            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
//        }
        
        CoreAPI.sharedManaged.requestForSaveLikeEmoji(presentationID: presentationID, likeUnLikeValue: "\(rating)", successResponse: { (response) in
            if let data = response["data"] as? [String:Any]{
                self.presentationDict["likes_count"] = data["liked_members_count"] as? Int
				let emojiValue = ((data["like_emoji"] as? Int) != nil) ? data["like_emoji"] as? Int : Int(data["like_emoji"] as? String ?? "0")
				self.presentationDict["like_emoji"] = emojiValue
            }
			self.removeAnimate()
            self.delegate?.updatePresentationDict(dict: self.presentationDict)
            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
        }
    }
	@IBAction func likeActionPressed(_ sender: UIButton) {
		if !likeButton.isSelected{
			likeButton.isSelected = true
			showAnimate()
        }
        else{
            removeAnimate()
        }
    }
	func removeAnimate()
    {
		likeButton.isSelected = false
        self.smileyView.isHidden = true
        //self.delegate?.getLikedStatus(row: tag)
    }
	func addShadowToView() {
        
        smileyView.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        smileyView.layer.shadowOpacity = 0.4
        smileyView.layer.shadowOffset = CGSize.zero
        smileyView.layer.shadowRadius = 4.0
        smileyContainerView.layer.cornerRadius = 20
        smileyContainerView.layer.masksToBounds = true
        smileyView.isHidden = true
    }
    func showAnimate()
    {
		Textview.resignFirstResponder()
        smileyView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.smileyView.isHidden = true
        UIView.animate(withDuration: 0.25, animations: {
            self.smileyView.isHidden = false
            self.smileyView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        //self.delegate?.getLikedStatus(row: tag)
    }
}
extension CommentTableViewCell: UITextViewDelegate{
	func textViewDidBeginEditing(_ textView: UITextView) {
		removeAnimate()
	}
}
