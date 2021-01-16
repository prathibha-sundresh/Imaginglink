//
//  CreateGroupViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/8/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class UserFriendsListTVCell: UITableViewCell {
	@IBOutlet weak var fullNameText: UILabel!
	@IBOutlet weak var emailText: UILabel!
	@IBOutlet weak var profilePic: UIImageView!
	
	func setUI(dict: [String: Any]) {
		let fullName = "\(dict["first_name"] as? String ?? "") \(dict["last_name"] as? String ?? "")"
		fullNameText.text = fullName.capitalized
		emailText.text = dict["email"] as? String ?? ""
		profilePic.sd_setImage(with: URL(string: dict["profile_picture"] as? String ?? ""), placeholderImage: UIImage(named: "profileIcon"))
	}
}
class CreateGroupViewController: BaseHamburgerViewController {
	@IBOutlet weak var groupNameTF: FloatingLabel!
	@IBOutlet weak var uploadedGroupImage: UILabel!
	@IBOutlet weak var addedMembersLabel: UILabel!
	@IBOutlet weak var createButton: UIButton!
	@IBOutlet weak var userFriendsView: UIView!
	@IBOutlet weak var userFriendsTv: UITableView!
	@IBOutlet weak var saveMemberButton: UIButton!
	var imageDict = [UIImagePickerController.InfoKey : Any]()
	var selectedIndexFriends = [Int]()
	var userFriends = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "Create Group")
		addedMembersLabel.text = ""
		uploadedGroupImage.text = ""
		userFriendsTv.tableFooterView = UIView(frame: CGRect.zero)
		userFriendsView.frame = self.view.frame
		self.view.addSubview(userFriendsView)
		userFriendsView.isHidden = true
		validateFields()
		getUserFriends()
		
        // Do any additional setup after loading the view.
    }
    
	func getUserFriends() {
		
		ILUtility.showProgressIndicator(controller: self)
		SocialConnectAPI.sharedManaged.getUserFriends(successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
			let value = response as! String
			let dic : [String : Any] = value.convertToDictionary()!
			self.userFriends = dic["data"] as? [[String : Any]] ?? []
			self.userFriendsTv.reloadData()
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func createAction(_ sender: UIButton) {

		var requestDict = ["group_name": groupNameTF.text!]
		for (index, value) in selectedIndexFriends.enumerated() {
			requestDict["members[\(index)][user_id]"] = userFriends[value]["user_id"] as? String ?? ""
			requestDict["members[\(index)][first_name]"] = userFriends[value]["first_name"] as? String ?? ""
			requestDict["members[\(index)][last_name]"] = userFriends[value]["last_name"] as? String ?? ""
			requestDict["members[\(index)][email]"] = userFriends[value]["email"] as? String ?? ""
		}
		var groupImages = [[String :Any]]()
		if let pickedImage = imageDict[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			if let imgData = pickedImage.jpegData(compressionQuality: 0.5) {
				var mimeType = ""
				var fileName = ""
				if let url = imageDict[UIImagePickerController.InfoKey.imageURL] as? URL {
					fileName = url.lastPathComponent
					if url.pathExtension == "png" {
						mimeType = "image/png"
					}
					else if url.pathExtension == "bmp" {
						mimeType = "image/bmp"
					}
					else {
						mimeType = "image/jpeg"
					}
				}
				let dict = ["data": imgData, "fileName" : fileName, "mimeType" : mimeType] as [String: Any]
				groupImages.append(dict)
			}
		}
		
		GroupsAPI.sharedManaged.createGroup(parameters:requestDict, filesInfo: groupImages, successResponse: { (response) in
			ILUtility.hideProgressIndicator(controller: self)
		}) { (error) in
			ILUtility.hideProgressIndicator(controller: self)
		}
	}
	
	@IBAction func closeAction(_ sender: UIButton) {
		userFriendsView.isHidden = true
	}
	
	@IBAction func saveMembersAction(_ sender: UIButton) {
		userFriendsView.isHidden = true
		addedMembersLabel.text = "\(selectedIndexFriends.count)+ Members"
		validateFields()
	}
	
	@IBAction func cancelAction(_ sender: UIButton) {
		groupNameTF.text = ""
		addedMembersLabel.text = ""
		uploadedGroupImage.text = ""
		validateFields()
	}
	
	@IBAction func uploadImageAction(_ sender: UIButton) {
		groupNameTF.resignFirstResponder()
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
	
	@IBAction func addMembersAction(_ sender: UIButton) {
		userFriendsView.isHidden = false
		saveMemberButton.isEnabled = selectedIndexFriends.count > 0 ? true : false
		saveMemberButton.alpha = selectedIndexFriends.count > 0 ? 1.0 : 0.5
		groupNameTF.resignFirstResponder()
	}
	
	@IBAction func textDidChangeAction(_ textField: UITextField) {
		validateFields()
	}
	
	func validateFields() {
		if groupNameTF.text == "" || uploadedGroupImage.text == "" || addedMembersLabel.text == "" {
			createButton.isEnabled = false
			createButton.alpha = 0.5
		}
		else {
			createButton.isEnabled = true
			createButton.alpha = 1.0
		}
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateGroupViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imageDict = info
		if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
			uploadedGroupImage.text = url.lastPathComponent
		}
		picker.dismiss(animated: true, completion: nil)
		validateFields()
	}
}

extension CreateGroupViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UserFriendsListTvCellID", for: indexPath) as! UserFriendsListTVCell
		cell.setUI(dict: userFriends[indexPath.row])
		if selectedIndexFriends.contains(indexPath.row) {
			cell.accessoryType = .checkmark
		}
		else{
			cell.accessoryType = .none
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return userFriends.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if selectedIndexFriends.contains(indexPath.row) {
			if let index = selectedIndexFriends.firstIndex(of: indexPath.row){
				selectedIndexFriends.remove(at: index)
			}
		}
		else{
			selectedIndexFriends.append(indexPath.row)
		}
		userFriendsTv.reloadData()
		saveMemberButton.isEnabled = selectedIndexFriends.count > 0 ? true : false
		saveMemberButton.alpha = selectedIndexFriends.count > 0 ? 1.0 : 0.5
	}
}
