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
        if isClickedFrom == "Terms And Conditions"{
            let url = URL(string: "http://52.39.123.104/terms-conditions")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        else{
            let url = URL(string: "http://52.39.123.104/dev/privacy-policy")!
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
