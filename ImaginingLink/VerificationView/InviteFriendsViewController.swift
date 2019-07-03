
//
//  File.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/18/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import UIKit

class  InviteFriendsViewController: BaseHamburgerViewController{
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Inviting...")
        CoreAPI.sharedManaged.requestToInviteFriends(params: ["email" : inviteFriendsTextField.text!], successResponse: {(response) in
             if let responeValue : [String : Any] = response as? [String : Any] {
                if (responeValue["status"] as! String == "success") {
                    ILUtility.showAlert(message: response["message"] as? String ?? "", controller: self)
                }
            }
        }, faliure: {(error) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
        })

        
    }
    @IBOutlet weak var inviteFriendsTextField: FloatingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteFriendsTextField.setUpLabel(WithText: "Enter email Id")
        
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func cancelButton(_ sender: UIButton){
        let storyboard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ILTabViewController") as! ILTabViewController
        vc.selectedIndex = 2
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
