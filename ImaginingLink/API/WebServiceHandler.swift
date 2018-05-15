//
//  WebServiceHandler.swift
//  ImaginingLink
//
//  Created by Prathibha Sundresh on 5/25/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import UIKit
import Alamofire

@objc class WebServiceHandler : NSObject {
    
    private static var manager: Alamofire.SessionManager = {
        
//        // Create the server trust policies
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "https://stage-api.ufs.com": .disableEvaluation,"https://52.19.87.124:9002": .disableEvaluation,
//            "https://52.31.80.240:51002":.disableEvaluation
//        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManagerForDevelop()
        )
        
        return manager
    }()
    
    private class ServerTrustPolicyManagerForDevelop: ServerTrustPolicyManager {
        
        init() {
            super.init(policies: [:])
        }
        
        override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return .disableEvaluation
        }
    }
    
    func POSTRequest(dictParameter:[String:Any], header:HTTPHeaders?, requestURL:String,success:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: dictParameter, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:Any] {
                
                let requestHeader = header
                
                WebServiceHandler.manager.request("\(requestURL)", method: .post, parameters: dictFromJSON, encoding: JSONEncoding.default, headers: requestHeader)
                    .responseJSON { response in
                        print(response.request as Any)  // original URL request
                        print(response.result.value as Any)   // result of response serialization
                        if response.response?.statusCode == 200{
                            success((response.result.value)! as AnyObject)
                        }else if (response.response?.statusCode == 400){
                            faliure("server Issue")
                        }
                        
                }
            }
        } catch {
            print(error.localizedDescription)
            faliure("error")
        }
    }
        
}
