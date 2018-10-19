//
//  PresentationView.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 27/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class PresentationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PresenationTableView: UITableView!
    let presentationArray : [[String:Any]]? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let tableviewcell = tableView.dequeueReusableCell(withIdentifier: "PresentationTableViewCell", for: indexPath) as! PresentationTableViewCell
        tableviewcell.selectionStyle = UITableViewCellSelectionStyle.none
        return tableviewcell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         PresenationTableView.dataSource = self
        PresenationTableView.delegate = self
        addSlideMenuButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ILUtility.addNavigationBarBackToCartButton(controller: self)
        ILUtility.addNavigationBarBackButton(controller: self, userName: UserDefaults.standard.value(forKey: kUserName) as! String, userType: "Radiologist")
    }
    
    
}
