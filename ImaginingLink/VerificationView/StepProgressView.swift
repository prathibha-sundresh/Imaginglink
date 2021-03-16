//
//  StepProgressView.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 26/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

enum progressStep : Int{
    case FirstStep = 1
    case SecondStep = 2
    case ThirdStep = 3
}

class StepProgressView: UIView {
    


    var view: UIView!
    @IBOutlet weak var firstSelectedImage: UIImageView!
    @IBOutlet weak var secondSelectedImage: UIImageView!
    @IBOutlet weak var thirdSelectedImage: UIImageView!
    
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
      let nib = UINib(nibName: "StepProgressView", bundle: bundle)
      let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
      return view
  }
    
    func setProgressStep(stepsValue : Int) {
        switch stepsValue {
        case progressStep.FirstStep.rawValue:
            firstSelectedImage.image = UIImage(named: "Icon_progressStep_one_selected")
            secondSelectedImage.image = UIImage(named: "Icon_progressStep_two_unselected")
            thirdSelectedImage.image = UIImage(named: "Icon_progressStep_three_unselected")
        case progressStep.SecondStep.rawValue:
            firstSelectedImage.image = UIImage(named: "Icon_progressStep_one_selected")
            secondSelectedImage.image = UIImage(named: "Icon_progressStep_two_selected")
            thirdSelectedImage.image = UIImage(named: "Icon_progressStep_three_unselected")
        case progressStep.ThirdStep.rawValue:
            firstSelectedImage.image = UIImage(named: "Icon_progressStep_one_selected")
            secondSelectedImage.image = UIImage(named: "Icon_progressStep_two_selected")
            thirdSelectedImage.image = UIImage(named: "Icon_progressStep_three_selected")
        default: break
            
        }
    }

}
