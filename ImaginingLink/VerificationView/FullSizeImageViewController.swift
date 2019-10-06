//
//  FullSizeImageViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/26/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class FullSizeImageViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scorllView: UIScrollView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    var urlStr = ""
    var imagesUrls = [String]()
    var imagesDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addImagesToScrollView()
        // Do any additional setup after loading the view.
    }
    func addImagesToScrollView(){
        imagesUrls = imagesDict["images"] as? [String] ?? []
        for (index,image) in imagesUrls.enumerated(){
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * self.view.frame.width, y: 30.0, width: self.view.frame.width, height: self.view.frame.height - 60.0))
            
            imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            imageView.contentMode = .scaleAspectFit
            scorllView.addSubview(imageView)
        }
        contentViewWidth.constant = CGFloat(imagesUrls.count) * self.view.frame.width
        scorllView.isPagingEnabled = true
        statusLabel.text = "\(imagesDict["index"] as! Int + 1) of \(imagesUrls.count)"
        let x = CGFloat(imagesDict["index"] as! Int) * CGFloat(self.view.frame.width)
        scorllView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    @IBAction func fullImageCloseButtonAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scorllView.contentOffset.x / scorllView.frame.size.width)
        statusLabel.text = "\(currentPage + 1) of \(imagesUrls.count)"
    }
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return contentView
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
