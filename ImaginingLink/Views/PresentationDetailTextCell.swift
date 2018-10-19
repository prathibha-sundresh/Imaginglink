//
//  PresentationDetailTextCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class PresentationDetailTextCell : UITableViewCell {
    
    @IBOutlet weak var AllowToDownloadLabel: UILabel!
    @IBOutlet weak var univercityLabel: UILabel!
    @IBOutlet weak var PrimaryAuthorValueLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var SampleKeywordLabel: UILabel!
    @IBOutlet weak var SubSectionLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var DescriptionTitleLabel: UILabel!
    

    
    func setupValue(dic: [String:Any]) {
        
        if let description = dic["description"] as? String
        {
            DescriptionLabel?.text = "\(description)"
            DescriptionLabel.numberOfLines = 0
        }
        
        if let section = dic["section"] as? String
        {
            sectionLabel?.text = section
        }
        if let keywords = dic["sub_sections"] as? [String]
        {
            SubSectionLabel?.text = keywords[0]
        }
        
        
        if let keywords = dic["keywords"] as? [String]
        {
            SampleKeywordLabel?.text = keywords[0]
        }
        
        if let isDownloadable = dic["is_downloadable"] as? Int
        {
            AllowToDownloadLabel?.text = "\(isDownloadable)"
        }
        
        if let title = dic["title"] as? String
        {
            DescriptionTitleLabel?.text = title
        }
        
        if let author : [String : Any] = dic["author"] as? [String:Any] {
            PrimaryAuthorValueLabel?.text = author["name"] as? String
            if let university = author["university"] as? String {
                univercityLabel?.text = university
            } else {
                univercityLabel?.text = "Null"
            }
        }
     }
}
