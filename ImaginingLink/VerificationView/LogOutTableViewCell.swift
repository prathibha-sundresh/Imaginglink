//
//  LogOutTableViewCell.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 30/10/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class LogOutTableViewCell: UITableViewCell {
    @IBOutlet weak var LogOutLabel: UILabel!
    
    func setupUI() {
        LogOutLabel.layer.borderColor = UIColor.red.cgColor
        LogOutLabel.layer.borderWidth = 1
        LogOutLabel.layer.cornerRadius = 5
    }
    //
}
