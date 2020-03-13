//
//  CustomPopUpViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/29/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class CustomPopUpViewController: UIViewController {
	enum SelectionType {
		case Single
		case Multiple
		case None
	}
	enum SectionType {
		case Section
		case SubSection
		case AddCoAuthors
		case None
	}
    var titleArray : [String] = []
	var filteredArray : [String] = []
    var callBack: (([String]) -> Void)?
	var selectedRowTitles: [String] = []
	var selectionType: SelectionType = SelectionType.None
	var sectionType: SectionType = SectionType.None
	@IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var titleTableView: UITableView!
	@IBOutlet weak var searchTFConstraintH: NSLayoutConstraint!
	@IBOutlet weak var applyButton: UIButton!
	var isCoAuthor = false
    override func viewDidLoad() {
        super.viewDidLoad()
		titleTableView.tableFooterView = UIView(frame: .zero)
		applyButton.layer.borderWidth = 1.0
		applyButton.layer.borderColor = UIColor.white.cgColor
		filteredArray = titleArray
		searchTFConstraintH.constant = isCoAuthor ? 34: 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func applyButtonAction(_ sender: UIButton) {
        if let callback = callBack {
            callback(selectedRowTitles)
        }
        self.dismiss(animated: false, completion: nil)
    }
	
	@IBAction func textDidchange(_ textField: UITextField) {
		
		if let searchText = textField.text, searchText.count >= 3{
			filteredArray = titleArray.filter { (str) -> Bool in
				return str.contains(searchText)
			}
		}
		else{
			filteredArray = titleArray
		}
		titleTableView.reloadData()
	}
}

extension CustomPopUpViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		if filteredArray[indexPath.row] != "New to Old" && filteredArray[indexPath.row] != "Old to New" {
			cell.textLabel?.text = "\(filteredArray[indexPath.row])".capitalized
		}
		else{
			cell.textLabel?.text = "\(filteredArray[indexPath.row])"
		}
		if selectedRowTitles.contains(filteredArray[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		switch selectionType {
		case .Single:
			selectedRowTitles.removeAll()
			selectedRowTitles.append(filteredArray[indexPath.row])
		case .Multiple:
			
			if selectedRowTitles.contains(filteredArray[indexPath.row]) {
				if let index = selectedRowTitles.firstIndex(of: filteredArray[indexPath.row]){
					selectedRowTitles.remove(at: index)
				}
			}
			else{
				if sectionType == SectionType.AddCoAuthors {
					if selectedRowTitles.count >= 5 {
						return
					}
				}
				selectedRowTitles.append(filteredArray[indexPath.row])
			}
		case .None:
			print("None")
		}
        titleTableView.reloadData()
    }
}
