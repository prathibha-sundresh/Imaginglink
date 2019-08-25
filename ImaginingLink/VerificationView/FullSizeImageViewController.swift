//
//  FullSizeImageViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/26/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class FullSizeImageViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var fullImage: UIImageView!
    var urlStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImage.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: "ImagingLinkLogo"))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fullImageCloseButtonAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
