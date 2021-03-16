//
//  HIghtlightesHeaderView.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 07/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol AddMoreRowsDelegates {
    func AddFieldForHightLightURL()
    func AddMoreForURL()
}

class HIghtlightesHeaderView: UITableViewHeaderFooterView {

    var headerString : UILabel!
    var addMoreButton :UIButton!
    var addMoreDelegate : AddMoreRowsDelegates?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func callHeaderView(WithSection : Int) {
        headerString = UILabel(frame: CGRect.zero)
        headerString!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerString!)
        
        //constraints
        self.addConstraint(NSLayoutConstraint(item: headerString!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: headerString!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: headerString!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -8))
        self.addConstraint(NSLayoutConstraint(item: headerString!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8))
        
        //title
        headerString.text = (WithSection == 0 ? kHighlighedURLHEader : kURlHeader)
        headerString.font = (WithSection == 0 ? UIFont(name: "GoogleSans-Regular", size: 12) : UIFont(name: "GoogleSans-Medium", size: 14))
        headerString.numberOfLines = 0
        headerString.textColor = UIColor(red: 74/256, green: 74/256, blue: 74/256, alpha: 1)
        headerString.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
    }
    
    func callFooterView(withSection:Int) {
        addMoreButton = UIButton(type: UIButton.ButtonType.custom)
        addMoreButton.layer.cornerRadius = (withSection == 0 ? 20 : 5)
        addMoreButton.tag = withSection
        addMoreButton.addTarget(self, action: #selector(pressAddMore), for: UIControl.Event.touchUpInside)
        addMoreButton!.backgroundColor = (withSection == 0 ? UIColor(red: 250/250, green: 100/250, blue: 24/250, alpha: 1) : UIColor(red: 249/250, green: 148/250, blue: 0/250, alpha: 1))
        addMoreButton.setTitle((withSection == 0 ? "Add field" : "Add more"), for: UIControl.State.normal)
        addMoreButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        addMoreButton.titleLabel?.font = UIFont(name: "GoogleSans-Medium", size: 14)
        addMoreButton!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addMoreButton!)
        
        //constraints
        self.addConstraint(NSLayoutConstraint(item: addMoreButton!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 12))
        self.addConstraint(NSLayoutConstraint(item: addMoreButton!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12))
        self.addConstraint(NSLayoutConstraint(item: addMoreButton!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -12))
        self.addConstraint(NSLayoutConstraint(item: addMoreButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 140))
    }
    
    @objc func pressAddMore() {
        
        if addMoreButton.tag == SectionNumber.FirstSection.rawValue {
            addMoreDelegate?.AddFieldForHightLightURL()
        } else if addMoreButton.tag == SectionNumber.SecondSection.rawValue {
            addMoreDelegate?.AddMoreForURL()
        }
        
    }
    
    
}
