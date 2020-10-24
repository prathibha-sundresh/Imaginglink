//
//  CreateView.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 09/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class CreateFolioView: UIView {
    
    var view: UIView!
    @IBOutlet weak var createFolioButton: UIButton!
     var delegate : createFolioDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.xibSetup()
        setupButtonUI()
    }
    
   
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CreateFolioView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    @IBAction func createFolioTapped(_ sender: UIButton) {
        self.delegate.createFolioPressed()
    }
    
    func setupButtonUI() {
        createFolioButton.layer.cornerRadius = 20
        createFolioButton.contentHorizontalAlignment = .left
        if createFolioButton.imageView != nil {
            createFolioButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: (createFolioButton.frame.size.width + (createFolioButton.imageView?.frame.width)! + 20), bottom: 5, right: 0)
            createFolioButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
    }
    
}



