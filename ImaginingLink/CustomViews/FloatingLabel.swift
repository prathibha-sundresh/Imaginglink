//
//  FloatingLabel.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 27/03/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class FloatingLabel: SkyFloatingLabelTextField {

    func setUpLabel(WithText : String) {
        
        let color : UIColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
        let lightGrey : UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        self.placeholder = WithText
        self.selectedLineColor = color
        self.selectedTitleColor = color
        self.errorColor = color
        self.lineColor = lightGrey
        self.titleFont = UIFont(name: "GoogleSans-Regular", size: 12)!
        self.font = UIFont(name: "GoogleSans-Regular", size: 16)!
        self.titleColor = lightGrey
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
}
