//
//  UploadedFilesViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 6/10/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit
import Alamofire

class UploadedFilesViewController: UIViewController {
	@IBOutlet weak var filesTableView: UITableView!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	var dataDict: [String: Any] = [:]
	var attachments: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
		profileImageView.setUpProfileImage()
		
		if let userDetails = dataDict["user_details"] as? [String: Any] {
			let image = userDetails["profile_picture"] as? String ?? ""
			profileImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "profileIcon"))
			let firstName = userDetails["first_name"] as? String ?? ""
			let lastName = userDetails["last_name"] as? String ?? ""
			nameLabel.text = firstName + " " + lastName
		}
		
		if let details = dataDict["details"] as? [String: Any] {
			let msgID = details["message_id"] as? String ?? ""
			if let tmpArray = details["attachments"] as? [[String: Any]] {
				attachments = tmpArray.map { (dict) -> String in
					let name = dict["name"] as? String ?? ""
					return "\(kImageAndFileBaseUrl)\(msgID)/\(name)"
				}
			}
			filesTableView.reloadData()
		}
        // Do any additional setup after loading the view.
    }
    
	override func viewDidAppear(_ animated: Bool) {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	@IBAction func backButtonAction(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: false)
	}
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if segue.identifier == "TermsAndConditionsPolicyID"{
            let vc: TermsAndCondtionsAndPrivacyViewController = segue.destination as! TermsAndCondtionsAndPrivacyViewController
			self.navigationController?.isNavigationBarHidden = false
			vc.urlPath = URL(string: sender as? String ?? "")
        }
    }
    
	@objc func menuButtonAction(_ sender: UIButton) {
		let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
		let viewFileAction = UIAlertAction(title: "View File", style: .default, handler: { (action) -> Void in
			self.viewFile(from: self.attachments[sender.tag])
        })
		let image1 = UIImage(named: "viewFile_icon")
        viewFileAction.setValue(image1?.withRenderingMode(.alwaysOriginal), forKey: "image")
		let downloadAction = UIAlertAction(title: "Download File", style: .default, handler: { (action) -> Void in
			self.download(from: self.attachments[sender.tag])
        })
		let image2 = UIImage(named: "fileDownload_icon")
        downloadAction.setValue(image2?.withRenderingMode(.alwaysOriginal), forKey: "image")
		viewFileAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		downloadAction.setValue(UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0), forKey: "titleTextColor")
		actionsheet.addAction(viewFileAction)
		actionsheet.addAction(downloadAction)
		actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
		self.present(actionsheet, animated: true, completion: nil)
	}
	
    func download(from url: String) {
		ILUtility.showProgressIndicator(controller: self)
		ILUtility.createDirectory()
        Alamofire.request("\(url)").downloadProgress(closure : { (progress) in
			//print(progress.fractionCompleted)
		}).responseData{ (response) in
			
			if let data = response.result.value {
				ILUtility.hideProgressIndicator(controller: self)
				let array = url.components(separatedBy: "/")
				let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
				let destinationFileUrl = documentsUrl.appendingPathComponent(array.last!)
				do {
					try data.write(to: destinationFileUrl)
				} catch {
					print("Something went wrong!")
				}
				ILUtility.showAlert(message: "File is downloaded", controller: self)
			}
		}
    }
	
	func viewFile(from url: String) {
		self.performSegue(withIdentifier: "TermsAndConditionsPolicyID", sender: url)
    }
}

extension UploadedFilesViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageTableViewCellID", for: indexPath) as! AddImageTableViewCell
		cell.setUIForUploadedFile(urlStr: attachments[indexPath.row])
		cell.deleteButton.tag = indexPath.row
		cell.deleteButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return attachments.count
	}
}

extension UIImageView{
	func setUpProfileImage() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}
