//
//  SSHttpRequest.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/8/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import Alamofire

class SSHttpRequest {
    var requestUrl : String?
    var request : URLRequest?
    static var baseURL : String?
    
    class func setbaseUrl(url:String) {
        baseURL = url
    }
    
    func postWithBody(body:Any) -> Void {
        setBody(body: body)
        invokeResponseWithMethod(method: "POST")
        
    }
    
    func invokeResponseWithMethod(method:String) -> Void {
        self.request?.httpMethod = method
//        aSynchronousMethod()
    }
    
    func setBody(body:Any) -> Void {
        request!.httpBody = try? JSONSerialization.data(withJSONObject: body, options:.prettyPrinted)
    }
    
    init(withuUrl:String) {
        
        var formattedURL:String = withuUrl
        
        if(!formattedURL.hasPrefix("https")) {
            formattedURL = (SSHttpRequest.baseURL!.appending(formattedURL))
            guard let requestUrl = URL(string:formattedURL) else {
                return
            }
            request = URLRequest(url: requestUrl)
            request!.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    func postMethodWithHeaderasToken(dictParameter:[String:Any], url : String,header:HTTPHeaders, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void)  {
        let webServiceHandler:WebServiceHandler = WebServiceHandler()

        webServiceHandler.POSTRequest(dictParameter: dictParameter, header: header, requestURL: (SSHttpRequest.baseURL?.appending(url))!, success: {(response) in
        successResponse(response)
       }, faliure: {(Error) in
        faliure(Error)
       })
    }
    
    func postMethod(dictParameter:[String:Any], url : String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void)  {
        let webServiceHandler:WebServiceHandler = WebServiceHandler()
        
        let header : HTTPHeaders = ["Accept" : "application/json"]
        
        webServiceHandler.POSTRequest(dictParameter: dictParameter, header: header, requestURL: (SSHttpRequest.baseURL?.appending(url))!, success: {(response) in
            successResponse(response)
        }, faliure: {(Error) in
            faliure(Error)
        })
    }

    func getMethodWithOutHeader(url : String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void)  {
        let webServiceHandler:WebServiceHandler = WebServiceHandler()
        
        webServiceHandler.GETRequestWithOutHeader(requestParameter: (SSHttpRequest.baseURL?.appending(url))!, methodName: "GET", header: nil, success: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            
        })
    }
        
    
    func getMethod(dictParameter:[String:Any], url : String,_ isEncodedUrl : Bool = false, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void)  {
        let webServiceHandler:WebServiceHandler = WebServiceHandler()
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)","Accept" : "application/json"]
        
        webServiceHandler.GETRequest(requestParameter: (SSHttpRequest.baseURL?.appending(url))!, methodName: "GET", isEncodedUrl ,header: header, success: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            
        })
        
        
//        webServiceHandler.POSTRequest(dictParameter: dictParameter, header: header, requestURL: (SSHttpRequest.baseURL?.appending(url))!, success: {(response) in
//            successResponse(response)
//        }, faliure: {(Error) in
//            faliure(Error)
//        })
    }
}
