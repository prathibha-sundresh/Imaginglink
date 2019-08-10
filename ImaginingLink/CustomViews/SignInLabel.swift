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
            .font: UIFont(name: "SFProDisplay-Light", size: 14)!,
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
            .kern: 0.5
            ])
        let str = NSString(string: "Already A Member  LOGIN")
        attributedString.addAttributes([
            .font: UIFont(name: "SFProDisplay-Semibold", size: 14)!,
            .foregroundColor: UIColor(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
            ], range: str.range(of: "LOGIN"))
        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapOnLabel(gesture:)))
        self.addGestureRecognizer(tapGesture)
        
    }
    @objc func TapOnLabel(gesture:UITapGestureRecognizer) -> Void {
        tapDelegate?.tapForSignIn()
    }
    
    func changeTextForSignInLabel() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "Back to  Login", attributes: [
            .font: UIFont(name: "SFProDisplay-Light", size: 14)!,
            .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
            .kern: 0.5
            ])
        let str = NSString(string: "Back to  Login")
        attributedString.addAttributes([
            .font: UIFont(name: "SFProDisplay-Semibold", size: 14)!,
            .foregroundColor: UIColor(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
            ], range: str.range(of: "Login"))
        return attributedString
    }
}
