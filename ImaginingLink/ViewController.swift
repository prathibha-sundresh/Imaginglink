//
//  ViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 12/27/17.
//  Copyright © 2017 Imaginglink Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userTypePicker: UIPickerView!
    @IBOutlet weak var logoImage: UIImageView!
    var userTypeData:[String] = [String]()
    
    var userData:String?
    
    @IBAction func submit(_ sender: Any) {
        
        let emailAddress:String = "ppprathu6@gmail.com"//emailTextfield.text!
//        CoreAPI.sharedManaged.signUpWithEmailId(email: emailAddress, userType: "Radiology", status: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userTypeData = kUserTypes
        userTypePicker.dataSource = self
        userTypePicker.delegate = self
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 60)
        self.view.isUserInteractionEnabled = true
        let emailAddress:String = "ppprathu6@gmail.com"//emailTextfield.text!
//        CoreAPI.sharedManaged.signUpWithEmailId(email: emailAddress, userType: "Radiology", status: 0)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userTypeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userTypeData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userData = userTypeData[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


}

