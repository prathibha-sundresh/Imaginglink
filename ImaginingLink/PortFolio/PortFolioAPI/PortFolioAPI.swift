//
//  PortFolioAPI.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 8/1/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import Foundation
import Alamofire

class PortFolioAPI {
	static let sharedManaged = PortFolioAPI()
    
    private init() {
        SSHttpRequest.setbaseUrl(url: kBaseUrl)
	}
	
	func getHeader() -> HTTPHeaders{
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        return header
    }
	
	func getPortFolioBasicDetails(type: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kPortFolioBasicDetails)
		let finalUrl = String(format: kPortFolioBasicDetails, type)
        request.getMethod(dictParameter: [:], url: finalUrl, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func addPortFolioDetails(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		
		let requestUrl = "\(kBaseUrl + kAddPortFolioDetails)"
		Alamofire.upload(multipartFormData: { multipartFormData in
			var isFileAdded = false
			if let url = requestDict["source_file_name[]"] as? URL {
				var urlConvertedData: Data?
				do {
					urlConvertedData = try Data(contentsOf: url)
				} catch {
					print(error)
				}
				if let data = urlConvertedData {
					let mimeType = (url.pathExtension == "pdf") ? "application/pdf" : "application/vnd"
					multipartFormData.append(data, withName: "source_file_name[]", fileName: url.lastPathComponent, mimeType: mimeType)
					isFileAdded = true
				}
			}
			for (key, value) in requestDict {
				if key == "source_file_name[]" && isFileAdded{
					continue
				}
				multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
			}},to: requestUrl, headers: getHeader())
		{ (result) in
			switch result {
			case .success(let upload, _, _):
				upload.responseJSON { response in
					successResponse(response.result.value as AnyObject)
				}
			case .failure(let error):
				faliure("\(error)")
			}
		}
	}
	
	func getPortFolioDetails(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kPortFolioDetails)
        request.getMethod(dictParameter: [:], url: kPortFolioDetails, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func deletePortFolioDetails(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kDeletePortfolioDetails)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kDeletePortfolioDetails, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
}
