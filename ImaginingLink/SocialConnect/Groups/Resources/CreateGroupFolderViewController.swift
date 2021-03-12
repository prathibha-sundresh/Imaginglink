//
//  CreateGroupFolderViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 2/6/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import UIKit

class ResourceCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var folderName: UILabel!
	@IBOutlet weak var filesCountLabel: UILabel!
	@IBOutlet weak var settingButton: UIButton!
	@IBOutlet weak var borderView: UIView!
	func setUI(dict: [String: Any]) {
		folderName.text = dict["folder"] as? String ?? ""
		filesCountLabel.text = "0 Files"
		if let resources = (dict["resource"] as? [[String: Any]] ?? [])?.filter({ (dict) -> Bool in
			return (dict["status"] as? String ?? "") != "DELETED"
		}), resources.count > 0 {
			filesCountLabel.text = "\(resources.count) Files"
		}
		borderView.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
	}
}
class CreateGroupFolderViewController: UIViewController {
	@IBOutlet weak var createFolderButton: UIButton!
	@IBOutlet weak var addFolderButton: UIButton!
	@IBOutlet weak var folderNameTf: UITextField!
	@IBOutlet weak var createFolderView: UIView!
	@IBOutlet weak var folderCV: UICollectionView!
	@IBOutlet weak var popUpHeaderTitle: UILabel!
	var groupId = ""
	var selectedFolderID = ""
	var foldersArray = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
		createFolderView.frame = folderCV.frame
		self.view.addSubview(createFolderView)
		createFolderView.isHidden = true
		textDidChange(folderNameTf)
		getResourceFolderList()
		folderNameTf.setLeftPaddingPoints(15)
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	func getResourceFolderList() {
		
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.getGroupGetAllResources(groupId: groupId, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			if let array = dic["data"] as? [[String : Any]] {
				self.addFolderButton.isSelected = false
				self.createFolderView.isHidden = true
				self.foldersArray = array
				self.folderCV.reloadData()
			}
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "FolderDetailViewControllerSegue" {
			self.navigationController?.isNavigationBarHidden = false
			let vc = segue.destination as! GroupFolderDetailViewController
			vc.selectedDict = sender as? [String: Any] ?? [:]
		}
    }
    
	@IBAction func showHideCreateFolderView(_ sender: UIButton) {
		createFolderButton.tag = 0
		createFolderButton.setTitle("Create folder", for: .normal)
		popUpHeaderTitle.text = "Create Folder"
		folderNameTf.text = ""
		if !addFolderButton.isSelected {
			createFolderView.isHidden = false
			addFolderButton.isSelected = true
		}
	}
	
	@IBAction func cancelCreateFolderView(_ sender: UIButton) {
		folderNameTf.resignFirstResponder()
		addFolderButton.isSelected = false
		createFolderView.isHidden = true
	}
	
	@IBAction func createFolderButton(_ sender: UIButton) {
		folderNameTf.resignFirstResponder()
		var dict = [String: Any]()
		if createFolderButton.tag == 101 {
			dict = ["group_id": groupId,"folder_id": selectedFolderID,"folder_name": folderNameTf.text!] as [String : Any]
		}
		else {
			dict = ["group_id": groupId,"folder_name": folderNameTf.text!] as [String : Any]
		}
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.createOrUpdateGroupResourcesFolder(parameterDict: dict) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getResourceFolderList()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func deleteFolder(index: Int) {
		let dict = foldersArray[index]
		let dic = ["resource_id": dict["_id"] as? String ?? ""] as [String : Any]
		ILUtility.showProgressIndicator(controller: self)
		GroupsAPI.sharedManaged.deleteGroupResourcesFolder(parameterDict: dic) { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			self.getResourceFolderList()
		} faliure: { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	func renameFolder(index: Int) {
		selectedFolderID = foldersArray[index]["_id"] as? String ?? ""
		folderNameTf.text = foldersArray[index]["folder"] as? String ?? ""
		createFolderButton.tag = 101
		createFolderView.isHidden = false
		addFolderButton.isSelected = true
		createFolderButton.setTitle("Update folder", for: .normal)
		popUpHeaderTitle.text = "Update Folder"
	}
	
	@objc func settingButtonAction(_ sender: UIButton) {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
	
		let renameFolderAction = UIAlertAction(title: "Rename Folder", style: .default, handler: { (action) -> Void in
			self.renameFolder(index: sender.tag)
		})
		
		let deleteFolderAction = UIAlertAction(title: "Delete Folder", style: .default, handler: { (action) -> Void in
			self.deleteFolder(index: sender.tag)
		})
		
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
			
		}))
		
		renameFolderAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		deleteFolderAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(renameFolderAction)
		actionsheet.addAction(deleteFolderAction)
		
		self.present(actionsheet, animated: true, completion: nil)
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		if textField.text == "" {
			createFolderButton.isEnabled = false
			createFolderButton.alpha = 0.7
		}
		else {
			createFolderButton.isEnabled = true
			createFolderButton.alpha = 1.0
		}
	}
}

extension CreateGroupFolderViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResourceCollectionViewCellID", for: indexPath) as! ResourceCollectionViewCell
		cell.setUI(dict:  foldersArray[indexPath.item])
		cell.settingButton.tag = indexPath.item
		cell.settingButton.addTarget(self, action: #selector(settingButtonAction), for: .touchUpInside)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return foldersArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 110, height: 170)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let tmpDict = foldersArray[indexPath.row]
		self.performSegue(withIdentifier: "FolderDetailViewControllerSegue", sender: tmpDict)
	}
}
