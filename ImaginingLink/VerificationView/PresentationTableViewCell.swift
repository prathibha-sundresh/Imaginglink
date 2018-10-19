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

protocol PresentationDelegate {
    func favouritesUnFavouritesWithPresentationId(id : String, successResponse:@escaping (_ response:String)-> Void)
    func followUnfollowWithPresentationId(id : String, successResponse:@escaping (_ response:String)-> Void)
    func notifyOrCancelWithPresentationId(id : String, successResponse:@escaping (_ response:String)-> Void)
}

class PresentationTableViewCell: UITableViewCell {
    //
    @IBOutlet weak var LikeImageView: UIButton!
    @IBOutlet weak var FavouriteImage: UIButton!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var URLImageView: UIImageView!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UsernameLabel: UILabel!
     @IBOutlet weak var ImaginingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var HeadingTitleLabel: UILabel!
    weak var myVC : UIViewController?
    @IBAction func MenuPressed(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Follow and Unfollow", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            self.delegate?.followUnfollowWithPresentationId(id: self.presentationId!, successResponse: {(response) in
                
            })
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Turn on and Turn off notification", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            self.delegate?.notifyOrCancelWithPresentationId(id: self.presentationId!, successResponse: {(response) in
                
            })
        }))
        actionsheet.addAction(UIAlertAction(title: "Give feedback on this post", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        }))
        myVC?.present(actionsheet, animated: true, completion: nil)
        
    }
    
    var delegate:PresentationDelegate?
    
    @IBAction func FavouriteActionPressed(_ sender: Any) {
        delegate?.favouritesUnFavouritesWithPresentationId(id: presentationId!,successResponse: {(response) in
            if (response == "Made unfavourite successfully") {
                self.FavouriteImage.setImage(UIImage(named: "Icon_unfavourite"), for: UIControlState.normal)
            } else {
                 self.FavouriteImage.setImage(UIImage(named: "Icon_favourite"), for: UIControlState.normal)
            }
        })
       
    }
    @IBAction func LikeActionPressed(_ sender: Any) {
    }
    @IBOutlet weak var ShareActionPressed: UIButton!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var ViewsLabel: UILabel!
    
    var presentationId : String?
    
    func setupUI(dic:[String:Any]) {
       if let value = dic["id"] {
        presentationId = value as! String
        }
        ImaginingLabel.textAlignment = .center
        ImaginingLabel.layer.borderColor = UIColor.orange.cgColor
        ImaginingLabel.layer.cornerRadius = 5
        ImaginingLabel.frame.size.width = ImaginingLabel.intrinsicContentSize.width + 30
        ImaginingLabel.frame.size.height = ImaginingLabel.intrinsicContentSize.height + 30
        ImaginingLabel.layer.borderWidth = 1
        HeadingTitleLabel.sizeToFit()
        HeadingTitleLabel.textAlignment = .left
        
        let favourite = dic["is_my_favourite"] as! NSNumber
        if (favourite.intValue == 0) {
            FavouriteImage.setImage(UIImage(named: "Icon_unfavourite"), for: UIControlState.normal)
        } else {
            FavouriteImage.setImage(UIImage(named: "Icon_favourite"), for: UIControlState.normal)
        }
            ViewsLabel.text! = "\((dic["views_count"] as! NSNumber).stringValue) Views"
            LikeLabel.text! = "\((dic["likes_count"] as! NSNumber).stringValue) Likes"
            CommentLabel.text! = "\((dic["comments_count"] as! NSNumber).stringValue) Comments"
            HeadingTitleLabel.text! = dic["title"] as! String
            timeLabel.text! = dic["created_at"] as! String
            ImaginingLabel.text! = dic["section"] as! String
            if let author : [String : Any] = dic["author"] as? [String:Any] {
                UsernameLabel.text! = author["name"] as! String
                if let photo : String = author["profile_photo"] as? String {
                    UserImageView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "ImagingLinkLogo"))
                }
            }
        if let imageURL : String = dic["presentation_master_url"] as? String {
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                print("imageURL \(imageURL)")
                let url : URL = URL(string: imageURL)!
                print("url \(url)")
                webview.isHidden = false
                webview.stopLoading()
                if (webview != nil){
//                    webview.load(URLRequest(url: url))
                }
                
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
        UserImageView.layer.cornerRadius = UserImageView.frame.size.width / 2
        UserImageView.clipsToBounds = true
    }
}
