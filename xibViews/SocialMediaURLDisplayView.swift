//
//  SocialMediaURLDisplayView.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 08/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol socialMediaDataDelegate {
    func getSocialMediaData(withData:SocialMediaURLData)
}

class SocialMediaURLDisplayView: UIView {

      var view: UIView!
    var delegate :socialMediaDataDelegate!
      
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
        let nib = UINib(nibName: "SocialMediaURLDisplayView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
   @IBAction func youTubeTapped(_ sender:UIButton) {
    delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.youtube.com", socialMediaIconName: "icon_youtube"))
    }
    
   @IBAction func vimeoTapped(_ sender:UIButton) {
         delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.vimeo.com", socialMediaIconName: "Icon_Vimeo"))
    }
    
   @IBAction func redditTapped(_ sender:UIButton) {
         delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.reddit.com", socialMediaIconName: "Icon_reddit"))
    }
    
   @IBAction func pinterestTapped(_ sender:UIButton) {
         delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.pinterest.com", socialMediaIconName: "Icon_Pinterset"))
    }
    
   @IBAction func googlePlusTapped(_ sender:UIButton) {
         delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.googleplus.com", socialMediaIconName: "Icon_googlePlus"))
    }
    
   @IBAction func tumblrTapped(_ sender:UIButton) {
         delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.tumblr.com", socialMediaIconName: "Icon_tumblr"))
    }
    
   @IBAction func bloggerTapped(_ sender:UIButton) {
            delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.blogger.com", socialMediaIconName: "icon_blogger"))
    }
    
    @IBAction func flickrTapped(_ sender:UIButton) {
            delegate.getSocialMediaData(withData: SocialMediaURLData(url: "www.flickr.com", socialMediaIconName: "icon_flickr"))
    }

}
