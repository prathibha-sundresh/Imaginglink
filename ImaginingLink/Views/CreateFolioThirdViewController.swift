//
//  CreateFolioThirdViewController.swift
//  ImaginingLink
//
//  Created by prathibha sundresh on 01/07/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import UIKit

enum SectionNumber : Int {
    case FirstSection = 0
    case SecondSection = 1
    case ThirdSection = 2
}

class CreateFolioThirdViewController: BaseHamburgerViewController {
    
    @IBOutlet weak var stepProgressView:StepProgressView!
    @IBOutlet weak var tableView:UITableView!
    
    var socialMediaUrl : SocialMediaURLDisplayView!
    
    var numberOfHighLightedURL : [HightLightURLData] = [HightLightURLData]()
    var hightedURLString : [String] = [String]()
    var numberOfURl:[SocialMediaURLData] = [SocialMediaURLData]()
    var socialurl : [String] = [String]()
    var folioDicModel : [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HIghtlightesHeaderView.self, forHeaderFooterViewReuseIdentifier: "HIghtlightesHeaderViewID")
        addSlideMenuButton(showBackButton: true,backbuttonTitle: "CreateFolio")
        stepProgressView.setProgressStep(stepsValue: progressStep.ThirdStep.rawValue)
        // Do any additional setup after loading the view.
        intialData()
    }
    
    func intialData() {
        numberOfHighLightedURL.append(HightLightURLData(highLightedURL: " "))
        hightedURLString.append(" ")
        numberOfURl.append(SocialMediaURLData(url: "www.facebook.com", socialMediaIconName: "Icon_FaceBook"))
        numberOfURl.append(SocialMediaURLData(url: "www.twitter.com", socialMediaIconName: "Icon_twitter"))
        numberOfURl.append(SocialMediaURLData(url: "www.linkedin.com", socialMediaIconName: "Icon_Linkedln"))
        numberOfURl.append(SocialMediaURLData(url: "www.instragram.com", socialMediaIconName: "Icon_InstaGram"))
        socialurl.append("www.facebook.com")
        socialurl.append("www.twitter.com")
        socialurl.append("www.linkedin.com")
        socialurl.append("www.instragram.com")
    }
}


//TableView Delegates
extension CreateFolioThirdViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionNumber.FirstSection.rawValue:
            return numberOfHighLightedURL.count
        case SectionNumber.SecondSection.rawValue:
            return numberOfURl.count
        case SectionNumber.ThirdSection.rawValue:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableViewCell = UITableViewCell()
        switch indexPath.section {
        case SectionNumber.FirstSection.rawValue:
            let hightLighturltableViewCell : HighLightedURLTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HightLightURLId", for: indexPath) as! HighLightedURLTableViewCell
            hightLighturltableViewCell.deleteButton.tag = indexPath.row
            hightLighturltableViewCell.delegate = self
            hightLighturltableViewCell.textField.tag = indexPath.row
            tableViewCell = hightLighturltableViewCell
        case SectionNumber.SecondSection.rawValue:
            let urlDisplaytableViewCell = tableView.dequeueReusableCell(withIdentifier: "URLDisplayID", for: indexPath) as! URLDisplayTableViewCell
            urlDisplaytableViewCell.deleteButton.tag = indexPath.row
            urlDisplaytableViewCell.delegate = self
            urlDisplaytableViewCell.textField.tag = indexPath.row
            urlDisplaytableViewCell.callIconImage(data:numberOfURl[indexPath.row])
            tableViewCell = urlDisplaytableViewCell
        case SectionNumber.ThirdSection.rawValue:
            let createFolioButton = tableView.dequeueReusableCell(withIdentifier: "CreateFolioButtonTableViewCellID", for: indexPath) as! CreateFolioButtonTableViewCell
            createFolioButton.delegate = self
            tableViewCell = createFolioButton
        default:
            return tableViewCell
        }
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionNumber.FirstSection.rawValue:
            return 60
        case SectionNumber.SecondSection.rawValue:
            return 60
        case SectionNumber.ThirdSection.rawValue:
            return 120
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 { return UIView()}
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HIghtlightesHeaderViewID") as? HIghtlightesHeaderView
        headerView?.contentView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        headerView!.callHeaderView(WithSection: section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 { return UIView()}
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HIghtlightesHeaderViewID") as? HIghtlightesHeaderView
        footerView?.contentView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        footerView?.addMoreDelegate = self
        footerView!.callFooterView(withSection: section)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SectionNumber.ThirdSection.rawValue { return 0}
        return section == SectionNumber.FirstSection.rawValue ? 100 : 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == SectionNumber.ThirdSection.rawValue { return 0}
        return 70
    }
    
}

