//
//  AddAdditionalInterestsTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/12/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class AddAdditionalInterestsTableViewCell: UITableViewCell {
	@IBOutlet weak var addAdditionalInterestsTF: FloatingLabel!
	@IBOutlet weak var recreationalInterestsCV: UICollectionView!
	var delegate: AddSectionTvCellDelegate?
	var recreationalInterests: [String] = []
	var post_id: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI(dict: [String : Any]) {
		let recreationalInterestsDict = dict["recreational_interests"] as? [String: Any] ?? [:]
		recreationalInterestsDict.keys.count == 0 ? (post_id = "") : (post_id = dict["_id"] as? String ?? "")
		addAdditionalInterestsTF.text = ""
		let dataDict = recreationalInterestsDict["data"] as? [String: Any] ?? [:]
		recreationalInterests = dataDict["recreational_interests"] as? [String] ?? []
		recreationalInterestsCV.reloadData()
	}
	@objc func removeCreationalInterest(_ sender: UIButton){
		recreationalInterests.remove(at: sender.tag)
		//self.isSubSectionEmpty = self.selectedSubsections.isEmpty ? true : false
		addOrRemoveRecreationalInterests(isAddMode: false)
		//recreationalInterestsCV.reloadData()
	}
	
	func addOrRemoveRecreationalInterests(isAddMode: Bool) {
		var tmpArray = recreationalInterests
		if isAddMode {
			tmpArray.append(addAdditionalInterestsTF.text!)
		}
		
		var requestDict = ["type" : "recreational_interests"]
		for i in 0 ..< tmpArray.count {
			requestDict["post_data[recreational_interests][\(i)]"] = "\(tmpArray[i])"
		}
		if post_id != "" {
			requestDict["post_id"] = post_id
		}
		delegate?.addSection(dict: requestDict)
	}
	
	@IBAction func addInterestsButtonAction(_ sender: UIButton) {
		if addAdditionalInterestsTF.text! != "" {
			addOrRemoveRecreationalInterests(isAddMode: true)
		}
	}
}

extension AddAdditionalInterestsTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! KeywordsCVCell
		cell.nameButton.tag = indexPath.item
        cell.nameButton.setTitle("    \(recreationalInterests[indexPath.item])   ✕    ", for: .normal)
		cell.nameButton.addTarget(self, action: #selector(removeCreationalInterest), for: .touchUpInside)
		cell.nameButton.layer.borderWidth = 1.0
        cell.nameButton.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
        cell.nameButton.layer.cornerRadius = 4.0
        cell.nameButton.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recreationalInterests.count
    }
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ("    \(recreationalInterests[indexPath.item])    ✕    ").size(withAttributes: nil)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}
