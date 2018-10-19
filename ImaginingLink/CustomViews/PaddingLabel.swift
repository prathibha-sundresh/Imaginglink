//
//  PaddingLabel.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 04/11/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
        self.sizeToFit()
        self.adjustsFontSizeToFitWidth = false
        self.textAlignment = NSTextAlignment.center

    }
}
