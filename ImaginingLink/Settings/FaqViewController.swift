//
//  FaqViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 5/17/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

class FAQCell: UITableViewCell {
	@IBOutlet weak var ansTextView: UITextView!
}

class FaqViewController: BaseHamburgerViewController {
	@IBOutlet weak var faqTableview: UITableView!
	var faqsArray: [[String: Any]] = []
	var expandedArray: [Int] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		faqTableview.layer.borderWidth = 1.0
		faqTableview.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		faqTableview.clipsToBounds = true
		addSlideMenuButton(showBackButton: true, backbuttonTitle: "FAQ’s")
		faqTableview.tableFooterView = UIView(frame: CGRect.zero)
		if let url = Bundle.main.url(forResource: "faqs", withExtension: "json") {
			do {
				let data = try Data(contentsOf: url)
				let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				if let dictionary = object as? [String: Any] {
					faqsArray = dictionary["faqs"] as? [[String: Any]] ?? []
					faqTableview.reloadData()
				}
			} catch {
				
			}
		}
        // Do any additional setup after loading the view.
    }
    
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
    }
	
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		self.tabBarController?.tabBar.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FaqViewController: UITableViewDataSource,UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell : FAQCell = tableView.dequeueReusableCell(withIdentifier: "FaqCell", for: indexPath) as! FAQCell
		cell.ansTextView.text = faqsArray[indexPath.section]["ans"] as? String ?? ""
		cell.ansTextView.translatesAutoresizingMaskIntoConstraints = true
		cell.ansTextView.sizeToFit()
		cell.ansTextView.isScrollEnabled = false
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return faqsArray.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if expandedArray.contains(section) {
			return 1
		}
		else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerTitle = faqsArray[section]["que"] as? String ?? ""
		let height = headerTitle.height(withConstrainedWidth: faqTableview.frame.width - 50, font: UIFont(name: "GoogleSans-Medium", size: 14.0)!) + 30
		let view = UIView(frame: CGRect(x: 10, y: 0, width: faqTableview.frame.width - 50, height: height))
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.93, alpha: 1.00).cgColor
		view.clipsToBounds = true
		let label = UILabel(frame: view.frame)
		label.font = UIFont(name: "GoogleSans-Medium", size: 14.0)!
		label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
		label.numberOfLines = 0
		label.text          = headerTitle
		view.addSubview(label)
		let btn = UIButton(type: .custom)
		btn.frame = view.frame
		btn.addTarget(self, action: #selector(expandButtonAction), for: .touchUpInside)
		btn.tag = section
		view.addSubview(btn)
		let plusImage = UIImageView(frame: CGRect(x: faqTableview.frame.width - 30, y: 10, width: 20, height: 20))
		
		if expandedArray.contains(section) {
			plusImage.image = UIImage(named: "minusIcon")
		}
		else {
			plusImage.image = UIImage(named: "plusIcon")
		}
		view.addSubview(plusImage)
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let headerTitle = faqsArray[section]["que"] as? String ?? ""
		return headerTitle.height(withConstrainedWidth: faqTableview.frame.width - 50, font: UIFont(name: "GoogleSans-Medium", size: 14.0)!) + 30
	}
	
	@objc func expandButtonAction(_ sender: UIButton) {
		if expandedArray.contains(sender.tag) {
//			if let index = expandedArray.firstIndex(of: sender.tag) {
//				expandedArray.remove(at: index)
//			}
			expandedArray.removeAll()
		}
		else{
			expandedArray.removeAll()
			expandedArray.append(sender.tag)
		}
		faqTableview.reloadData()
	}
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

//    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//
//        return ceil(boundingBox.width)
//    }
}
