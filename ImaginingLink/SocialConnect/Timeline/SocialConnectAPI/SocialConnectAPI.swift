//
//  SocialConnectAPI.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 5/28/20.
//  Copyright © 2020 Imaginglink Inc. All rights reserved.
//

import Foundation
import Alamofire

class SocialConnectAPI {
    static let sharedManaged = SocialConnectAPI()
    
    private init() {
        SSHttpRequest.setbaseUrl(url: kBaseUrl)
	}
	
	func getHeader() -> HTTPHeaders{
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        return header
    }
	
	func getTimelineData(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: KUserTimelineData)
        request.getMethod(dictParameter: [:], url: KUserTimelineData, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func getMyWall(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kMyWallPosts)
        request.getMethod(dictParameter: [:], url: kMyWallPosts, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func requestForSaveAllPostLikesEmoji(timeLineID: String, likeUnLikeValue: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kSaveAllPostLikesEmoji)
        let requestValues = ["timeline_id" : timeLineID, "like_emoji": likeUnLikeValue ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: requestValues, url: kSaveAllPostLikesEmoji, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func createStatusPost(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kCreateTimelineStatus)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kCreateTimelineStatus, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func requestFavouriteUnfavoritePost(timeLineID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request = SSHttpRequest(withuUrl: kTimelineFavouritePost)
        let requestValues = ["timeline_id" : timeLineID] as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: requestValues, url: kTimelineFavouritePost, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func requestPinUnpinPost(pinType: String, requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let request = SSHttpRequest(withuUrl: pinType)
		request.postMethodWithHeaderasToken(dictParameter: requestDict, url: pinType, header: getHeader(), successResponse: {(response) in
			successResponse(response)
		}, faliure: {(error) in
			faliure(error)
		})
	}
	
	func hideTimeLimelinePost(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTimelineHidePost)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kTimelineHidePost, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func deleteTimeLimelinePost(timeLineID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTimelineDeletePost)
        let requestValues = ["post_id" : timeLineID]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: requestValues, url: kTimelineDeletePost, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func requestReportPost(parameterDict: [String: Any], type: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: type)
        request.postMethodWithHeaderasToken(dictParameter: parameterDict, url: type, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func sendComments(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTimelineComments)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kTimelineComments, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func getTimelineDetails(timeLineID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
		let url = kTimelineDetails.replacingOccurrences(of: "%@", with: timeLineID)
        let request =  SSHttpRequest(withuUrl: url)
        request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func deleteTimelinePostComment(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kDeleteCommentForTimelinePost)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kDeleteCommentForTimelinePost, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func createVideoAlbumtypeForTimelinePost(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kShareAlbumPost)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kShareAlbumPost, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func createImageAlbumtypeForTimelinePost(parameters:[String:Any], imagesInfo: [[String: Any]], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
        let requestUrl = "\(kBaseUrl + kShareAlbumPost)"
        Alamofire.upload(multipartFormData: { multipartFormData in
			
			for infoDict in imagesInfo {
				multipartFormData.append(infoDict["data"] as! Data, withName: "album_files[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
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
	
	func shareFilesForTimelinePost(parameters:[String:Any], filesInfo: [[String:Any]], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
        let requestUrl = "\(kBaseUrl + kShareFilesForPost)"
        Alamofire.upload(multipartFormData: { multipartFormData in
			
			for infoDict in filesInfo {
				multipartFormData.append(infoDict["data"] as! Data, withName: "upload_files[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
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
	
	func updatePost(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kUpdateTimelineStatus)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kUpdateTimelineStatus, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func updateImageAlbumtypeOrFilesForTimelinePost(_ isFileUpload: Bool = false,parameters:[String:Any], imagesInfo: [[String: Any]], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
        let requestUrl = "\(kBaseUrl + kUpdateTimelineStatus)"
        Alamofire.upload(multipartFormData: { multipartFormData in
			
			for infoDict in imagesInfo {
				multipartFormData.append(infoDict["data"] as! Data, withName: "new_files[]", fileName: infoDict["fileName"] as! String, mimeType: infoDict["mimeType"] as! String)
			}
            for (key, value) in parameters {
                
				if key == "existing_files[]" {
					if isFileUpload {
						let existing_files = value as? [[String: Any]] ?? []
						for i in 0..<existing_files.count {
							let name = existing_files[i]["name"] as? String ?? ""
							let type = existing_files[i]["type"] as? String ?? ""
							multipartFormData.append("\(name)".data(using: String.Encoding.utf8)!, withName: "existing_files[\(i)][name]")
							multipartFormData.append("\(type)".data(using: String.Encoding.utf8)!, withName: "existing_files[\(i)][type]")
						}
					}
					else {
						let names = value as? [String] ?? []
						for str in names {
							multipartFormData.append("\(str)".data(using: String.Encoding.utf8)!, withName: key as String)
						}
					}
				}
				else {
					multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
				}
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
	
	func getUserFriends(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kGetUserFriends)
        request.getMethod(dictParameter: [:], url: kGetUserFriends, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }

	func getPendingFriendRequests(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kPendingFriendRequests)
        request.getMethod(dictParameter: [:], url: kPendingFriendRequests, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func makeAddORCancelORRejectORApproveORUnFriendRequest(friendID: String, urlStr: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: urlStr)
        let requestValues = ["friend_id" : friendID]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: requestValues, url: urlStr, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func searchFriendRequest(name: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kSearchFriend)
        let requestValues = ["search_name" : name]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: requestValues, url: kSearchFriend, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func makeUserAddMembersInGroupFriendRequest(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kUserAddMembersInGroup)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: kUserAddMembersInGroup, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
}
