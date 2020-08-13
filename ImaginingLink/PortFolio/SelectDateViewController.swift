//
//  SelectDateViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/9/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController {

	@IBOutlet weak var datePicker: UIDatePicker!
	var selectedDate = Date()
	var callBack: ((String, String, String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }

	@IBAction func datePickerChanged(_ sender: Any) {
		selectedDate = datePicker.date
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func datePickerCancelORDoneAction(_ sender: UIButton) {
		if sender.tag == 100 {
			let components = Calendar.current.dateComponents([.day, .year, .month], from: selectedDate)
			let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMMM")
			let day = "\(components.day!)"
			let month = df.string(from: selectedDate)
			let year = "\(components.year!)"
			if let callback = callBack {
				callback(day,month,year)
			}
		}
		self.dismiss(animated: false, completion: nil)
	}
}
