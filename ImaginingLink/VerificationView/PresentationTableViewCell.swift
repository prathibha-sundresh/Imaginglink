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

class PresentationTableViewCell: UITableViewCell,UIWebViewDelegate {
    
    @IBOutlet weak var borderView: UIView!
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
    @IBAction func MenuPressed(_ sender: Any) {
        
    }
    
   // var delegate:PresentationDelegate?
    
    @IBAction func LikeActionPressed(_ sender: Any) {
    }
    @IBOutlet weak var ShareActionPressed: UIButton!
    @IBOutlet weak var viewsAndCommentLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var ViewsLabel: UILabel!
    
    var presentationId : String?
    
    func setupUI(dic:[String:Any]) {
        
        borderView.layer.borderWidth = 1.0
        borderView.layer.cornerRadius = 4.0
        borderView.layer.borderColor = UIColor(red:0.89, green:0.92, blue:0.93, alpha:1.0).cgColor
        
        if let value = dic["id"] {
            presentationId = value as? String ?? ""
        }
        
        ImaginingLabel.layer.borderColor = UIColor(red:0.98, green:0.58, blue:0.00, alpha:1.0).cgColor
        ImaginingLabel.layer.cornerRadius = 10
        ImaginingLabel.layer.borderWidth = 1
        
        if let favourite = dic["is_my_favourite"] as? Int, favourite == 0{
            FavouriteImage.setImage(UIImage(named: "Icon_unfavourite"), for: UIControlState.normal)
        }
        else{
            FavouriteImage.setImage(UIImage(named: "Icon_favourite"), for: UIControlState.normal)
        }
        if let likedStatus = dic["Is_Liked"] as? Int, likedStatus == 1{
            LikeImageView.setImage(UIImage(named: "Icon_like"), for: UIControlState.normal)
        }
        else{
            LikeImageView.setImage(UIImage(named: "Icon_Like_Unselected"), for: UIControlState.normal)
        }
        
        let views = "\((dic["views_count"] as? NSNumber ?? 0).stringValue)"
        let comments = "\((dic["comments_count"] as? NSNumber ?? 0).stringValue)"
        viewsAndCommentLabel.text = "\(comments) Comments      \(views) Views"
        LikeLabel.text = "\((dic["likes_count"] as? NSNumber ?? 0).stringValue) Likes"
        HeadingTitleLabel.text = dic["title"] as? String ?? ""
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
}
