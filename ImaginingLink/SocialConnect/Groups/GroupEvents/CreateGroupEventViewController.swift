//
//  CreateGroupEventViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/26/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class CreateGroupEventViewController: BaseHamburgerViewController {
	@IBOutlet weak var eventNameTF: FloatingLabel!
	@IBOutlet weak var uploadedEventImage: UILabel!
	@IBOutlet weak var startDateLabel: UILabel!
	@IBOutlet weak var endDateLabel: UILabel!
	@IBOutlet weak var eventLocationTF: FloatingLabel!
	@IBOutlet weak var eventDescriptionTF: FloatingLabel!
	@IBOutlet weak var manageRsvpButton: UIButton!
	@IBOutlet weak var inviteAllButton: UIButton!
	@IBOutlet weak var createEventButton: UIButton!
	@IBOutlet weak var goingButton: UIButton!
	@IBOutlet weak var notGoingButton: UIButton!
	@IBOutlet weak var maybeButton: UIButton!
	@IBOutlet weak var invitedButton: UIButton!
	@IBOutlet weak var dateView: UIDatePicker!
	@IBOutlet weak var datePickerView: UIView!
	@IBOutlet weak var endDateView: UIDatePicker!
	@IBOutlet weak var endDatePickerView: UIView!
	@IBOutlet weak var rsvpOptionsViewH: NSLayoutConstraint!
	@IBOutlet weak var rsvpOptionsView: UIView!
	@IBOutlet weak var headerTitleLabel: UILabel!
	var imageDict = [UIImagePickerController.InfoKey : Any]()
	var groupId = ""
	var eventId = ""
	var selectedDict = [String: Any]()
	var isUpdateMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
		
		datePickerView.frame = CGRect(x: 0, y: self.view.frame.height - 240, width: self.view.frame.width, height: 240)
		self.view.addSubview(datePickerView)
		datePickerView.isHidden = true
		
		endDatePickerView.frame = CGRect(x: 0, y: self.view.frame.height - 240, width: self.view.frame.width, height: 240)
		self.view.addSubview(endDatePickerView)
		endDatePickerView.isHidden = true
		
		eventId = selectedDict["_id"] as? String ?? ""
		headerTitleLabel.text = isUpdateMode ? "Update event" : "Create event"
		createEventButton.setTitle(isUpdateMode ? "Save Event":"Create Event", for: .normal)
		if isUpdateMode {
			eventNameTF.text = selectedDict[""] as? String ?? ""
			uploadedEventImage.text = ((selectedDict["photo"] as? String ?? "") as NSString).lastPathComponent
			eventNameTF.text = (selectedDict["event_name"] as? String ?? "").capitalized
			eventLocationTF.text = selectedDict["location"] as? String ?? ""
			eventDescriptionTF.text = selectedDict["description"] as? String ?? ""
			
			if let dateStr = selectedDict["start_date"] as? String {
				let df = DateFormatter()
				df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
				let date = df.date(from: dateStr)
				dateView.date = date!
				df.dateFormat = "hh:mm a"
				let timeStr = df.string(from: date!)
				df.dateFormat = "dd MMM yyyy"
				let dateStr = df.string(from: date!)
				startDateLabel.text = "\(dateStr) at \(timeStr)"
			}
			
			if let dateStr = selectedDict["end_date"] as? String {
				let df = DateFormatter()
				df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
				let date = df.date(from: dateStr)
				endDateView.date = date!
				df.dateFormat = "hh:mm a"
				let timeStr = df.string(from: date!)
				df.dateFormat = "dd MMM yyyy"
				let dateStr = df.string(from: date!)
				endDateLabel.text = "\(dateStr) at \(timeStr)"
			}
			
			if let dict = selectedDict["rsvp_status"] as? [String: Any] {
				goingButton.isSelected = Bool(dict["going"] as? String ?? "false") ?? false
				notGoingButton.isSelected = Bool(dict["not_going"] as? String ?? "false") ?? false
				maybeButton.isSelected = Bool(dict["may_be"] as? String ?? "false") ?? false
				invitedButton.isSelected = Bool(dict["invited"] as? String ?? "false") ?? false
			}
		}
		manageRsvpButtonAction(manageRsvpButton)
		validateFields()
        // Do any additional setup after loading the view.
    }
    
	@IBAction func backButtonAction(_ sender: UIButton) {
		backAction()
	}
	
	@IBAction func menuButtonAction(_ sender: UIButton) {
		onSlideMenuButtonPressed(sender)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func createEvent(_ sender: UIButton) {
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let startDateStr = df.string(from: dateView.date)
		let endDateStr = df.string(from: endDateView.date)
		var requestDict = ["event_name": eventNameTF.text!,"start_date": startDateStr,"end_date": endDateStr,"group_id": groupId, "location": eventLocationTF.text!, "description": eventDescriptionTF.text!, "invite_friends" : inviteAllButton.isSelected] as [String : Any]
		if manageRsvpButton.isSelected {
			requestDict["rsvp_status[not_going]"] = notGoingButton.isSelected
			requestDict["rsvp_status[going]"] = goingButton.isSelected
			requestDict["rsvp_status[may_be]"] = maybeButton.isSelected
			requestDict["rsvp_status[invited]"] = invitedButton.isSelected
		}
		else {
			requestDict["rsvp_status"] = manageRsvpButton.isSelected
		}
		
		var groupImages = [[String :Any]]()
		var fileAlreadyExists =  false
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
		else {
			fileAlreadyExists = true
		}
		
		if isUpdateMode {
			requestDict["group_id"] = groupId
			requestDict["event_id"] = eventId
			if fileAlreadyExists {
				requestDict["existing_photo[]"] = uploadedEventImage.text!
			}
			ILUtility.showProgressIndicator(controller: self)
			GroupsAPI.sharedManaged.updateGroupEvent(parameters:requestDict, filesInfo: groupImages, fileExists: fileAlreadyExists, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
				let alert = UIAlertController(title: "Imaginglink", message: "Event updated successfully.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
					self.backAction()
				}))
				self.present(alert, animated: true, completion: nil)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
		else {
			ILUtility.showProgressIndicator(controller: self)
			GroupsAPI.sharedManaged.createEventForGroup(parameters:requestDict, filesInfo: groupImages, successResponse: { (response) in
				ILUtility.hideProgressIndicator(controller: self)
			}) { (error) in
				ILUtility.hideProgressIndicator(controller: self)
			}
		}
	}
	
	@IBAction func manageRsvpButtonAction(_ sender: UIButton) {
		if !manageRsvpButton.isSelected {
			manageRsvpButton.isSelected = true
			rsvpOptionsViewH.constant = 205
			rsvpOptionsView.isHidden = false
		}
		else {
			manageRsvpButton.isSelected = false
			rsvpOptionsViewH.constant = 0
			rsvpOptionsView.isHidden = true
		}
	}
	
	@IBAction func inviteAllButtonAction(_ sender: UIButton) {
		if !inviteAllButton.isSelected {
			inviteAllButton.isSelected = true
		}
		else {
			inviteAllButton.isSelected = false
		}
	}
	
	@IBAction func startDateButtonAction(_ sender: UIButton) {
		datePickerView.isHidden = false
		endDatePickerView.isHidden = true
	}
	
	@IBAction func endDateButtonAction(_ sender: UIButton) {
		endDatePickerView.isHidden = false
		datePickerView.isHidden = true
	}
	
	@IBAction func doneButtonAction(_ sender: UIButton) {
		datePickerView.isHidden = true
		endDatePickerView.isHidden = true
	}
	
	@IBAction func startDatePickerChanged(_ sender: Any) {
		let df = DateFormatter()
		df.dateFormat = "hh:mm a"
		let timeStr = df.string(from: dateView.date)
		df.dateFormat = "dd MMM yyyy"
		let dateStr = df.string(from: dateView.date)
		startDateLabel.text = "\(dateStr) at \(timeStr)"
		
	}
	
	@IBAction func endDatePickerChanged(_ sender: Any) {
		let df = DateFormatter()
		df.dateFormat = "hh:mm a"
		let timeStr = df.string(from: endDateView.date)
		df.dateFormat = "dd MMM yyyy"
		let dateStr = df.string(from: endDateView.date)
		endDateLabel.text = "\(dateStr) at \(timeStr)"
	}
	
	@IBAction func goingButtonAction(_ sender: UIButton) {
		if !goingButton.isSelected {
			goingButton.isSelected = true
		}
		else {
			goingButton.isSelected = false
		}
	}
	
	@IBAction func notGoingButtonAction(_ sender: UIButton) {
		if !notGoingButton.isSelected {
			notGoingButton.isSelected = true
		}
		else {
			notGoingButton.isSelected = false
		}
	}
	
	@IBAction func maybeButtonAction(_ sender: UIButton) {
		if !maybeButton.isSelected {
			maybeButton.isSelected = true
		}
		else {
			maybeButton.isSelected = false
		}
	}
	
	@IBAction func invitedButtonAction(_ sender: UIButton) {
		if !invitedButton.isSelected {
			invitedButton.isSelected = true
		}
		else {
			invitedButton.isSelected = false
		}
	}
	
	@IBAction func uploadImageAction(_ sender: UIButton) {
		eventNameTF.resignFirstResponder()
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
	
	@IBAction func textDidChangeAction(_ textField: UITextField) {
		validateFields()
	}
	
	func validateFields() {
		if eventNameTF.text == "" || uploadedEventImage.text == "" || eventLocationTF.text == "" {
			createEventButton.isEnabled = false
			createEventButton.alpha = 0.5
		}
		else {
			createEventButton.isEnabled = true
			createEventButton.alpha = 1.0
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
}

extension CreateGroupEventViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imageDict = info
		if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
			uploadedEventImage.text = url.lastPathComponent
		}
		picker.dismiss(animated: true, completion: nil)
		//validateFields()
	}
}
