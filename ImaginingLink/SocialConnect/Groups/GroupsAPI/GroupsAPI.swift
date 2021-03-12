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
	
	func storeEventRSVP(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kStoreEventRSVP)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kStoreEventRSVP, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func deleteGroupEventRSVP(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kDeleteGroupEvent)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kDeleteGroupEvent, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func getGroupEventDetail(groupId: String, eventId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = String(format: kGroupEventDetail, groupId, eventId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func sendEventInvitation(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kSendEventInvitation)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kSendEventInvitation, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func updateGroupEvent(parameters:[String:Any], filesInfo: [[String:Any]],fileExists: Bool, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		
		let requestUrl = "\(kBaseUrl + kUpdateGroupEvent)"
		Alamofire.upload(multipartFormData: { multipartFormData in
			if !fileExists {
				for infoDict in filesInfo {
					multipartFormData.append(infoDict["data"] as! Data, withName: "new_photo[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
				}
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
	
	func getGroupGetAllResources(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = String(format: kGetAllResources, groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func createOrUpdateGroupResourcesFolder(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kCreateOrUpdateResourcesFolder)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kCreateOrUpdateResourcesFolder, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func deleteGroupResourcesFolder(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kDeleteResourceFolder)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kDeleteResourceFolder, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func AddYouTubeUrlToGroupResourcesFolder(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kAddYouTubeUrlResource)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kAddYouTubeUrlResource, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func deleteFileFromFolder(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kDeleteResourceFile)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kDeleteResourceFile, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func uploadResourceFilesToFolder(parameters:[String:Any], filesInfo: [[String:Any]], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		
		let requestUrl = "\(kBaseUrl + kUploadResourceFiles)"
		Alamofire.upload(multipartFormData: { multipartFormData in
			
			for infoDict in filesInfo {
				multipartFormData.append(infoDict["data"] as! Data, withName: "resource_files[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
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
	
	func getGroupManagePosts(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = String(format: kManagePosts, groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func approvePost(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kApproveGroupPost)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kApproveGroupPost, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func rejectPost(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kRejectGroupPost)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kRejectGroupPost, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func createOrUpdateGroupPoll(parameterDict: [String: Any], isUpdate: Bool, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		
		let requestUrl = "\(kBaseUrl + ((isUpdate == true) ? kUpdateGroupPoll : kCreateGroupPoll))"
		Alamofire.upload(multipartFormData: { multipartFormData in
			for (key, value) in parameterDict {
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
	
	func getLoadAllGroupPolls(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = String(format: kLoadAllGroupPolls, groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func getLoadActiveGroupPolls(groupId: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = String(format: kLoadActiveGroupPolls, groupId)
		let request =  SSHttpRequest(withuUrl: url)
		request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func deleteGroupPoll(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kDeleteGroupPoll)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kDeleteGroupPoll, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func storeUserOpinionGroupPoll(parameterDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request =  SSHttpRequest(withuUrl: kStoreUserOpinionGroupPoll)
		request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: kStoreUserOpinionGroupPoll, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
}