extension CreateFolioThirdViewController : AddMoreRowsDelegates {
    
    
    func AddFieldForHightLightURL() {
        if numberOfHighLightedURL.count == 5 { return }
        
        numberOfHighLightedURL.append(HightLightURLData(highLightedURL: ""))
        hightedURLString.append("")
        tableView!.insertRows(at: [IndexPath(row: numberOfHighLightedURL.count-1, section: 0)], with: .bottom)
        tableView!.reloadRows(at:  [IndexPath(row: numberOfHighLightedURL.count-1, section: 0)], with: .bottom)
    }
    
    func AddMoreForURL() {
        callMoreSocialMedia()
    }
    
    func callMoreSocialMedia() {
        socialMediaUrl = SocialMediaURLDisplayView(frame: CGRect(x: 0, y: self.view.frame.height - 318, width: self.view.frame.width, height: 318.0))
        socialMediaUrl.delegate = self
        self.view.addSubview(socialMediaUrl)
    }
    
}

extension CreateFolioThirdViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if socialMediaUrl != nil {
            socialMediaUrl.removeFromSuperview()
        }
    }
}

extension CreateFolioThirdViewController :socialMediaDataDelegate {
    func getSocialMediaData(withData: SocialMediaURLData) {
        socialMediaUrl.removeFromSuperview()
        numberOfURl.append(withData)
        socialurl.append(withData.url)
        tableView.insertRows(at: [IndexPath(row: numberOfURl.count-1, section: 1)], with: .middle)
        tableView!.reloadRows(at:  [IndexPath(row: numberOfURl.count-1, section: 1)], with: .bottom)
    }
    func fetchSocialURLTextFieldData(text: String, rowIndex: Int) {
        socialurl[rowIndex] = text
    }
}

extension CreateFolioThirdViewController: deleteURLProtocol, deleteHightLightURLProtocol {
    func deleteUrl(indexRow: Int) {
        numberOfURl.remove(at: indexRow)
        socialurl.remove(at: indexRow)
        tableView!.deleteRows(at: [IndexPath(row: indexRow, section: 1)], with: .middle)
        tableView.reloadSections(IndexSet(integer: SectionNumber.SecondSection.rawValue), with: .none)
    }
    
    func deleteHightedUrl(indexRow: Int) {
        numberOfHighLightedURL.remove(at: indexRow)
        hightedURLString.remove(at: indexRow)
        tableView!.deleteRows(at: [IndexPath(row: indexRow, section: 0)], with: .middle)
        tableView.reloadSections(IndexSet(integer: SectionNumber.FirstSection.rawValue), with: .none)
    }
    
    func fetchTextFieldData(text: String, rowIndex: Int) {
        hightedURLString[rowIndex] = text
    }
}

extension CreateFolioThirdViewController: callBackForCreateFolio {
    func CreateFolioPressed() {
        do {
            ILUtility.showProgressIndicator(controller: self)
            if numberOfHighLightedURL.count == 0 || numberOfURl.count == 0{
                ILUtility.showAlert(message: "Please Enter the Highted or socialmedia URL URL", controller:self)
                return
            }
            folioDicModel["folio_data[highlight_urls][]"] = hightedURLString
            folioDicModel["folio_data[social_media_data][]"] = socialurl
            
            CoreAPI.sharedManaged.callCreateFolio(withData: folioDicModel, successResponse: {(data, statusCode) in
                if statusCode == 200 {
                    ILUtility.hideProgressIndicator(controller: self)
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
                } else if statusCode == 400 {
                    ILUtility.hideProgressIndicator(controller: self)
                    ILUtility.showAlertWithCallBack(message: "Token Expired ,Please login again", controller: self, success: {() in
                        CoreAPI.sharedManaged.logOut()
                    })
                } else if statusCode ==  401 {
                    ILUtility.hideProgressIndicator(controller: self)
                    let value = data as! [String:Any]
                    ILUtility.showAlertWithCallBack(message: value["message"] as! String, controller: self, success: {() in
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        
                    })
                } else if statusCode == 500 {
                    ILUtility.hideProgressIndicator(controller: self)
                    let value = data as! [String:Any]
                    ILUtility.showAlertWithCallBack(message: value["message"] as! String, controller: self, success: {() in
                        
                    })
                } else {
                    ILUtility.hideProgressIndicator(controller: self)
                    let value = data as! [String:Any]
                    ILUtility.showAlertWithCallBack(message: value["message"] as! String, controller: self, success: {() in
                        
                    })
                }
            }, faliure: {(error) in
            })
        } 
        
    }
    
    func BackPressed() {
        self.navigationController?.popViewController(animated: false)
    }
    
}
