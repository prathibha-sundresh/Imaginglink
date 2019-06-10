//
//  DashBoardCollectionViewCell.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 24/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class DashBoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var CellImageView: UIImageView!
    @IBOutlet weak var CellLabel: UILabel!
    @IBOutlet weak var ContentView: UIView!
    
    
    func ToDisplayContent(imageName:String, title:String) {
        
        self.ContentView.layer.cornerRadius = 5
        CellImageView.image = UIImage(named: imageName)
        CellLabel.text = title
        
    }
}
