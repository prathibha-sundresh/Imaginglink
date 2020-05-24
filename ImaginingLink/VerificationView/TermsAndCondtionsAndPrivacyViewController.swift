//
//  TermsAndCondtionsAndPrivacyViewController.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 9/9/19.
//  Copyright © 2019 Imaginglink Inc. All rights reserved.
//

import UIKit
import WebKit

class TermsAndCondtionsAndPrivacyViewController: UIViewController, WKNavigationDelegate {
    var isClickedFrom = ""
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
		let fileName = isClickedFrom == "Terms & Conditions" ? "Terms and Conditions" : "Privacy Policy"
		if let filePath = Bundle.main.url(forResource: fileName, withExtension: "pdf", subdirectory: nil, localization: nil)  {
		  let req = NSURLRequest(url: filePath)
			webView.load(req as URLRequest)
		}
		webView.allowsBackForwardNavigationGestures = true
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
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        ILUtility.showProgressIndicator(controller: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ILUtility.hideProgressIndicator(controller: self)
    }
}
