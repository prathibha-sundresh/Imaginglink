//
//  PresentationView.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 27/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit


class PresentationViewController: BaseHamburgerViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PresenationTableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let tableviewcell = tableView.dequeueReusableCell(withIdentifier: "PresentationTableViewCell", for: indexPath) as! PresentationTableViewCell
        tableviewcell.myVC = self
        tableviewcell.setUpProfileImage()
        
        tableviewcell.setupUI(dic: dataArray[indexPath.row])
        tableviewcell.LikeImageView.tag = indexPath.row
        tableviewcell.FavouriteImage.tag = indexPath.row
        tableviewcell.ShareActionPressed.tag = indexPath.row
        tableviewcell.menuPressedButton.tag = indexPath.row
        //tableviewcell.LikeImageView.addTarget(self, action: #selector(likeUnLikeAction), for: .touchUpInside)
        tableviewcell.FavouriteImage.addTarget(self, action: #selector(favouritesUnFavouritesToPresentation), for: .touchUpInside)
        tableviewcell.ShareActionPressed.addTarget(self, action: #selector(sharePresentation), for: .touchUpInside)
        tableviewcell.menuPressedButton.addTarget(self, action: #selector(menuPressedButtonAction), for: .touchUpInside)
        tableviewcell.delegate = self
        tableviewcell.selectedLikes = likesArray
        if likesArray.contains(indexPath.row){
            tableviewcell.smileyView.isHidden = false
        }
        else{
            tableviewcell.smileyView.isHidden = true
        }
        return tableviewcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ID = dataArray[indexPath.row]
        let value = ID["id"] as! String
        self.performSegue(withIdentifier: "PresentationDetail", sender: value)
    }
    
    var dataArray : [[String:Any]] = []
    var isFromPresentations: Bool = false
    var likesArray : [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        PresenationTableView.tableFooterView = footerView
        if isFromPresentations {
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Presentations")
        }
        else{
            addSlideMenuButton(showBackButton: true, backbuttonTitle: "Saved post")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromPresentations{
            getPublicPresentations()
        }
        else{
            getSavedPresentations()
        }
        
    }
    fileprivate func getPublicPresentations() {
        
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.callPublicPresentation(successResponse: { (response) in
            ILUtility.hideProgressIndicator(controller: self)
            let value = response as! String
            let dic : [String : Any] = value.convertToDictionary()!
            let array : [[String:Any]] = dic["data"] as! [[String : Any]]
            let tmpArray = array.map({ (dict) -> [String: Any] in
                var tmpDict = dict
                tmpDict["Is_Liked"] = 0
                return tmpDict
            })
            self.dataArray = tmpArray
            self.PresenationTableView.reloadData()
            
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
    }
    override func backAction() {
        if isFromPresentations{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.tabBarController?.selectedIndex = 1
        }
    }
    func getSavedPresentations(){
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.callSavedPresentation(successResponse: { (response) in
            
            ILUtility.hideProgressIndicator(controller: self)
            let value = response as? String ?? ""
            
            let dic : [String : Any] = value.convertToDictionary()!
            if let error = dic["message"] as? String, error == "favourite presentations are not found."{
                ILUtility.showAlert(message: error, controller: self)
                self.dataArray = []
                self.PresenationTableView.reloadData()
                return
            }
            let array : [[String:Any]] = dic["data"] as! [[String : Any]]
            let tmpArray = array.map({ (dict) -> [String: Any] in
                var tmpDict = dict
                tmpDict["Is_Liked"] = 0
                return tmpDict
            })
            self.dataArray = tmpArray
            self.PresenationTableView.reloadData()
            
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self)
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PresentationDetail") {
            let vc : PresentationDetailViewcontroller = segue.destination as! PresentationDetailViewcontroller
            vc.userID = sender as? String
        }
        else if (segue.identifier == "ReportPostID") {
            let vc : ReportPostViewController = segue.destination as! ReportPostViewController
            
            if let dict = sender as? [String: Any]{
                vc.userID = dict["id"] as? String ?? ""
                vc.presentationTitle = dict["title"] as? String ?? "Imaginglink"
            }
        }
    }
    @objc func likeUnLikeAction(_ sender: UIButton){
        let index = sender.tag
        var dict = dataArray[index]

        let presentationID = dict["id"] as? String ?? ""
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.requestForSaveLikeEmoji(presentationID: presentationID, likeUnLikeValue: "1", successResponse: { (response) in
            ILUtility.hideProgressIndicator(controller: self)
            if let data = response["data"] as? [String:Any]{
                dict["likes_count"] = data["liked_members_count"] as? Int 
            }
            
            if let likedStatus = dict["Is_Liked"] as? Int, likedStatus == 0{
                dict["Is_Liked"] = 1
            }
            else{
                dict["Is_Liked"] = 0
            }
            self.dataArray[index] = dict
            let indexPath = IndexPath(item: index, section: 0)
            self.PresenationTableView.reloadRows(at: [indexPath], with: .fade)
            
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self)
        }
        
    }
    @objc func favouritesUnFavouritesToPresentation(_ sender: UIButton){
        
        let index = sender.tag
        var dict = dataArray[index]
        let presentationID = dict["id"] as? String ?? ""
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.requestFavouriteUnfavorite(presentationID: presentationID, successResponse: {(response) in
            ILUtility.hideProgressIndicator(controller: self)
            let data = response as! [String:Any]
            ILUtility.showAlert(title: dict["title"] as? String ?? "Imaginglink",message: data["message"] as? String ?? "", controller: self)
            if let favStatus = dict["is_my_favourite"] as? Int, favStatus == 0{
                dict["is_my_favourite"] = 1
            }
            else{
                if !self.isFromPresentations{
                    self.getSavedPresentations()
                    return
                }
                dict["is_my_favourite"] = 0
            }
            self.dataArray[index] = dict
            let indexPath = IndexPath(item: index, section: 0)
            self.PresenationTableView.reloadRows(at: [indexPath], with: .fade)
            
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
    @objc func sharePresentation(_ sender: UIButton){
        let index = sender.tag
        let dict = dataArray[index]
        let title = dict["title"] as? String ?? ""
        let myWebsite = URL(string:dict["presentation_master_url"] as? String ?? "")
        let shareAll = [title, myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
        self.present(activityViewController, animated: false, completion: nil)
    }
    @objc func menuPressedButtonAction(_ sender: UIButton){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let dict = dataArray[sender.tag]
        var title = ""
        if let IsFollowed = dict["is_followed_by_me"] as? Int, IsFollowed == 0{
            title = "Follow this post"
        }
        else{
            title = "UnFollow this post"
        }
        
        let followPostAction = UIAlertAction(title: title, style: .default, handler: { (action) -> Void in
            self.followAndUnfollow(index: sender.tag)
        })
        let image = UIImage(named: "FollowPost_Icon")
        followPostAction.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
        followPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
        actionsheet.addAction(followPostAction)
        
        let reportPostAction = UIAlertAction(title: "Report post", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "ReportPostID", sender: dict)
        })
        let image1 = UIImage(named: "ReportPost_Icon")
        reportPostAction.setValue(image1?.withRenderingMode(.alwaysOriginal), forKey: "image")
        reportPostAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
        actionsheet.addAction(reportPostAction)
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    func followAndUnfollow(index: Int){
        var dict = dataArray[index]
        let presentationID = dict["id"] as? String ?? ""
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.requestFollowUnFollow(presentationID: presentationID, successResponse: {(response) in
            ILUtility.hideProgressIndicator(controller: self)
            let value = response as! [String:Any]
            ILUtility.showAlert(title: dict["title"] as? String ?? "Imaginglink",message: value["message"] as? String ?? "", controller: self)
            if let IsFollowed = dict["is_followed_by_me"] as? Int, IsFollowed == 0{
                dict["is_followed_by_me"] = 1
            }
            else{
                dict["is_followed_by_me"] = 0
            }
            self.dataArray[index] = dict
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
}
extension PresentationViewController: PresentationTableViewCellDelegate{
    func getLikedStatus(row: Int) {
        if likesArray.contains(row){
            if let index = likesArray.index(of: row) {
                likesArray.remove(at: index)
            }
        }
        else{
            likesArray.append(row)
        }
        self.PresenationTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    func updateRatingWithIndex(row: Int, rating: Int) {
        ILUtility.showProgressIndicator(controller: self)
        var dict = dataArray[row]
        let presentationID = dict["id"] as? String ?? ""

        CoreAPI.sharedManaged.requestForSaveLikeEmoji(presentationID: presentationID, likeUnLikeValue: "\(rating)", successResponse: { (response) in
            ILUtility.hideProgressIndicator(controller: self)
            self.getLikedStatus(row: row)
//            if let data = response["data"] as? [String:Any]{
//                dict["likes_count"] = data["liked_members_count"] as? Int
//            }
//
//            if let likedStatus = dict["Is_Liked"] as? Int, likedStatus == 0{
//                dict["Is_Liked"] = 1
//            }
//            else{
//                dict["Is_Liked"] = 0
//            }
//            self.dataArray[index] = dict
//            let indexPath = IndexPath(item: index, section: 0)
//            self.PresenationTableView.reloadRows(at: [indexPath], with: .fade)
            
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
}
