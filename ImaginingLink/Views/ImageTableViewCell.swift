//
//  ImageTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol ImagePressDelegate {
    func downloadFileOnLongPress(File:String)
}

class ImageTableViewCell: UITableViewCell {
    //
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var Imageview: UIImageView!
    var downloadableLink : String?
    
    var delegate : ImagePressDelegate?
    
    func setLongPresstoFile() {
//        let longpress = UITapGestureRecognizer(target: self, action:#selector(toDownloadFile(gestureRecognizer:)))
//        longpress.numberOfTapsRequired = 1
//        longpress.numberOfTouchesRequired = 1
//        Imageview.addGestureRecognizer(longpress)
    }
    
//    @objc func toDownloadFile(gestureRecognizer: UITapGestureRecognizer) {
//        delegate?.downloadFileOnLongPress(File: downloadableLink!)
//    }
    
    func setupUI(dic: [String:Any]) {
        
        if let isDownloadable = dic["is_downloadable"] as? Int
        {
            if (isDownloadable == 1)
            {
                if let downloadLink = dic["downloadable_file_link"] as? String {
                    downloadableLink = downloadLink
                    delegate?.downloadFileOnLongPress(File: downloadableLink!)
                }
                
            }
        }
        
        if let imageURL : String = dic["presentation_master_url"] as? String {
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                webView.isHidden = false
                if (webView != nil){
                    webView.loadRequest(URLRequest(url: URL(string: imageURL)!))
                }
                
                if (Imageview != nil) {
                    Imageview.isHidden = true
                }
            } else if let photo : [String] = dic["presentation_jpg_files"] as? [String] {
                 let url : String = photo[0]
                Imageview?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ImagingLinkLogo"))
                webView.isHidden = true
                if (Imageview != nil) {
                    Imageview.isHidden = false
                }
            }
        
//        if let photo : [String] = dic["presentation_jpg_files"] as? [String] {
//            let url : String = photo[0]
//            let image : UIImage = UIImage(named: "ImagingLinkLogo")!
//            Imageview?.sd_setImage(with: URL(string: url), placeholderImage: image)
//        }
    }
    }
}
