//
//  MobileVerificationsViewcontroller.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 18/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class MobileVerificationsViewcontroller: BaseHamburgerViewController, UserTypeDelegate, UITextFieldDelegate {
    func selectedUserType(userType: String, indexRow: Int) {
        let filterArray = listOfData.filter { (dict) -> Bool in
            return dict["name"] as? String ?? "" == userType
        }
        if filterArray.count > 0{
            selectedCountryCode = filterArray[0]["m_code"] as? String ?? ""
            selectedCountryName = filterArray[0]["name"] as? String ?? ""
            countryCodeTF.text = "\(selectedCountryName) (\(selectedCountryCode))"
        }
    }
    

    @IBAction func GetListOfCountried(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = countryName
        VC.filteredArray = countryName
        VC.selectedIndexValue = selectedCountryName
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var countryCodeTF: FloatingLabel!
    @IBOutlet weak var mobileNumberTF: FloatingLabel!
    var selectedCountryCode = ""
    var isFromSignIn = false
    var selectedCountryName = ""
    @IBAction func VerifyMobileNumberAction(_ sender: Any) {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.VerifyPhonenumber(phoneNumber: mobileNumberTF.text!, countryCode: selectedCountryCode, successResponse: {(response) in
             ILUtility.hideProgressIndicator(controller: self)
            self.moveToMobileOTPViewController()
        }, faliure: {(error) in
            ILUtility.hideProgressIndicator(controller: self)
            if (error.contains("The mobile has already been taken")) {
                CoreAPI.sharedManaged.reSendMobileOTP(successResponse: {(response) in
                    self.moveToMobileOTPViewController()
                }, faliure: {(error) in
                    ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
                })
            
            }
            else{
                ILUtility.showToastMessage(toViewcontroller: self, statusToDisplay: error)
            }
        })
    }
    
    var CountryCodeForPhoneNumber : [String] = []
    var countryCode : [String] = []
    var countryName : [String] = []
    var listOfData = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isFromSignIn{
            addSlideMenuButton(showBackButton: true ,backbuttonTitle: "\(UserDefaults.standard.value(forKey: kUserName) as! String)\n\(UserDefaults.standard.value(forKey: kAuthenticatedEmailId) as! String)")
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
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
    func moveToMobileOTPViewController(){
        let storyBoard = UIStoryboard(name: "Verification", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MobileOTPViewController") as! MobileOTPVirecontroller
        vc.isFromSignIn = isFromSignIn
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func setUpTextField() {
        mobileNumberTF.setUpLabel(WithText: "Enter Mobile")
        mobileNumberTF.delegate = self
        
        countryCodeTF.setUpLabel(WithText: "Select country code")
        countryCodeTF.delegate = self
        addRightView()
    }
    
    func parseDataToFetchPhoneNumber(data: [[String:Any]]) {
        for value in data {
            countryCode.append(value["code"] as! String)
            CountryCodeForPhoneNumber.append(value["m_code"] as! String)
            countryName.append(value["name"] as! String)
        }
    }
    func addRightView(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BlackColorDropDownImage"), for: .normal)
        button.frame = CGRect(x: CGFloat(countryCodeTF.frame.size.width - 25), y: 0, width: 40, height: 40)
        countryCodeTF.rightView = button
        countryCodeTF.rightViewMode = .always
    }
}
