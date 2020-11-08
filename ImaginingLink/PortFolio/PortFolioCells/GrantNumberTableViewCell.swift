//
//  GrantNumberTableViewCell.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/21/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol GrantNumberTableViewCellDelegate {
	func removeGrantNumber(at Index: Int)
	func saveDetails(cell: GrantNumberTableViewCell)
}

class GrantNumberTableViewCell: UITableViewCell {
	@IBOutlet weak var textField1: FloatingLabel!
	@IBOutlet weak var textField2: FloatingLabel!
	@IBOutlet weak var removeButton: UIButton!
	var delegate: GrantNumberTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setUI(dict : [String: Any]) {
		textField1.text = dict["grantnumber"] as? String ?? ""
		textField2.text = dict["granturl"] as? String ?? ""
	}
	
	@IBAction func removeGrantButtonAction(_ sender: UIButton) {
		delegate?.removeGrantNumber(at: sender.tag)
	}
	
	@IBAction func textDidChange(_ textField: UITextField) {
		delegate?.saveDetails(cell: self)
	}
}
