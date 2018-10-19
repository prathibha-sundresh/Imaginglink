//
//  CommentListTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol CreateCommentDelegate {
    func clickonReplay(ParentId: String)
    
    
}

class CommentListTableViewCell : UITableViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    var delegate:CreateCommentDelegate?
    
    @IBAction func ReplayButtonPressed(_ sender: Any) {
        delegate?.clickonReplay(ParentId: "")
        
    }
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    
    func setupUI(dic: [String:Any]) {
        
        if let comment = dic["comment"] as? String {
            DescriptionLabel?.text = comment
        }
        
        if let createdAt = dic["created_at"] as? String {
            TimeLabel?.text = createdAt
        }
        
        if let Name = dic["commented_user_full_name"] as? String {
            NameLabel?.text = Name
        }
        
        if let profilePhoto = dic["profile_photo"] as? String {
             ImageView?.sd_setImage(with: URL(string: profilePhoto), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            setUpProfileImage()
        }
    }
    
    func setUpProfileImage() {
        ImageView.layer.borderWidth = 1.0
        ImageView.layer.masksToBounds = false
        ImageView.layer.borderColor = UIColor.white.cgColor
        ImageView.layer.cornerRadius = ImageView.frame.size.width / 2
        ImageView.clipsToBounds = true
    }
}
