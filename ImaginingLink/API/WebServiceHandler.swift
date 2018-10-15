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
                            success((response.result.value) as AnyObject)
                        }else if (response.response?.statusCode == 400){
                            faliure("server Issue")
                        } else if (response.response?.statusCode == 422) {
                            faliure("The mobile has already been taken")
                        }
                        
                }
            }
        } catch {
            print(error.localizedDescription)
            faliure("error")
        }
    }
    
    func GETRequest(requestParameter:String,methodName:String,  header:HTTPHeaders?, success:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void)   {
        
        let requestHeader = ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as! String)"]
        
        let requestURL:String? = requestParameter
        
        
        WebServiceHandler.manager.request(requestURL!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header!)
            .responseString { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                let dictResponse = response
                if  response.response?.statusCode == 200{
                    
                    //print(response.result.value!)   // result of response serialization
                    
                    
                   
                        success( response.result.value! as AnyObject)
                        return
                    }
                    /*****
                     *** PARSE RESPONSE OF GET LOYALTY POINTS API
                     ******/
                    
                
                    
                    guard let responeString : String = response.result.value else {
                        faliure("error")
                        return
                    }
                    
                    
                
                    
                    success( dictResponse as AnyObject)
                }
//        else{
//
//
//                    if let responseMessage = dictResponse["code"]{
//                        print(responseMessage)
//                        faliure(responseMessage as! String)
//                    }else{
//                        faliure("error")
//                    }
//
//
//                }
        
        }
    
    func GETRequestWithOutHeader(requestParameter:String,methodName:String,  header:HTTPHeaders?, success:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessageCode:String) -> Void)   {
        
//        let requestHeader = ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: kToken) as! String)"]
        
        let requestURL:String? = requestParameter
        
        
        WebServiceHandler.manager.request(requestURL!, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: nil)
            .responseString { response in
                print(response.request as Any)  // original URL request
                print(response.response as Any) // URL response
                print(response.result.value as Any)   // result of response serialization
                if  response.response?.statusCode == 200{
                    success( response.result.value! as AnyObject)
                    return
                }
               
                guard let responeString = response.result.value else {
                    faliure("error")
                    return
                }
                success( responeString as AnyObject)
        }
    
        
    }
        
    }
        

