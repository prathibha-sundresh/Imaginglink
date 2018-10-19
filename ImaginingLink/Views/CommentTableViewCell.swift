//
//  CommentTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import SZTextView

protocol CommentDelegate {
    func sendCommentsToAPI(comments:String)
    
}

class CommentTableViewCell : UITableViewCell {
    
    @IBOutlet weak var CommentView: UIView!
    @IBOutlet weak var ViewButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    var delegate : CommentDelegate?
    @IBAction func SendComment(_ sender: Any) {
        if (Textview.text!.count != 0) {
            delegate?.sendCommentsToAPI(comments: Textview.text!)
        }
    }
    @IBAction func ShareButtonPressed(_ sender: Any) {
    }
    @IBAction func ViewButtonPressed(_ sender: Any) {
    }
    @IBAction func CommentButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var Textview: SZTextView!
    
    func setupUI(dic : [String:Any]) {
        CommentView.layer.borderColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
        Textview.placeholder = "Write your comment"
        Textview.placeholderTextColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1)
        Textview.textColor = UIColor.gray
        Textview.layer.borderColor = UIColor(red: 187/255, green: 205/255, blue: 217/255, alpha: 1).cgColor
        Textview.layer.borderWidth = 1
        Textview.layer.cornerRadius = 10
        
        commentButton.setTitle(" \((dic["comments_count"] as! NSNumber).stringValue) Comments", for: UIControlState.normal)
           ViewButton.setTitle(" \((dic["views_count"] as! NSNumber).stringValue) Views", for: UIControlState.normal)
        
        ShareButton.setTitle(" \((dic["likes_count"] as! NSNumber).stringValue) Share", for: UIControlState.normal)
    }
}
