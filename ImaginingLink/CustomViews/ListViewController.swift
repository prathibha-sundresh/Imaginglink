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
    var MobilevVerification : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(ListViewTableViewCell.self, forCellReuseIdentifier: "ListId")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        delegate?.selectedUserType(userType: listValue[indexPath.row],indexRow: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListId", for: indexPath) as! ListViewTableViewCell
        cell.textLabel?.text = listValue[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return listValue.count
    }
}
