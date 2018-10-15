//
//  MobileVerificationsViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 18/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileVerificationsViewcontroller: UIViewController, UserTypeDelegate {
    func selectedUserType(userType: String, indexRow: Int) {
        selectedCountryCode = CountryCodeForPhoneNumber[indexRow] as String
        countryCodeTF.text = selectedCountryCode
    }
    

    @IBAction func GetListOfCountried(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = countryName
        self.present(VC, animated: true, completion: nil)
    }
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    var selectedCountryCode = ""
    @IBAction func VerifyMobileNumberAction(_ sender: Any) {

        CoreAPI.sharedManaged.VerifyPhonenumber(phoneNumber: mobileNumberTF.text!, countryCode: selectedCountryCode, successResponse: {(response) in
            
             
            let storyBoard = UIStoryboard(name: "Verification", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MobileOTPViewController") as! MobileOTPVirecontroller
            self.navigationController?.pushViewController(vc, animated: true)
        }, faliure: {(error) in
            if (error == "The mobile has already been taken") {
            let storyBoard = UIStoryboard(name: "Verification", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MobileOTPViewController") as! MobileOTPVirecontroller
            self.navigationController?.pushViewController(vc, animated: true)
            }

        })
    }
    
    var CountryCodeForPhoneNumber : [String] = [""]
    var countryCode : [String] = [""]
    var countryName : [String] = [""]
    var listOfData = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreAPI.sharedManaged.getCountryList(successResponse: {(response) in
            let responseData = (response as! String).convertToDictionary()
            if let data : [[String:Any]] = responseData!["data"] as? [[String:Any]] {
                self.listOfData = data
                self.parseDataToFetchPhoneNumber(data: data)
            }
        }, faliure: {(error) in

        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func parseDataToFetchPhoneNumber(data: [[String:Any]]) {
        for value in data {
            countryCode.append(value["code"] as! String)
            CountryCodeForPhoneNumber.append(value["m_code"] as! String)
            countryName.append(value["name"] as! String)
        }
    }
}
