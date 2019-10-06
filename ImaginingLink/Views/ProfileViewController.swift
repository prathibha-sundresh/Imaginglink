//
//  ProfileViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/1/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit
import SDWebImage
class ProfileViewController: BaseHamburgerViewController {

    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var firstNameTF: FloatingLabel!
    @IBOutlet weak var lastNameTF: FloatingLabel!
    @IBOutlet weak var emailTF: FloatingLabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var firstNameEditButton: UIButton!
    @IBOutlet weak var lastNameEditButton: UIButton!
    var imageUrl = ""
    var firstNameStr = ""
    var lastNameStr = ""
    var isFromPicker = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        addSlideMenuButton(showBackButton: true, backbuttonTitle: "Profile")
        firstNameTF.text = ILUtility.getValueFromUserDefaults(key: kFirstName)
        lastNameTF.text = ILUtility.getValueFromUserDefaults(key: kLastName)
        firstNameStr = firstNameTF.text!
        lastNameStr = lastNameTF.text!
        emailTF.text = ILUtility.getValueFromUserDefaults(key: kAuthenticatedEmailId)
        borderView.layer.borderColor = UIColor(red:0.89, green:0.92, blue:0.93, alpha:1.0).cgColor
        let localPath = photoExistOrNot()
        if localPath != ""{
            profilePhotoImage.image = UIImage(contentsOfFile: localPath)
        }
        else{
            profilePhotoImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "profileIcon"),options: SDWebImageOptions(rawValue: 0), completed: { (img, err, cacheType, imgURL) in
                if img != nil{
                    self.profilePhotoImage.image = img
                    let imgData = UIImageJPEGRepresentation(img!, 0.75)
                    self.saveImageToLocalPath(imageData: imgData!)
                }
            })
        }
        
        firstNameEditButton.isHidden = false
        lastNameEditButton.isHidden = false
        firstNameTF.isUserInteractionEnabled = false
        lastNameTF.isUserInteractionEnabled = false
        saveButton.backgroundColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
        saveButton.isUserInteractionEnabled = false
    }
    override func backAction() {
        self.tabBarController?.selectedIndex = 1
    }
    @IBAction func saveButtonAction(_ sender: UIButton){
        if firstNameTF.text == ""{
            ILUtility.showAlert(message: "please enter First name", controller: self)
        }
        else if lastNameTF.text == ""{
            ILUtility.showAlert(message: "please enter Last name", controller: self)
        }
        else{
            firstNameTF.resignFirstResponder()
            lastNameTF.resignFirstResponder()
            ILUtility.showProgressIndicator(controller: self)
            let dict = ["first_name":firstNameTF.text!,"last_name":lastNameTF.text!]
            CoreAPI.sharedManaged.updateUserDetails(requestDict: dict, successResponse: { (response) in
                ILUtility.hideProgressIndicator(controller: self)
                ILUtility.showAlert(message: "Profile deatils updated successfully.", controller: self)
                let fullName = "\(self.firstNameTF.text!) \(self.lastNameTF.text!)".capitalized
                UserDefaults.standard.set(fullName, forKey: kUserName)
                self.getUserDetails()
            }) { (error) in
                ILUtility.hideProgressIndicator(controller: self)
            }
        }
    }
    @IBAction func updatePofileButtonAction(_ sender: UIButton){
        let alert = UIAlertController(title: "Select any option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isFromPicker{
            setUI()
            getUserDetails()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("dd")
        isFromPicker = false
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getUserDetails(){
        
        CoreAPI.sharedManaged.getUserDetails(successResponse: { (response) in
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any]{
                let firstName = dict1["first_name"] as? String ?? ""
                let lastName = dict1["last_name"] as? String ?? ""
                UserDefaults.standard.set(firstName, forKey: kFirstName)
                UserDefaults.standard.set(lastName, forKey: kLastName)
                let fullName = "\(firstName) \(lastName)".capitalized
                UserDefaults.standard.set(fullName, forKey: kUserName)
                self.imageUrl = dict1["profile_photo"] as? String ?? ""
                self.setUI()
            }
        }) { (error) in
            
        }
    }
    @IBAction func firstNameEditAction(_ sender: UIButton){
        firstNameEditButton.isHidden = true
        firstNameTF.isUserInteractionEnabled = true
    }
    @IBAction func lastNameEditAction(_ sender: UIButton){
        lastNameEditButton.isHidden = true
        lastNameTF.isUserInteractionEnabled = true
    }
    @IBAction func textDidChange(_ textfield: UITextField){
        
        if textfield == firstNameTF{
            firstNameEditButton.isHidden = true
            updateSaveButtonBackground(textfield, str1: firstNameStr, str2: lastNameStr)
        }
        else{
            lastNameEditButton.isHidden = true
            updateSaveButtonBackground(textfield, str1: lastNameStr, str2: lastNameStr)
        }
        
    }
    func updateSaveButtonBackground(_ textfield: UITextField, str1: String,str2: String){
        
        if (str1 != firstNameTF.text && firstNameTF.text != "") || (str2 != lastNameTF.text && lastNameTF.text != ""){
            saveButton.backgroundColor = UIColor(red:0.98, green:0.58, blue:0.00, alpha:1.0)
            saveButton.isUserInteractionEnabled = true
        }
        else{
            saveButton.backgroundColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.0)
            saveButton.isUserInteractionEnabled = false
        }
    }
    
    func updateProfilePhoto(dict: [String: Any]){
        ILUtility.showProgressIndicator(controller: self)
        let imgData = dict["imageData"] as! Data
        CoreAPI.sharedManaged.updateProfilePhoto(requestDict: dict, successResponse: { (response) in
            ILUtility.hideProgressIndicator(controller: self)
            if let dict = response["data"] as? [String: Any]{
                self.imageUrl = dict["profile_photo"] as? String ?? ""
            }
            self.saveImageToLocalPath(imageData: imgData)
            ILUtility.showAlert(message: "Photo uploaded successfully.", controller: self)
            
        }) { (error) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
    func saveImageToLocalPath(imageData: Data){
        
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let imagePath = documentsPath?.appendingPathComponent("profile-photo.jpg")
        try! imageData.write(to: imagePath!)
    }
    func photoExistOrNot() -> String{
        let fileManager = FileManager.default
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let imagePath = documentsUrl.appendingPathComponent("profile-photo.jpg")
        
        if fileManager.fileExists(atPath: imagePath.path) {
            return imagePath.path
        } else {
            return ""
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK:-- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profilePhotoImage.image = pickedImage
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imgData = UIImageJPEGRepresentation(pickedImage, 0.75)
            updateProfilePhoto(dict: ["imageData": imgData!])
        }
        isFromPicker = true
        picker.dismiss(animated: true, completion: nil)
    }
}
