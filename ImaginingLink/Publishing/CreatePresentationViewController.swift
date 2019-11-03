//
//  CreatePresentationViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/19/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class KeywordsCVCell: UICollectionViewCell {
    @IBOutlet weak var nameButton: UIButton!
    func SetUI() {
        nameButton.layer.borderWidth = 1.0
        nameButton.layer.borderColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0).cgColor
        nameButton.layer.cornerRadius = 15.0
        nameButton.clipsToBounds = true
        
    }
}
class CreatePresentationViewController: UIViewController {
    var selectedSubsections: [String] = []
    @IBOutlet weak var subSectionsCV: UICollectionView!
    //@IBOutlet weak var keyWordsCVHeight: NSLayoutConstraint!
    var sections: [[String: Any]] = []
    var subSections: [String: Any] = [:]
    @IBOutlet weak var sectionTitleTF: UITextField!
    @IBOutlet weak var keywordsTF: UITextField!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var addVideoUrlTF: UITextField!
    @IBOutlet weak var fileNameButton: UIButton!
    var isFileUploaded: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        callSectionsAndSubSectionsAPI()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PopUpVCID" {
            
            let vc = segue.destination as! CustomPopUpViewController
            var subSectionsTmpArray = [[String: Any]]()
            if sectionTitleTF.text != "" {
                if let tmpArray = subSections[sectionTitleTF.text!] as? [[String: Any]]{
                    subSectionsTmpArray = tmpArray
                }
            }
            let tmpArray = sender as? Int == 100 ? sections : subSectionsTmpArray
            vc.titleArray = tmpArray.map({ (dict) -> String in
                return dict["title"] as? String ?? ""
            })
            vc.callBack = { (title) in
                if sender as? Int == 100{
                    self.sectionTitleTF.text = title
                    
                }
                else{
                    if !self.selectedSubsections.contains(title){
                        self.selectedSubsections.append(title)
                        self.subSectionsCV.reloadData()
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        let subSectionsStr = selectedSubsections.reduce("",+)
        
        if titleTF.text == "" {
            
        }
        else if sectionTitleTF.text == "" {
            
        }
        else if selectedSubsections.count == 0 {
            
        }
        else if descriptionTF.text == "" {
            
        }
        else if isFileUploaded || addVideoUrlTF.text == ""{
            
        }
        else{
            var requestDict = ["title": titleTF.text!, "section": sectionTitleTF.text!, "sub_sections": subSectionsStr, "is_file_upload": 1, "is_downloadable": 0, "keywords": keywordsTF.text!, "description": descriptionTF.text!, "university": ""] as [String : Any]
            
            if addVideoUrlTF.text != "" {
                requestDict["youtube_url"] = addVideoUrlTF.text! //"https://www.youtube.com/watch?v=JczSfmRpwUQ"//
            }
            else{
                //file upload
                
            }
            CoreAPI.sharedManaged.createPresentation(params: requestDict, successResponse: { (response) in
                print(response)
                self.performSegue(withIdentifier: "UpdatePresentationVCID", sender: nil)
            }) { (error) in
                
            }
        }
        
        
    }
    
    @IBAction func selectSectionsAndSubSections(_ sender: UIButton) {
        
        if sender.tag == 100 {
            self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
        }
        else if sender.tag == 101{
            self.performSegue(withIdentifier: "PopUpVCID", sender: sender.tag)
        }
        
    }
    
    func callSectionsAndSubSectionsAPI() {
        ILUtility.showProgressIndicator(controller: self)
        CoreAPI.sharedManaged.getSectionsAndSubSections(successResponse: { (response) in
            
            let value = response as? String ?? ""
            if let dict = value.convertToDictionary(), let dict1 = dict["data"] as? [String: Any] {
                self.sections = dict1["sections"] as? [[String: Any]] ?? []
                self.subSections = dict1["sub_sections"] as? [String: Any] ?? [:]
            }
            ILUtility.hideProgressIndicator(controller: self)
        }) { (errorMessage) in
            ILUtility.hideProgressIndicator(controller: self)
        }
    }
    @IBAction func uploadFileButtonAction(_ sender: Any) {

    }
}
extension CreatePresentationViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! KeywordsCVCell
        cell.nameButton.setTitle("    \(selectedSubsections[indexPath.item])   ✕    ", for: .normal)
        cell.SetUI()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSubsections.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ("    \(selectedSubsections[indexPath.item])    ✕    ").size(withAttributes: nil)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
