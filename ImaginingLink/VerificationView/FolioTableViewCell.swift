//
//  FolioTableViewCell.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 17/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class FolioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var folioName:UILabel!
    @IBOutlet weak var folioImage:UIImageView!
    @IBOutlet weak var followerCountText:UILabel!
    @IBOutlet weak var smileyView: UIView!
    @IBOutlet weak var smileyContainerView: UIView!
    @IBOutlet weak var LikeImageView: UIButton!
    @IBOutlet weak var FavouriteImage: UIButton!
    @IBOutlet weak var ShareActionPressed: UIButton!
    @IBOutlet weak var viewsAndCommentLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var ViewsLabel: UILabel!
    
    @IBAction func menuTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func followTapped(_ sender:UIButton) {
        
    }
    
    @IBAction func LikeActionPressed(_ sender: UIButton) {

       }
    
    @IBAction func ratingButton(_ sender: UIButton){

     }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        folioImage.image = UIImage(named: "No_presentations_found-Icon")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(dic:[String:Any]) {
        if let groupName = dic["group_name"] {
            folioName.text = groupName as? String
        }
        
        if let followersCount = dic["totla_followers_count"] {
            followerCountText.text = followersCount as? String
        }
        
        if let imageURL : String = dic["group_logo"] as? String {
            
            folioImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "ImagingLinkLogo"))
        }
        
    }

}
