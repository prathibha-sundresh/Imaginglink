//
//  CreateFolioViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 26/06/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import Photos

class CreateFolioViewController: BaseHamburgerViewController,UserTypeDelegate {

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var contenView:UIView!
    @IBOutlet weak var folioTypeTextField:FloatingLabel!
    @IBOutlet weak var customFolioTypeTextField:FloatingLabel!
    @IBOutlet weak var folioName:FloatingLabel!
    @IBOutlet weak var folioDescriptionTextfield:FloatingLabel!
    @IBOutlet weak var folioLogoImageView:UIImageView!
    @IBOutlet weak var folioLogoImageName:UILabel!
    @IBOutlet weak var stepProgressView:StepProgressView!
    @IBOutlet weak var uploadLogoButton: UIButton!
    
//    var folioModel : CreateFolioModelView!
    var isLogoAdded = false
    var folioDicModel : [String:Any] = [String:Any]()
    
    func setupButtonUI() {
           uploadLogoButton.layer.cornerRadius = 20
           uploadLogoButton.contentHorizontalAlignment = .left
           if uploadLogoButton.imageView != nil {
               uploadLogoButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: (uploadLogoButton.frame.size.width - 35), bottom: 5, right: 0)
               uploadLogoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
           }
       }
    
    @IBAction func nextTapped(_ sender:Any) {
        if (folioTypeTextField.text?.count == 0) {
            ILUtility.showAlert(message: "Please enter folio type", controller: self)
        } else if (customFolioTypeTextField.text?.count == 0) {
            ILUtility.showAlert(message: "Please enter custom folio type", controller: self)
        } else if (folioDescriptionTextfield.text?.count == 0) {
            ILUtility.showAlert(message: "Please enter Description", controller: self)
        } else if (isLogoAdded == false) {
             ILUtility.showAlert(message: "Please Insert Logo", controller: self)
        } else {
            folioDicModel["folio_data[type]"] = folioTypeTextField.text!
            folioDicModel["folio_data[custom_folio_type]"] = customFolioTypeTextField.text!
            folioDicModel["folio_data[description]"] = folioDescriptionTextfield.text!
            folioDicModel["folio_data[title]"] = folioName.text!
            folioDicModel["folio_data[fax]"] = ""
            folioDicModel["members[]"] = ""
            performSegue(withIdentifier: "CreateFolioSecondViewID", sender: folioDicModel)
        }
    }
    
    @IBAction func folioTypeList(_ sender:Any) {
        let storyboard = UIStoryboard(name: "ListView", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ListViewId") as! ListViewController
        VC.delegate = self
        VC.listValue = kFolioType
        VC.filteredArray = kFolioType
        VC.selectedIndexValue = folioTypeTextField.text!
        self.present(VC, animated: true, completion: nil)
    }
    
    func selectedUserType(userType: String, indexRow: Int) {
        folioTypeTextField.text = userType
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonUI()
        stepProgressView.setProgressStep(stepsValue: progressStep.FirstStep.rawValue)
        addSlideMenuButton(showBackButton: true,backbuttonTitle: "CreateFolio")
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 60)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC : CreateFolioSecondViewController = segue.destination as! CreateFolioSecondViewController
        VC.folioDicModel = folioDicModel
    }
    
    @IBAction func photoUploadPressed(_ sender:UIButton) {
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
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CreateFolioViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imgData = pickedImage.jpegData(compressionQuality: 0.75) {
                folioDicModel["folio_data[logo][]"] = [imgData]
                isLogoAdded = true
            }           
        }
        
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            let assetResources = PHAssetResource.assetResources(for: asset)
            folioLogoImageName.text = assetResources.first!.originalFilename
            print(assetResources.first!.originalFilename)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

