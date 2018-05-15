//
//  DashBoardViewController.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 24/07/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit

class DashBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    let Cases = 0
    let Quiz = 1
    let Portfolio = 2
    let SocialConnect = 3
    let Presentation = 4
    
    let titleList : [String] = ["CASES", "QUIZ", "PORTFOLIO", "SOCIAL CONNECT", "PRESENTATION"]
    let imageName : [String] = ["CasesIcon", "QuizIcon", "PortPolioIcon", "SocialNetWorkLogo", "PresentationLogo"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! DashBoardCollectionViewCell
        cell.ToDisplayContent(imageName: imageName[indexPath.row], title: titleList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionCellSize = collectionView.frame.size.width  / 2
        
        return CGSize(width: collectionCellSize, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == Presentation {
            let storyboard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PresentationViewController") as! PresentationViewController
            self.navigationController?.pushViewController(vc, animated: true)
            CoreAPI.sharedManaged.getPublicUserPresentation(successResponse: {(response) in
                
            }, faliure: {(error) in
                
            })
        }
        //
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
         collectionView?.contentInsetAdjustmentBehavior = .always
        self.collectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
