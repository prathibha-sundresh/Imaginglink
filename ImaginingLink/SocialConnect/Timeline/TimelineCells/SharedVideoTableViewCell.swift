//
//  SharedVideoTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 5/31/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import WebKit

class SharedVideoTableViewCell: UITableViewCell {
	var delegate: SharedStatusTableViewCellDelegate?
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var menuButton: UIButton!
	@IBOutlet weak var webview: WKWebView!
	@IBOutlet weak var borderView : UIView!
	@IBOutlet weak var noOfCommentsLabel: UILabel!
	@IBOutlet weak var noOfLikesLabel: UILabel!
	@IBOutlet weak var smileyView : UIView!
	@IBOutlet weak var smileyContainerView : UIView!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var ShareButton: UIButton!
	@IBOutlet weak var commentButton: UIButton!
	var selectedLikes: [Int] = []
	func setUI(dict: [String: Any]) {
		setUpProfileImage()
		borderView.layer.borderWidth = 1.0
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		borderView.layer.cornerRadius = 4.0
		borderView.clipsToBounds = true
		addShadowToView()
		if let likedStatus = dict["like_emoji"] as? Int{
			
			let emojiName = LikeEmojies(rawValue: likedStatus)?.getEmojiString() ?? "Like_Unselected"
			
			likeButton.setImage(UIImage(named: "Icon_\(emojiName)"), for: UIControl.State.normal)
			likeButton.setTitle("\(likedStatus == 0 ? "Like" : emojiName)", for: .normal)
        }
        else{
            likeButton.setImage(UIImage(named: "Icon_Like_Unselected"), for: UIControl.State.normal)
			likeButton.setTitle("Like", for: .normal)
        }
		
		let detailsDict = dict["details"] as? [String : Any] ?? [:]
		if let videosUrls = detailsDict["attachments"] as? [String], videosUrls.count > 0 {
			webview.load(URLRequest(url: URL(string: videosUrls[0])!))
		}
		else{
			webview.load(URLRequest(url: URL(string: detailsDict["attachments"] as? String ?? "")!))
		}
		if let userDetails = dict["user_details"] as? [String: Any] {
			let image = userDetails["profile_picture"] as? String ?? ""
			profileImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
			let firstName = userDetails["first_name"] as? String ?? ""
			let lastName = userDetails["last_name"] as? String ?? ""
			let fullname = firstName + " " + lastName
			
			let strTnC = NSString(string: "\(fullname) shared a Album")
			let attributedString = NSMutableAttributedString(string: strTnC as String)
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: fullname))
			attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00), range: strTnC.range(of: "Album"))
			nameLabel.attributedText = attributedString
		}
		noOfLikesLabel.text = "\(dict["liked_members_count"] as? Int ?? 0)"
		noOfCommentsLabel.text = "\(dict["total_comments_count"] as? Int ?? 0) Comments"
		timeLabel.text = dict["created_at"] as? String ?? ""
	}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func LikeActionPressed(_ sender: UIButton) {
		
		if selectedLikes.contains(sender.tag){
            removeAnimate(sender.tag)
        }
        else{
            showAnimate(sender.tag)
        }
    }
	
	func addShadowToView() {
        
        smileyView.layer.shadowColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        smileyView.layer.shadowOpacity = 0.4
        smileyView.layer.shadowOffset = CGSize.zero
        smileyView.layer.shadowRadius = 4.0
        smileyContainerView.layer.cornerRadius = 20
        smileyContainerView.layer.masksToBounds = true
		smileyView.isHidden = selectedLikes.contains(likeButton.tag) ? false : true
    }
	
	func showAnimate(_ tag: Int)
    {
        smileyView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.smileyView.isHidden = true
        UIView.animate(withDuration: 0.25, animations: {
            self.smileyView.isHidden = false
            self.smileyView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
		self.delegate?.getLikedStatus(row: tag)
    }
    
    func removeAnimate(_ tag: Int)
    {
        self.smileyView.isHidden = true
		self.delegate?.getLikedStatus(row: tag)
    }
	
	@IBAction func ratingButton(_ sender: UIButton){
        delegate?.updateRatingWithIndex(row: likeButton.tag, rating: sender.tag - 100)
    }
	
	func setUpProfileImage() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
    }
}
