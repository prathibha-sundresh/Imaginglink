//
//  URLDisplayTableViewCellsTableViewCell.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 06/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol deleteURLProtocol {
    func deleteUrl(indexRow:Int)
     func fetchSocialURLTextFieldData(text: String, rowIndex: Int)
}

class URLDisplayTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var urlIcon:UIImageView!
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var deleteButton:UIButton!
    
    var delegate:deleteURLProtocol!
    
    @IBAction func deleteButtonPressed(_ sender:UIButton) {
        delegate.deleteUrl(indexRow: sender.tag)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func callIconImage(data:SocialMediaURLData) {
        urlIcon.image = UIImage(named: data.socialMediaIconName)
        textField.text = data.url
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          delegate.fetchSocialURLTextFieldData(text: textField.text ?? " ", rowIndex: textField.tag)
         return true
         
     }

}
