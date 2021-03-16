//
//  FolioTableViewCell.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 17/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class FolioListTableViewCell: UITableViewCell {
	var delegate: SharedStatusTableViewCellDelegate?
    @IBOutlet weak var folioName:UILabel!
    @IBOutlet weak var folioImage:UIImageView!
    @IBOutlet weak var followerCountText:UILabel!
	@IBOutlet weak var menuButton: UIButton!
	@IBOutlet weak var borderView : UIView!
	@IBOutlet weak var noOfCommentsLabel: UILabel!
	@IBOutlet weak var noOfLikesLabel: UILabel!
	@IBOutlet weak var smileyView : UIView!
	@IBOutlet weak var smileyContainerView : UIView!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var ShareButton: UIButton!
	@IBOutlet weak var commentButton: UIButton!
	@IBOutlet weak var followUnFollowButton: UIButton!
	var selectedLikes: [Int] = []
	
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
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(dic:[String:Any]) {
		addShadowToView()
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		folioName.text = (dic["group_name"] as? String ?? "").capitalized
		followerCountText.text = "\(dic["totla_followers_count"] as? Int ?? 0)+ Followers"
		noOfCommentsLabel.text = "\(dic["toatal_post_counts"] as? Int ?? 0) Posts"
		noOfLikesLabel.text = "\(dic["totla_likes_count"] as? Int ?? 0)"
        if let imageURL : String = dic["group_logo"] as? String {
            folioImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "ImagingLinkLogo"))
        }
		if let isFollowing = dic["is_following"] as? String, isFollowing == "Yes" {
			followUnFollowButton.backgroundColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.00)
			followUnFollowButton.setTitle("UnFollow", for: .normal)
		}
		else {
			followUnFollowButton.backgroundColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00)
			followUnFollowButton.setTitle("Follow", for: .normal)
		}
		if let likedStatus = dic["like_emoji"] as? Int{
			
			let emojiName = LikeEmojies(rawValue: likedStatus)?.getEmojiString() ?? "Like_Unselected"
			likeButton.setImage(UIImage(named: "Icon_\(emojiName)"), for: UIControl.State.normal)
			likeButton.setTitle("\(likedStatus == 0 ? "Like" : emojiName)", for: .normal)
		}
		else{
			likeButton.setImage(UIImage(named: "Icon_Like_Unselected"), for: UIControl.State.normal)
			likeButton.setTitle("Like", for: .normal)
		}
		
		if let isFavourite = dic["is_favourite"] as? String, isFavourite == "No" {
			commentButton.setImage(UIImage(named: "Icon_unfavourite"), for: UIControl.State.normal)
		}
		else{
			commentButton.setImage(UIImage(named: "Icon_favourite"), for: UIControl.State.normal)
		}
    }
}
