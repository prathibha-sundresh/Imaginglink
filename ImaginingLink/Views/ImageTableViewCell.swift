//
//  ImageTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import WebKit

@objc protocol FullSizeImageViewDelegate {
    func showFullImage(imagesUrls: [String],index: Int)
	@objc optional func getCurrentIndex(index: Int)
    @objc optional func updatePresentationDictForFavourite(dict: [String: Any])
}

class ImageTableViewCell: UITableViewCell,UIScrollViewDelegate {

    @IBOutlet weak var wkWebView: WKWebView!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var FavouriteButton: UIButton!
	@IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var ImaginingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var delegate : FullSizeImageViewDelegate?
    @IBOutlet weak var imageScrollView: UIScrollView!
    var images: [String] = []
    var currentPage: Int = 0
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var imagesView: UIView!
    var presentationDict = [String: Any]()
    var myViewcontroller: UIViewController?
    var editorModifiedCard: Bool = false
	
    func setupUI(dic: [String:Any]) {
		
		FavouriteButton.isHidden = editorModifiedCard
		settingButton.isHidden = editorModifiedCard
        presentationDict = dic
        imageScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 226)
        ImaginingLabel.layer.borderColor = UIColor(red:0.98, green:0.58, blue:0.00, alpha:1.0).cgColor
        ImaginingLabel.layer.cornerRadius = 10
        ImaginingLabel.layer.borderWidth = 1
        UserImageView.layer.cornerRadius = UserImageView.frame.height / 2
        UserImageView.clipsToBounds = true
        timeLabel.text = dic["created_at"] as? String ?? ""
        ImaginingLabel.text! = "  \(dic["section"] as? String ?? "")  "
        if let author : [String : Any] = dic["author"] as? [String:Any] {
            UsernameLabel.text! = author["name"] as! String
            if let photo : String = author["profile_photo"] as? String {
                UserImageView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            }
        }
        
		var imageURL: String?
		
		if let tmpDict = dic["presentation_master_url"] as? [String : Any]{
			imageURL = tmpDict["image"] as? String ?? ""
		}
		else {
			imageURL = dic["presentation_master_url"] as? String ?? ""
		}
        if let imageURL : String = imageURL {
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                wkWebView.isHidden = false
				wkWebView.navigationDelegate = self
                wkWebView.load(URLRequest(url: URL(string: imageURL)!))
				activityIndicatorView.startAnimating()
                imagesView.isHidden = true
            } else if let tmpPhotos = dic["presentation_jpg_files"] as? [[String: Any]] {
                let photos = tmpPhotos.map{ $0["image"] as? String ?? "" }
                wkWebView.isHidden = true
                images = photos
                addImagesToScroll(images: photos)
                imagesView.isHidden = false
            }
        }
		
        if let favourite = dic["is_my_favourite"] as? Int, favourite == 0{
            FavouriteButton.setBackgroundImage(UIImage(named: "Icon_unfavourite"), for: .normal)
        }
        else{
			FavouriteButton.setBackgroundImage(UIImage(named: "Icon_favourite"), for: .normal)
        }
    }
    
    @IBAction func favouriteUnFavouriteButtonPressed(_ sender: Any) {
        
        let presentationID = presentationDict["id"] as? String ?? ""
        ILUtility.showProgressIndicator(controller: myViewcontroller!)
        CoreAPI.sharedManaged.requestFavouriteUnfavorite(presentationID: presentationID, successResponse: {(response) in
            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
            if let favStatus = self.presentationDict["is_my_favourite"] as? Int, favStatus == 0{
                self.presentationDict["is_my_favourite"] = 1
				ILUtility.showAlert(title: self.presentationDict["title"] as? String ?? "Imaginglink",message: "Added to the favourite list", controller: self.myViewcontroller!)
            }
            else{
                self.presentationDict["is_my_favourite"] = 0
				ILUtility.showAlert(title: self.presentationDict["title"] as? String ?? "Imaginglink",message: "Removed from the favourite list", controller: self.myViewcontroller!)
            }
            self.delegate?.updatePresentationDictForFavourite?(dict: self.presentationDict)
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
        })
    }
    
    func addImagesToScroll(images: [String]){
        
        if images.count > 1{
            currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
            leftButton.isHidden = true
            rightButton.isHidden = false
        }
        else{
            currentPageLabel.isHidden = true
            leftButton.isHidden = true
            rightButton.isHidden = true
        }
        
        for (index,image) in images.enumerated(){
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * self.frame.width, y: 0.0, width: self.frame.width, height: 226))
            
            imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "ImagingLinkLogo"))
            imageScrollView.addSubview(imageView)
        }
        imageScrollView.contentSize = CGSize(width: CGFloat(images.count) * imageScrollView.frame.width, height: imageScrollView.frame.height)
        let x = CGFloat(currentPage) * CGFloat(imageScrollView.frame.width)
        
        imageScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: false)
        showHideLeftButton()
        showHideRightButton()
    }
    
    @IBAction func scrollLeft(_ sender: UIButton) {
        
        if currentPage != 0{
            currentPage = currentPage - 1
            currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
            var frame = imageScrollView.frame
            frame.origin.x = frame.size.width * CGFloat(currentPage)
            imageScrollView.scrollRectToVisible(frame, animated: true)
        }
        showHideLeftButton()
        showHideRightButton()
    }
    
    @IBAction func scrollRight(_ sender: UIButton) {
        
        if images.count - 1 > currentPage{
            var frame = imageScrollView.frame
            currentPage = currentPage + 1
            currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
            frame.origin.x = frame.size.width * CGFloat(currentPage)
            imageScrollView.scrollRectToVisible(frame, animated: true)
        }
        showHideLeftButton()
        showHideRightButton()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(imageScrollView.contentOffset.x / imageScrollView.frame.size.width)
        currentPageLabel.text = "\(currentPage + 1) of \(images.count)"
        showHideLeftButton()
        showHideRightButton()
    }
    func showHideLeftButton(){
        if currentPage > 0{
            leftButton.isHidden = false
        }
        else{
            leftButton.isHidden = true
        }
    }
    func showHideRightButton(){
        if images.count - 1 > currentPage{
            rightButton.isHidden = false
        }
        else{
            rightButton.isHidden = true
        }
    }
    @IBAction func showFullSizeImage(_ sender: UIButton){
        delegate?.showFullImage(imagesUrls: images,index: currentPage)
    }
    
}

extension ImageTableViewCell: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		activityIndicatorView.startAnimating()
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		activityIndicatorView.stopAnimating()
	}
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		activityIndicatorView.stopAnimating()
	}
}
