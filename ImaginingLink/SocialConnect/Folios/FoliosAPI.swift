//
//  FoliosAPI.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 3/15/21.
//  Copyright © 2021 Imaginglink Inc. All rights reserved.
//

import Foundation
import Alamofire

class FoliosAPI {
	static let sharedManaged = FoliosAPI()
	
	private init() {
		SSHttpRequest.setbaseUrl(url: kBaseUrl)
	}
	
	func getHeader() -> HTTPHeaders{
		let token = UserDefaults.standard.value(forKey: kToken) as! String
		let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
		return header
	}
	
	func requestFavouriteUnfavoritePost(parameters:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request = SSHttpRequest(withuUrl: kFolioFavouritePost)
		
		request.postMethodWithHeaderasToken(dictParameter: parameters, url: kFolioFavouritePost, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func requestForSaveAllPostLikesEmoji(parameters:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kSaveFolioPostLikesEmoji)
		request.postMethodWithHeaderasToken(dictParameter: parameters, url: kSaveFolioPostLikesEmoji, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
		
	func updateUserGroupStatus(groupId: String,status: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = "\(NSString(format: kUpdateUserFolioGroupStatus as NSString, groupId, status))"
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
}
