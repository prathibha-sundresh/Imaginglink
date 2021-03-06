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
    @IBOutlet weak var headerLbl: UILabel!
	@IBOutlet weak var noPresentationsFoundView: UIImageView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
	enum VCTypes: String{
		case Presentations
		case FavouritePresentations
		case FilterVC
		case None
	}
	static var isFromVC: VCTypes = VCTypes.None
    override func viewDidLoad() {
        super.viewDidLoad()
        PresenationTableView.tableFooterView = footerView
		self.navigationController?.isNavigationBarHidden = true
		self.tabBarController?.tabBar.isHidden = false
		switch PresentationViewController.self.isFromVC {
		case .Presentations:
			//addSlideMenuButton(showBackButton: true, backbuttonTitle: "Presentations")
			headerLbl.text = "Public Presentations"
		case .FavouritePresentations:
			headerLbl.text = "My Favourite Presentations"
			//addSlideMenuButton(showBackButton: true, backbuttonTitle: "My Favourite Presentations")
		default:
			break
		}
    }
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
		switch PresentationViewController.isFromVC {
		case .Presentations:
			getPublicPresentations()
		case .FavouritePresentations:
			getSavedPresentations()
		case .FilterVC:
			//isFromVC = .Presentations
			break
		default:
			break
		}
    }
	
	override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
	
    fileprivate func getPublicPresentations() {
		
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.callPublicPresentation(successResponse: { (response) in
            ILUtility.hideProgressIndicator(controller: self)
			self.getDataResults(response: response as! String)
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
    }
	
	func getDataResults(response: String){
		
		let dic : [String : Any] = response.convertToDictionary()!
		let array : [[String:Any]] = dic["data"] as? [[String : Any]] ?? []
		noPresentationsFoundView.isHidden = array.count > 0 ? true: false
		self.PresenationTableView.isHidden = array.count > 0 ? false: true
		if array.count == 0{
			//ILUtility.showAlert(message: "Currently we don't have published presentations.", controller: self)
			self.dataArray = []
			return
		}
		
		let tmpArray = array.map({ (dict) -> [String: Any] in
			var tmpDict = dict
			tmpDict["Is_Liked"] = 0
			return tmpDict
		})
		self.dataArray = tmpArray
		self.PresenationTableView.reloadData()
	}
	
	@IBAction func backAction(_ sender: UIButton) {
		switch PresentationViewController.isFromVC {
		case .Presentations, .FavouritePresentations:
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			appDelegate.openDashBoardScreen()
		case .FilterVC:
			self.performSegue(withIdentifier: "FilterVC", sender: nil)
		default:
			break
		}
    }
	
	@IBAction func menuAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
	}
	
    func getSavedPresentations(){
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.callSavedPresentation(successResponse: { (response) in
            
            ILUtility.hideProgressIndicator(controller: self)
            let value = response as? String ?? ""
            
            let dic : [String : Any] = value.convertToDictionary()!
            
			if let array : [[String:Any]] = dic["data"] as? [[String : Any]], array.count > 0 {
				let tmpArray = array.map({ (dict) -> [String: Any] in
					var tmpDict = dict
					tmpDict["Is_Liked"] = 0
					return tmpDict
				})
				self.dataArray = tmpArray
				self.PresenationTableView.reloadData()
			}
			else {
				ILUtility.showAlert(message: "favourite presentations are not found.", controller: self)
                self.dataArray = []
                self.PresenationTableView.reloadData()
			}
            
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
		else if (segue.identifier == "FilterVC") {
			let vc: FilterPublishViewController = segue.destination as! FilterPublishViewController
			vc.delegate = self
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
            if let favStatus = dict["is_my_favourite"] as? Int, favStatus == 0{
                dict["is_my_favourite"] = 1
				ILUtility.showAlert(title: dict["title"] as? String ?? "Imaginglink",message: "Added to the favourite list", controller: self)
            }
            else{
				ILUtility.showAlert(title: dict["title"] as? String ?? "Imaginglink",message: "Removed from the favourite list", controller: self)
				if PresentationViewController.self.isFromVC == .FavouritePresentations{
                    self.getSavedPresentations()
                    return
                }
                dict["is_my_favourite"] = 0
            }
            self.dataArray[index] = dict
			//self.reloadTableView(at: index)
			self.PresenationTableView.reloadData()
			//self.PresenationTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
        })
    }
    @objc func sharePresentation(_ sender: UIButton){
        let index = sender.tag
        let dict = dataArray[index]
        let title = dict["title"] as? String ?? ""
		
        let shareUrl = URL(string: kBaseUrl + "presentations/public/\(dict["id"] as? String ?? "")")
        let shareAll = [title, shareUrl!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: false, completion: nil)
    }
    @objc func menuPressedButtonAction(_ sender: UIButton){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
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
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
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
	
	@IBAction func filterButtonAction(_ sender: UIButton){
		self.performSegue(withIdentifier: "FilterVC", sender: nil)
	}
}
extension PresentationViewController: PresentationTableViewCellDelegate{
	fileprivate func reloadTableView(at row: Int) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			self.PresenationTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
		}
	}
	
	func getLikedStatus(row: Int) {
        if likesArray.contains(row){
			if let index = likesArray.firstIndex(of: row) {
                likesArray.remove(at: index)
            }
        }
        else{
            likesArray.append(row)
        }
		self.PresenationTableView.reloadData()
    }
    func updateRatingWithIndex(row: Int, rating: Int) {
        ILUtility.showProgressIndicator(controller: self)
        var dict = dataArray[row]
        let presentationID = dict["id"] as? String ?? ""

        CoreAPI.sharedManaged.requestForSaveLikeEmoji(presentationID: presentationID, likeUnLikeValue: "\(rating)", successResponse: { (response) in
            ILUtility.hideProgressIndicator(controller: self)
            
            if let data = response["data"] as? [String:Any]{
                dict["likes_count"] = data["liked_members_count"] as? Int
				if let strRating = data["like_emoji"] as? String{
					dict["like_emoji"] = Int(strRating) ?? 1
				}
				else{
					dict["like_emoji"] = data["like_emoji"] as? Int ?? 1
				}
            }

            self.dataArray[row] = dict
			self.getLikedStatus(row: row)
            
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
}

extension PresentationViewController: FilterPublishViewControllerDelegte{
	func UpdatedFilterResults(result: String){
		PresentationViewController.isFromVC = .FilterVC
		self.getDataResults(response: result)
	}
}
