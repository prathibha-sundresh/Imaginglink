//
//  PresentationTableViewCell.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 27/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class PresentationTableViewCell: UITableViewCell {
    //
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var ImaginingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var HeadingTitleLabel: UILabel!
    
    @IBAction func MenuPressed(_ sender: Any) {
    }
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var ViewsLabel: UILabel!
}
