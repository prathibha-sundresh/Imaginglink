//
//  CreateFolioButtonTableViewCell.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 12/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol callBackForCreateFolio {
    func CreateFolioPressed()
    func BackPressed()
}

class CreateFolioButtonTableViewCell: UITableViewCell {
    
    var delegate:callBackForCreateFolio!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func CreateFolioTapped(_ sender: UIButton) {
        self.delegate.CreateFolioPressed()
    }
    
    @IBAction func BackTapped(_ sender:UIButton) {
        self.delegate.BackPressed()
    }

}
