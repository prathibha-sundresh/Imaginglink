//
//  DropDownWithLabelView.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 01/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol fetchLabelOnButtonClickProtocol {
    func fetchLabel(labelValue:String)
}

class DropDownWithLabelView: UIView, UserTypeDelegate{
    
    var view: UIView!
    @IBOutlet weak var dropDownLabel: UILabel!
    var delegate:fetchLabelOnButtonClickProtocol!
    var listToDisplay:[String] = ["+91", "+123", "+98", "+91", "+123", "+98"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetup()
    }
    
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DropDownWithLabelView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func dropDownPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = listToDisplay
        VC.filteredArray = listToDisplay
        VC.selectedIndexValue = dropDownLabel.text!
        self.addSubview(VC.view)
//        self.delegate.fetchLabel(labelValue: dropDownLabel.text!)
    }
    
    func selectedUserType(userType: String, indexRow: Int) {
        dropDownLabel.text! = userType
      }
    
    
}
