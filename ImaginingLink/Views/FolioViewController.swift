//
//  FolioViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 07/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol createFolioDelegate {
    func createFolioPressed()
}

class FolioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "FolioController", for: indexPath) as! FolioTableViewCell
        tableViewCell.setupUI(dic: dataArray[indexPath.row])
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    @IBOutlet weak var folioTableView :UITableView!
    @IBOutlet weak var createFolioView:CreateFolioView!
     var dataArray : [[String:Any]] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folioTableView?.delegate = self
        folioTableView?.dataSource = self
        createFolioView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.callFolioPresentation(successResponse: {success in
             ILUtility.hideProgressIndicator(controller: self)
              let str : String = success as! String
             let dic : [String : Any] = str.convertToDictionary()!
            if let message = dic["message"] as? String, message == kTokenExpire {
                ILUtility.showAlertWithCallBack(message: "Token Expired, Please login.", controller: self, success: {
                    CoreAPI.sharedManaged.logOut()
                })
            }
              let array : [[String:Any]] = dic["data"] as? [[String : Any]] ?? []
              self.dataArray = array
              self.folioTableView.reloadData()
          }, faliure: {error in
              
          })
    }

    
}
extension FolioViewController : createFolioDelegate {
    func createFolioPressed() {
        performSegue(withIdentifier: "createFolio", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFolio" {
            segue.destination as! CreateFolioViewController
        }
    }
    
    
}
