//
//  PresentationTableViewCell.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 27/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit

//protocol PresentationDelegate {
//    //func followUnfollowWithPresentationId(id : String, successResponse:@escaping (_ response:String)-> Void)
//    //func notifyOrCancelWithPresentationId(id : String, successResponse:@escaping (_ response:String)-> Void)
//}

protocol PresentationTableViewCellDelegate {
    func getLikedStatus(row: Int)
    func updateRatingWithIndex(row: Int, rating: Int)
}
enum LikeEmojies: Int {
    case like = 1
    case love, insightful, celebrate, curious, dislike
    func getEmojiString() -> String {
        switch self {
        case .like:
            return "Like"
        case .love:
            return "Love"
        case .insightful:
            return "Insightful"
		case .celebrate:
            return "Celebrate"
		case .curious:
            return "Curious"
		case .dislike:
            return "Dislike"
        }
    }
}
class PresentationTableViewCell: UITableViewCell,UIWebViewDelegate {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var smileyView: UIView!
    @IBOutlet weak var smileyContainerView: UIView!
    @IBOutlet weak var LikeImageView: UIButton!
    @IBOutlet weak var FavouriteImage: UIButton!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var URLImageView: UIImageView!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var ImaginingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var HeadingTitleLabel: UILabel!
    weak var myVC : UIViewController?
    @IBOutlet weak var menuPressedButton: UIButton!
    var selectedLikes: [Int] = []
    @IBAction func MenuPressed(_ sender: Any) {
        
    }
    
    var delegate:PresentationTableViewCellDelegate?
    
    @IBAction func LikeActionPressed(_ sender: UIButton) {
        if selectedLikes.contains(sender.tag){
            removeAnimate(sender.tag)
        }
        else{
            showAnimate(sender.tag)
        }
    }
    @IBOutlet weak var ShareActionPressed: UIButton!
    @IBOutlet weak var viewsAndCommentLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var ViewsLabel: UILabel!
    
    var presentationId : String?
    
    func setupUI(dic:[String:Any]) {
        addShadowToView()
        borderView.layer.borderWidth = 1.0
        borderView.layer.cornerRadius = 4.0
		borderView.layer.borderColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha: 0.5).cgColor
        
        if let value = dic["id"] {
            presentationId = value as? String ?? ""
        }
        
        ImaginingLabel.layer.borderColor = UIColor(red:0.98, green:0.58, blue:0.00, alpha:1.0).cgColor
        ImaginingLabel.layer.cornerRadius = 10
        ImaginingLabel.layer.borderWidth = 1
        
        if let favourite = dic["is_my_favourite"] as? Int, favourite == 0{
            FavouriteImage.setImage(UIImage(named: "Icon_unfavourite"), for: UIControl.State.normal)
        }
        else{
            FavouriteImage.setImage(UIImage(named: "Icon_favourite"), for: UIControl.State.normal)
        }
        if let likedStatus = dic["like_emoji"] as? Int{
			
			let emojiName = LikeEmojies(rawValue: likedStatus)?.getEmojiString() ?? "Like_Unselected"
			
			LikeImageView.setImage(UIImage(named: "Icon_\(emojiName)"), for: UIControl.State.normal)
			LikeImageView.setTitle("  \(likedStatus == 0 ? "Like" : emojiName)", for: .normal)
        }
        else{
            LikeImageView.setImage(UIImage(named: "Icon_Like_Unselected"), for: UIControl.State.normal)
			LikeImageView.setTitle("  Like", for: .normal)
        }
        
        let views = "\((dic["views_count"] as? NSNumber ?? 0).stringValue)"
        let totalComments = dic["total_comments_count"] as? Int ?? 0
        viewsAndCommentLabel.text = "\(totalComments) Comments      \(views) Views"
        LikeLabel.text = "\((dic["likes_count"] as? NSNumber ?? 0).stringValue)"
		HeadingTitleLabel.text = (dic["title"] as? String ?? "").capitalized
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
                webview.isHidden = false
                
                let requestObj = URLRequest(url: url)
                webview.loadRequest(requestObj)
                if (URLImageView != nil) {
                    URLImageView.isHidden = true
                }
            } else {
                URLImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "ImagingLinkLogo"))
                webview.isHidden = true
                if (URLImageView != nil) {
                    URLImageView.isHidden = false
                }
            }
        }
    }
    
    func setUpProfileImage() {
        UserImageView.layer.borderWidth = 1.0
        UserImageView.layer.masksToBounds = false
        UserImageView.layer.borderColor = UIColor.white.cgColor
        UserImageView.layer.cornerRadius = UserImageView.frame.size.height / 2
        UserImageView.clipsToBounds = true
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
        print(LikeImageView.tag)
        delegate?.updateRatingWithIndex(row: LikeImageView.tag, rating: sender.tag - 100)
    }
}
