//
//  ListView.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 13/06/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

protocol UserTypeDelegate {
    func selectedUserType(userType: String, indexRow: Int)
}

class ListViewController: UITableViewController {

    var delegate:UserTypeDelegate?
    var listValue : [String] = []
    var filteredArray : [String] = []
    var MobilevVerification : [String] = []
    var selectedIndexValue = ""
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedUserType(userType: filteredArray[indexPath.row],indexRow: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListId", for: indexPath) as! ListViewTableViewCell
        cell.ListLabel?.text = filteredArray[indexPath.row]
        if cell.ListLabel?.text != "" {
            if selectedIndexValue == filteredArray[indexPath.row]{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredArray.count
    }
    
}
extension ListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != ""{
            filteredArray = listValue.filter { (str) -> Bool in
                return str.contains(searchText)
            }
            self.tableView.reloadData()
        }
    }
}
