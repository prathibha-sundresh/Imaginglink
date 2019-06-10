//
//  MobileVerificationsViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 18/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileVerificationsViewcontroller: UIViewController, UserTypeDelegate, UITextFieldDelegate {
    func selectedUserType(userType: String, indexRow: Int) {
        selectedCountryCode = CountryCodeForPhoneNumber[indexRow] as String
        let selectedCountryName = countryName[indexRow] as String
        
        countryCodeTF.text = "\(selectedCountryName)(\(selectedCountryCode))"
        
    }
    

    @IBAction func GetListOfCountried(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = countryName
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var countryCodeTF: FloatingLabel!
    @IBOutlet weak var mobileNumberTF: FloatingLabel!
    var selectedCountryCode = ""
    @IBAction func VerifyMobileNumberAction(_ sender: Any) {
        ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "Verifying..")
        CoreAPI.sharedManaged.VerifyPhonenumber(phoneNumber: mobileNumberTF.text!, countryCode: selectedCountryCode, successResponse: {(response) in
            ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: "success..")
             
            let storyBoard = UIStoryboard(name: "Verification", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MobileOTPViewController") as! MobileOTPVirecontroller
            self.navigationController?.pushViewController(vc, animated: true)
        }, faliure: {(error) in
           
            let string : String = error
             ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            if (string.contains("The mobile has already been taken")) {
                CoreAPI.sharedManaged.reSendMobileOTP(successResponse: {(response) in
                    let storyBoard = UIStoryboard(name: "Verification", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "MobileOTPViewController") as! MobileOTPVirecontroller
                    self.navigationController?.pushViewController(vc, animated: true)
                }, faliure: {(error) in
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
                })
            
            }

        })
    }
    
    var CountryCodeForPhoneNumber : [String] = [""]
    var countryCode : [String] = [""]
    var countryName : [String] = [""]
    var listOfData = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
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
    
    func setUpTextField() {
        mobileNumberTF.setUpLabel(WithText: "Mobile")
        mobileNumberTF.delegate = self
        
        countryCodeTF.setUpLabel(WithText: "select country code")
        countryCodeTF.delegate = self
    }
    
    func parseDataToFetchPhoneNumber(data: [[String:Any]]) {
        for value in data {
            countryCode.append(value["code"] as! String)
            CountryCodeForPhoneNumber.append(value["m_code"] as! String)
            countryName.append(value["name"] as! String)
        }
    }
}
