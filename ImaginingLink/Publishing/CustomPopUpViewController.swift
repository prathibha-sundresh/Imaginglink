//
//  CustomPopUpViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 10/29/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit

class CustomPopUpViewController: UIViewController {

    var titleArray : [String] = []
    var callBack: ((String) -> Void)?
    var selectedRowTitle: String = ""
    @IBOutlet weak var titleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
            callback(selectedRowTitle)
        }
        self.dismiss(animated: false, completion: nil)
    }
}

extension CustomPopUpViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(titleArray[indexPath.row])"
        if selectedRowTitle == titleArray[indexPath.row] {
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
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowTitle = "\(titleArray[indexPath.row])"
        titleTableView.reloadData()
    }
}
