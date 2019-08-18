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
    @IBOutlet weak var univercityValueLabel: UILabel!
    @IBOutlet weak var PrimaryAuthorValueLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var SampleKeywordLabel: UILabel!
    @IBOutlet weak var SubSectionLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var DescriptionTitleLabel: UILabel!
    @IBOutlet weak var univercityLabel: UILabel!
    @IBOutlet weak var coAuthorsLabel: UILabel!
    @IBOutlet weak var coAuthorsValueLabel: UILabel!
    
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
        if let coAuthors = dic["co_authors"] as? [[String: Any]], coAuthors.count > 0
        {
            var str = coAuthors.reduce("") { (result, dict) -> String in
                return result + "\(dict["name"] as? String ?? "")" + ","
            }
            if str[str.index(before: str.endIndex)] == ","{
                str.removeLast()
            }
            coAuthorsValueLabel.text = str
        }
        else{
            coAuthorsLabel.text = ""
            coAuthorsValueLabel.text = ""
        }
        if let keywords = dic["keywords"] as? [String]
        {
            SampleKeywordLabel?.text = keywords[0]
        }
        
        if let isDownloadable = dic["is_downloadable"] as? Int
        {
            if isDownloadable == 1{
                AllowToDownloadLabel?.text = "Yes"
            }
            else{
                AllowToDownloadLabel?.text = "No"
            }
        }
        
        if let title = dic["title"] as? String
        {
            DescriptionTitleLabel?.text = title
        }
        
        if let author : [String : Any] = dic["author"] as? [String:Any] {
            PrimaryAuthorValueLabel?.text = author["name"] as? String
            if let university = author["university"] as? String {
                univercityValueLabel?.text = university
            } else {
                univercityValueLabel?.text = ""
                univercityLabel?.text = ""
            }
        }
     }
}
