//
//  CreateFolioSecondViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 01/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class CreateFolioSecondViewController: BaseHamburgerViewController {
    
    @IBOutlet weak var stepProgressView: StepProgressView!
    @IBOutlet weak var countryCodeLabel :UILabel!
    @IBOutlet weak var CountryCodeSelectionButton :UIButton!
    @IBOutlet weak var phoneNumberTextField :UITextField!
    @IBOutlet weak var hidePhoneNumberButton :UIButton!
    @IBOutlet weak var addressTextfield :UITextField!
    @IBOutlet weak var hideAddressButton :UIButton!
    @IBOutlet weak var emailextField :UITextField!
    
    var folioDicModel : [String:Any]!
    var CountryCodeForPhoneNumber : [String] = []
    var countryCode : [String] = []
    var countryName : [String] = []
    var listOfData = [[String:Any]]()
    var selectedCountryCode = ""
    var selectedCountryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepProgressView.setProgressStep(stepsValue: progressStep.SecondStep.rawValue)
        addSlideMenuButton(showBackButton: true,backbuttonTitle: "CreateFolio")
        fetchCountryCode()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextTapped(_ sender:Any) {
    if (phoneNumberTextField.text?.count == 0 ) {
            ILUtility.showAlert(message: "Please enter correct phonenumber ", controller: self)
        } else if (emailextField.text?.count == 0 && (emailextField.text?.isValidEmail())!) {
            ILUtility.showAlert(message: "Please enter correct email ID", controller: self)
        } else if (addressTextfield.text?.count == 0) {
            ILUtility.showAlert(message: "Please enter the address", controller: self )
        } else {
            folioDicModel["folio_data[city]"]  = addressTextfield!.text ?? ""
            folioDicModel["folio_data[region]"]  = addressTextfield!.text ?? ""
            folioDicModel["folio_data[country]"]  = selectedCountryName
            folioDicModel["folio_data[first_address]"]  = addressTextfield!.text ?? ""
            folioDicModel["folio_data[number]"]  = phoneNumberTextField.text!
            folioDicModel["folio_data[is_phone_public]"]  = hidePhoneNumberButton.isSelected
            folioDicModel["folio_data[is_address_public]"]  = hideAddressButton.isSelected
            folioDicModel["folio_data[email]"]  = emailextField.text!
            
            performSegue(withIdentifier: "CreateFolioThirdViewControllerID", sender: folioDicModel)
        }
    }
    
    @IBAction func backTapped(_ sender:Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hidePhoneNumberTapped(_ sender:UIButton) {
        let imageName = sender.isSelected ? "unCheckedBox" : "ClickedCheckBox"
        sender.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        sender.isSelected = !sender.isSelected
        folioDicModel["folio_data[is_phone_public]"] = sender.isSelected
    }
    
    
    
    @IBAction func hideAddressTapped(_ sender:UIButton) {
        let imageName = sender.isSelected ? "unCheckedBox" : "ClickedCheckBox"
        sender.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        sender.isSelected = !sender.isSelected
        folioDicModel["folio_data[is_address_public]"] = sender.isSelected
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC : CreateFolioThirdViewController = segue.destination as! CreateFolioThirdViewController
        VC.folioDicModel = folioDicModel
    }

}

extension CreateFolioSecondViewController : UserTypeDelegate{
    
    func selectedUserType(userType: String, indexRow: Int) {
        let filterArray = listOfData.filter { (dict) -> Bool in
            return dict["name"] as? String ?? "" == userType
        }
        if filterArray.count > 0{
            selectedCountryCode = filterArray[0]["m_code"] as? String ?? ""
            selectedCountryName = filterArray[0]["name"] as? String ?? ""
            countryCodeLabel.text! = selectedCountryCode
            folioDicModel["folio_data[country]"] = selectedCountryName
        }
    }
    
    func fetchCountryCode() {
        CoreAPI.sharedManaged.getCountryList(successResponse: {(response) in
            let responseData = (response as! String).convertToDictionary()
            if let data : [[String:Any]] = responseData!["data"] as? [[String:Any]] {
                self.listOfData = data
                self.countryCodeLabel.text = data[0]["m_code"] as? String
                self.selectedCountryName = data[0]["name"] as? String ?? "Not recognized"
                self.folioDicModel["folio_data[country]"] = data[0]["name"]! as! String
                self.parseDataToFetchPhoneNumber(data: data)
            }
        }, faliure: {(error) in
            
        })
    }
    
    func parseDataToFetchPhoneNumber(data: [[String:Any]]) {
        for value in data {
            countryCode.append(value["code"] as! String)
            CountryCodeForPhoneNumber.append(value["m_code"] as! String)
            countryName.append(value["name"] as! String)
        }
    }
    
    @IBAction func listOfCountryCode() {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = countryName
        VC.filteredArray = countryName
        VC.selectedIndexValue = selectedCountryName
        self.present(VC, animated: true, completion: nil)
    }
}
