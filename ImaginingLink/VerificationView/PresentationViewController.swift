//
//  PresentationView.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 27/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class PresentationViewController: BaseHamburgerViewController, UITableViewDelegate, UITableViewDataSource, PresentationDelegate {
    func favouritesUnFavouritesWithPresentationId(id: String, successResponse: @escaping (String) -> Void) {
        CoreAPI.sharedManaged.requestFavouriteUnfavorite(presentationID: id, successResponse: {(response) in
            
            let data = response as! [String:Any]
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: data["message"] as! String)
            
            successResponse(data["message"] as! String)
            
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
    }
    
    func followUnfollowWithPresentationId(id: String, successResponse: @escaping (String) -> Void) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please wait..")
        CoreAPI.sharedManaged.requestFollowUnFollow(presentationID: id, successResponse: {(response) in
            let value = response as! [String:Any]
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: value["message"] as! String)
            
        }, faliure: {(error) in
             ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
    }
    
    func notifyOrCancelWithPresentationId(id: String, successResponse: @escaping (String) -> Void) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Please wait..")
        CoreAPI.sharedManaged.requestNotify(presentationID: id, successResponse: {(response) in
            let value = response as! [String:Any]
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: value["message"] as! String)
            
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
    }
    
    @IBOutlet weak var PresenationTableView: UITableView!
    let presentationArray : [[String:Any]]? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataArray != nil) {
            return (dataArray!.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let tableviewcell = tableView.dequeueReusableCell(withIdentifier: "PresentationTableViewCell", for: indexPath) as! PresentationTableViewCell
        tableviewcell.selectionStyle = UITableViewCellSelectionStyle.none
        tableviewcell.myVC = self
        tableviewcell.setUpProfileImage()
        tableviewcell.delegate = self
        print("deic valuesi \(dataArray![indexPath.row])")
        tableviewcell.setupUI(dic: dataArray![indexPath.row])
       
        return tableviewcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ID = dataArray![indexPath.row]
        let value = ID["id"] as! String
        self.performSegue(withIdentifier: "PresentationDetail", sender: value)
    }
    
    var dataArray : [[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()
         PresenationTableView.dataSource = self
        PresenationTableView.delegate = self
//        self.navigationItem.title = "presenations"
        addSlideMenuButton(showBackButton: false, backbuttonTitle: "presentations")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        ILUtility.addNavigationBarBackToCartButton(controller: self)
//        ILUtility.addNavigationBarBackButton(controller: self, userName: UserDefaults.standard.value(forKey: kUserName) as! String, userType: UserDefaults.standard.value(forKey: kUserType) as! String)

        CoreAPI.sharedManaged.callPublicPresentation(successResponse: {(response) in
            let value = response as! String
            let dic : [String : Any] = value.convertToDictionary()!
            let array : [[String:Any]] = dic["data"] as! [[String : Any]]
            
            self.dataArray = array
            self.PresenationTableView.reloadData()
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "PresentationDetail") {
            let vc : PresentationDetailViewcontroller = segue.destination as! PresentationDetailViewcontroller
            vc.userID = sender as? String
        }
    }
    

    
    
}
