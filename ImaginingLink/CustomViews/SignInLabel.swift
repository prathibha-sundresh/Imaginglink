//
//  SignInLabel.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 25/09/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol TapOnLabelDelegate {
    func tapForSignIn()
}

class SignInLabel: UILabel {
    var tapDelegate : TapOnLabelDelegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        let attributedString = NSMutableAttributedString(string: "Already A Member  LOGIN", attributes: [
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
            .kern: 0.5
            ])
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: UIColor(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 18, length: 5))
        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapOnLabel(gesture:)))
        self.addGestureRecognizer(tapGesture)
        
    }
    @objc func TapOnLabel(gesture:UITapGestureRecognizer) -> Void {
        tapDelegate?.tapForSignIn()
    }
    
    
       
    
   
    
    
    
}
