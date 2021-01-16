//
//  GroupsAPI.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 11/8/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import Foundation
import Alamofire

class GroupsAPI {
	static let sharedManaged = GroupsAPI()
	
	private init() {
		SSHttpRequest.setbaseUrl(url: kBaseUrl)
	}
	
	func getHeader() -> HTTPHeaders{
		let token = UserDefaults.standard.value(forKey: kToken) as! String
		let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
		return header
	}
	
	func getUserGroups(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kUserGroups)
		request.getMethod(dictParameter: [:], url: kUserGroups, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func createGroup(parameters:[String:Any], filesInfo: [[String:Any]], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		
		let requestUrl = "\(kBaseUrl + kCreateGroup)"
		Alamofire.upload(multipartFormData: { multipartFormData in
			
			for infoDict in filesInfo {
				multipartFormData.append(infoDict["data"] as! Data, withName: "group_logo[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
			}
			for (key, value) in parameters {
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
	
	func getGroupsIdDetails(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = kGroupIdDetails.replacingOccurrences(of: "%@", with: groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func getGroupDiscussions(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
	
		let requestUrl = "\(kBaseUrl + kGroupDiscussions)"
		Alamofire.upload(multipartFormData: { multipartFormData in
							
			for (key, value) in requestDict {
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
	
	func updateGroupDescription(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kUpdateGroupDescription)
		request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kUpdateGroupDescription, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func shareGroup(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kShareGroup)
		request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kShareGroup, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func updateUserGroupStatus(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kUpdateUserGroupStatus)
		request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kUpdateUserGroupStatus, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func getGroupMembers(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = kGetGroupMembers.replacingOccurrences(of: "%@", with: groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func requestReportPost(timeLineID: String,selectedIssue: String,reportedIssue: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kReportTimeLinePost)
		let OTPRequestValues = ["group_id":"","post_id" : timeLineID, "selected_issue": selectedIssue, "reported_issue":reportedIssue]  as [String:Any]
		request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kReportTimeLinePost, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func makeGroupAdminApproveOrRejectRequest(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kGroupAdminApproveOrRejectMember)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kGroupAdminApproveOrRejectMember, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func changeGroupMemberPrivilegeRequest(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kChangeGroupMemberPrivilege)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kChangeGroupMemberPrivilege, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func leaveMemberFromGroupRequest(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kLeaveMemberFromGroup)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kLeaveMemberFromGroup, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func createEventForGroup(parameters:[String:Any], filesInfo: [[String:Any]], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		
		let requestUrl = "\(kBaseUrl + kCreateGroupEvent)"
		Alamofire.upload(multipartFormData: { multipartFormData in
			
			for infoDict in filesInfo {
				multipartFormData.append(infoDict["data"] as! Data, withName: "photo[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
			}
			for (key, value) in parameters {
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
	
	func getUserGroupEventsList(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = kGetGroupEvents.replacingOccurrences(of: "%@", with: groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
}
