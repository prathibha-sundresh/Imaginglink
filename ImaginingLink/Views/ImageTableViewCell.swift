//
//  ImageTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/1/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol ImagePressDelegate {
    func showFullImage(imagesUrls: [String],index: Int)
    func updatePresentationDictForFavourite(dict: [String: Any])
}

class ImageTableViewCell: UITableViewCell,UIScrollViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var FavouriteButton: UIButton!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var ImaginingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var delegate : ImagePressDelegate?
    @IBOutlet weak var imageScrollView: UIScrollView!
    var images: [String] = []
    var currentPage: Int = 0
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var imagesView: UIView!
    var presentationDict = [String: Any]()
    var myViewcontroller: UIViewController?
    
    func setupUI(dic: [String:Any]) {
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
        
        if let imageURL : String = dic["presentation_master_url"] as? String {
            if ((dic["presentation_type"] as? String)?.contains("video"))! {
                webView.isHidden = false
                if (webView != nil){
                    webView.loadRequest(URLRequest(url: URL(string: imageURL)!))
                }
                imagesView.isHidden = true
            } else if let photos : [String] = dic["presentation_jpg_files"] as? [String] {
                webView.isHidden = true
                images = photos
                addImagesToScroll(images: photos)
                imagesView.isHidden = false
            }
        }
        if let favourite = dic["is_my_favourite"] as? Int, favourite == 0{
            FavouriteButton.setBackgroundImage(UIImage(named: "Icon_unfavourite"), for: .normal)
            FavouriteButton.setImage(nil, for: .normal)
        }
        else{
            FavouriteButton.setBackgroundImage(nil, for: .normal)
            FavouriteButton.setImage(UIImage(named: "Icon_favourite"), for: UIControlState.normal)
        }
    }
    
    @IBAction func favouriteUnFavouriteButtonPressed(_ sender: Any) {
        
        let presentationID = presentationDict["id"] as? String ?? ""
        ILUtility.showProgressIndicator(controller: myViewcontroller!)
        CoreAPI.sharedManaged.requestFavouriteUnfavorite(presentationID: presentationID, successResponse: {(response) in
            ILUtility.hideProgressIndicator(controller: self.myViewcontroller!)
            let data = response as! [String:Any]
            ILUtility.showAlert(title: self.presentationDict["title"] as? String ?? "Imaginglink",message: data["message"] as? String ?? "", controller: self.myViewcontroller!)
            if let favStatus = self.presentationDict["is_my_favourite"] as? Int, favStatus == 0{
                self.presentationDict["is_my_favourite"] = 1
            }
            else{
                self.presentationDict["is_my_favourite"] = 0
            }
            self.delegate?.updatePresentationDictForFavourite(dict: self.presentationDict)
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

