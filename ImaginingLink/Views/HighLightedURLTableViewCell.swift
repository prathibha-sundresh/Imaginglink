//
//  HighLightedURLTableViewCell.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 06/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol deleteHightLightURLProtocol {
    func deleteHightedUrl(indexRow:Int)
    func fetchTextFieldData(text: String, rowIndex: Int)
}

class HighLightedURLTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var deleteButton:UIButton!
    
    var delegate:deleteHightLightURLProtocol!
    
    @IBAction func deletePressed(_ sender:UIButton) {
        delegate.deleteHightedUrl(indexRow: sender.tag)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         delegate.fetchTextFieldData(text: textField.text ?? " ", rowIndex: textField.tag)
        return true
        
    }
    

}
