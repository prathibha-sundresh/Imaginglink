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
	enum SelectionLimit: Int {
		case Limit
	}
    var titleArray : [String] = []
    var callBack: (([String]) -> Void)?
	var selectedRowTitles: [String] = []
	var selectionType: SelectionType = SelectionType.None
	
    @IBOutlet weak var titleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
		titleTableView.tableFooterView = UIView(frame: .zero)
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
    @IBAction func closeButtonAction(_ sender: UIButton) {
        if let callback = callBack {
            callback(selectedRowTitles)
        }
        self.dismiss(animated: false, completion: nil)
    }
}

extension CustomPopUpViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = "\(titleArray[indexPath.row])".capitalized
		if selectedRowTitles.contains(titleArray[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
		switch selectionType {
		case .Single:
			selectedRowTitles.removeAll()
			selectedRowTitles.append(titleArray[indexPath.row])
		case .Multiple:
			
			if selectedRowTitles.contains(titleArray[indexPath.row]) {
				if let index = selectedRowTitles.firstIndex(of: titleArray[indexPath.row]){
					selectedRowTitles.remove(at: index)
				}
			}
			else{
				if selectedRowTitles.count >= 5 {
					return
				}
				selectedRowTitles.append(titleArray[indexPath.row])
			}
		case .None:
			print("None")
		}
        titleTableView.reloadData()
    }
}
