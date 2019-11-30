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
        if isClickedFrom == "Terms & Conditions"{
            let url = URL(string: termsandconditionUrl)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        else{
            let url = URL(string: privacyPolicyUrl)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
       // perform(#selector(loadWebView), with: nil, afterDelay: 1.0)
        
        // Do any additional setup after loading the view.
    }
    @objc func loadWebView(){
        
        
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
        print("Start loading")
        ILUtility.showProgressIndicator(controller: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading")
        ILUtility.hideProgressIndicator(controller: self)
    }
}
