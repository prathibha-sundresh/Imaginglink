   //
//  CoreAPI.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/9/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation
import Alamofire

class CoreAPI {
    
    static let sharedManaged = CoreAPI()
    
    private init() {
        SSHttpRequest.setbaseUrl(url: kBaseUrl)
    }
	
    func signUpWithEmailId(firstName : String, lastNAme: String, email:String, password:String, userType:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kSignUpAPI)
        let signUpValues = ["first_name" : firstName, "last_name" : lastNAme, "email" : email, "password" : password, "user_type_id" : userType, "otp_code" : UserDefaults.standard.value(forKey: OTP_Value) as! String] as [String:Any]
        request.postMethod(dictParameter: signUpValues, url: kSignUpAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func signIn(userName : String, password : String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kLoginAPI)
        let signInValues = ["email" : userName, "password" : password, "disable_mobile_captcha" : true] as [String:Any]
        request.postMethod(dictParameter: signInValues, url: kLoginAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func RegisterEmail(Email : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kSignUpSendOTPAPI)
        let OTPRequestValues = ["email" : Email] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: kSignUpSendOTPAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestOTPWithEmail(Email : String, OTP: String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kSignUpVerifyOTPAPI)
        let OTPRequestValues = ["email" : Email, "otp_code" : OTP] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: kSignUpVerifyOTPAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func VerifyPhonenumber(phoneNumber : String,countryCode : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationMobileVerificationAPI)
        let OTPRequestValues = ["mobile" :  phoneNumber, "country_code": countryCode] as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationMobileVerificationAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func getUserPresentationWithId(UserID:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let url = kUserPresentation.replacingOccurrences(of: "{id}", with: UserID)
        let request =  SSHttpRequest(withuUrl: url)
    
        request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func getCommentListWithId(presentationId:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let url = kPresentationCommentList.replacingOccurrences(of: "{presentation_id}", with: presentationId)
        let request =  SSHttpRequest(withuUrl: url)
        request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func getCountryList(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kCountryListAPI)
        request.getMethod(dictParameter: [:], url: kCountryListAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            
        })
    }
	
    func reSendMobileOTP(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationResendOTPAPI)
        request.postMethodWithHeaderasToken(dictParameter: [:], url: kTwoFactorAuthenticationResendOTPAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func sendOtpToEnabledUser(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: k2FASendOTPToEnabledUserAPI)
        request.postMethodWithHeaderasToken(dictParameter: [:], url: k2FASendOTPToEnabledUserAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func disable2faToUser(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: k2FADisableAPI)
        request.postMethodWithHeaderasToken(dictParameter: [:], url: k2FADisableAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func callPublicPresentation(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kpublicPresentaion)
        request.getMethod(dictParameter: [:], url: kpublicPresentaion, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func callSavedPresentation(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: KSavedPresentations)
        request.getMethod(dictParameter: [:], url: KSavedPresentations, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            
            let errorDic : [String : Any] = error.convertToDictionary()!
            faliure(errorDic["message"] as? String ?? "")
        })
    }
	
    func requestFavouriteUnfavorite(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kFavouriteUnfavorite)
        let OTPRequestValues = ["presentation_id" : presentationID ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kFavouriteUnfavorite, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestFollowUnFollow(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kFollowOrUnfollow)
        let OTPRequestValues = ["presentation_id" : presentationID ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kFollowOrUnfollow, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
	
    func requestReportPost(presentationID: String,selectedIssue: String,reportedIssue: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kReportPost)
        let OTPRequestValues = ["presentation_id" : presentationID, "selected_issue": selectedIssue, "reported_issue":reportedIssue]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kReportPost, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func requestAddRatingPost(presentationID: String,rating: Int, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kAddRatings)
        let OTPRequestValues = ["presentation_id" : presentationID, "rating": rating]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kAddRatings, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func requestForSaveLikeEmoji(presentationID: String, likeUnLikeValue: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kPresentationLikeOrUnLike)
        let OTPRequestValues = ["presentation_id" : presentationID, "like_emoji": likeUnLikeValue ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kPresentationLikeOrUnLike, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func requestNotify(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kNotificationorNonNotify)
        let OTPRequestValues = ["presentation_id" : presentationID ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kNotificationorNonNotify, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }

    func requestOldEmailOTP(otpCode: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kVerifyOldEmailAPI)
        let OTPRequestValues = ["otp_code" : otpCode ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kVerifyOldEmailAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestNewEmailOTP(otpCode: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kVerifyNewEmailAPI)
        let OTPRequestValues = ["otp_code" : otpCode ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kVerifyNewEmailAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestForcomments(comment: String,parentcommentid: String, commentedcondition:String,presentationid:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kComments)
        let commentRequestValues = ["comment" : comment, "parent_comment_id" : parentcommentid, "commented_condition" : commentedcondition, "presentation_id" : presentationid ]  as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: commentRequestValues, url: kComments, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestLogout(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kLogOutAPI)
        request.postMethodWithHeaderasToken(dictParameter: [:], url: kLogOutAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func logOut() {
        
        let fileManager = FileManager.default
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let imagePath = documentsUrl.appendingPathComponent("profile-photo.jpg")
        
        if fileManager.fileExists(atPath: imagePath.path) {
            try! fileManager.removeItem(atPath: imagePath.path)
        } else {
            print("File does not exist")
        }
        
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.openRegularSignIn()
        self.requestLogout(successResponse: { (response) in
        
        }) { (error) in
            
        }
        ILUtility.clearUserDefaults()
    }
    
    func verifyMobileOTP(verificationCode : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationMobileOTPAPI)
        let OTPRequestValues = ["verify_code" :  verificationCode] as [String:Any]
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationMobileOTPAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func DisableTwoFactorAuthentication(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationDisableAPI)
        request.postMethodWithHeaderasToken(dictParameter: [:], url: kTwoFactorAuthenticationDisableAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func getallUserPresentation(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/presentation/getAllUserPresentations")
        let OTPRequestValues = ["token" : UserDefaults.standard.value(forKey: kToken) as! String] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/presentation/getAllUserPresentations", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func getUserDetails(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KGetUserDetails)
        
        request.getMethod(dictParameter: [:], url: KGetUserDetails, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func updateUserDetails(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KUpdateUserDetails)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: KUpdateUserDetails, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
    func updateProfilePhoto(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let serverUrl = SSHttpRequest.baseURL!.appending(KUpdateProfilePhoto)
        
        let imgData = requestDict["imageData"] as! Data
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "profile_photo",fileName: "images.jpg", mimeType: "image/jpeg")
        },
                         to:serverUrl, headers: getHeader())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    successResponse(response.result.value as AnyObject)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                faliure("\(encodingError)")
            }
        }
    }
	
    func getPublicUserPresentation(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kpublicPresentaion)
        
        request.getMethod(dictParameter: [:], url: kpublicPresentaion, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requesrForgotPassword(emailId:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kSendOTPForForgotPasswordAPI)
        let OTPRequestValues = ["email" : emailId] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: kSendOTPForForgotPasswordAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestOTPForResetPassword(Email : String, OTP: String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kForgotPasswordVerifyAPI)
        let OTPRequestValues = ["email" : Email, "otp_code" : OTP] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: kForgotPasswordVerifyAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestUserType(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kUserTypeAPI)
        request.getMethodWithOutHeader(url: kUserTypeAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(failure) in
            
        })
    }
    
    func requestForgetPassword(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kForgotPasswordUpdatePasswordAPI)
        request.postMethod(dictParameter: params, url: kForgotPasswordUpdatePasswordAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestResetPassword(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kResetPasswordAPI)
        request.postMethodWithHeaderasToken(dictParameter: params, url: kResetPasswordAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestToUpdateEmail(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kUpdateEmailAPI)
        request.postMethodWithHeaderasToken(dictParameter: params, url: kUpdateEmailAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestToInviteFriends(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kInviteFriendsAPI)
        request.postMethodWithHeaderasToken(dictParameter: params, url: kInviteFriendsAPI, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func getSectionsAndSubSections(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KSectionsAndSubSections)
        
        request.getMethod(dictParameter: [:], url: KSectionsAndSubSections, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func createOrFileUpdatePresentation(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        
		var requestUrl = ""
		var parameters: [String: Any] = [:]
		let isFromFileUpdate = params["isFromFileUpdate"] as? Bool ?? false
		if isFromFileUpdate {
			requestUrl = "\(kBaseUrl + KUpdatePresentationFile)"
			parameters = ["presentation_id": params["presentation_id"]!, "is_file_upload": params["is_file_upload"]!, "is_downloadable": params["is_downloadable"]!] as [String : Any]
		}
		else{
			requestUrl = "\(kBaseUrl + KCreatePresentations)"
			parameters = ["title": params["title"]!, "section": params["section"]!, "sub_sections": params["sub_sections"]!, "is_file_upload": params["is_file_upload"]!, "is_downloadable": params["is_downloadable"]!, "keywords": params["keywords"]!, "description": params["description"]!, "university": ""] as [String : Any]
		}

        var fileData: Data?
        if params["is_file_upload"] as! Int == 0{
            parameters["youtube_url"] = params["youtube_url"]!
        }
        else{
			let url = params["fileUrl"] as? URL
            do {
                fileData = try Data(contentsOf: url!)
            } catch {
                print ("loading image file error")
            }
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if let data = fileData {
				let fileName = params["fileName"] as? String ?? ""
				var mimeTypeStr = ""
				if let fileExtension = params["fileExtension"] as? String, fileExtension == "pdf" {
					mimeTypeStr = "application/pdf"
				}
				else{
					mimeTypeStr = "application/vnd"
				}
                multipartFormData.append(data, withName: "ppt_pdf_file", fileName: fileName, mimeType: mimeTypeStr)
            }
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }},to: requestUrl, headers: getHeader())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                //                upload.uploadProgress(closure: { (progress) in
                //                    //print("Upload Progress: \(progress.fractionCompleted)")
                //                })
                
                upload.responseJSON { response in
                    print(response.result.value as AnyObject)
                    successResponse(response.result.value as AnyObject)
                }
                
            case .failure(let error):
                faliure("\(error)")
            }
        }
    }
    
    func getUserPresentationDetails(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let url = KUserPresentationDetails.replacingOccurrences(of: "{presentation_id}", with: presentationID)
        let request =  SSHttpRequest(withuUrl: url)
        request.getMethod(dictParameter: [:], url: url, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func getHeader() -> HTTPHeaders{
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        return header
    }
	
	func getCoAuthors(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KCoAuthors)
        
        request.getMethod(dictParameter: [:], url: KCoAuthors, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func addCoAuthors(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KCoAuthors)
        request.postMethodWithHeaderasToken(dictParameter: params, url: KCoAuthors, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func updateUserPresentationDetails(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		
		let url = KUpdatePresentationDetails.replacingOccurrences(of: "{presentation_id}", with: params["presentation_id"] as? String ?? "")
        let request =  SSHttpRequest(withuUrl: url)
        request.postMethodWithHeaderasToken(dictParameter: params, url: url, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func savePresentation(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KSavePresentation)
        request.postMethodWithHeaderasToken(dictParameter: params, url: KSavePresentation, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func filterPublishPresentation(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		let stringURL = KFilterPublishPresentation + "?sortby=\(params["sortby"]!)&section= \(params["section"]!) &subsections=\(params["subsections"]!)"
		
		let request =  SSHttpRequest(withuUrl: stringURL)
		
		request.getMethod(dictParameter: [:], url: stringURL, true, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func filterUserPresentation(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
		let stringURL = KFilterUserPresentation
		let request =  SSHttpRequest(withuUrl: stringURL)
		request.getMethod(dictParameter: [:], url: stringURL, true, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
		
    }
	
	func authorApproveOrRejectEditorChangesToPresentation(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: KUserPresentationAcceptOrReject)
        request.postMethodWithHeaderasToken(dictParameter: params, url: KUserPresentationAcceptOrReject, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
	
	func sendContactUsDetails(requestDict: [String: Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: KContactUs)
        request.postMethodWithHeaderasToken(dictParameter: requestDict, url: KContactUs, header: getHeader(), successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func callFolioPresentation(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kFolioPresentation)
        request.getMethod(dictParameter: [:], url: kFolioPresentation, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    
    func callCreateFolio(withData: [String: Any], successResponse:@escaping (_ response:AnyObject, _ status: Int)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        
        let requestUrl = "\(kBaseUrl + kCreateFolioGroup)"
        Alamofire.upload(multipartFormData: { multipartFormData in
            var isFileAdded = false
            if let data = withData["folio_data[logo][]"] as? [Data] {
                let mimeType = "image/jpeg"
                multipartFormData.append(data[0], withName: "folio_data[logo][]", fileName: "logo1.jpeg", mimeType: mimeType)
                isFileAdded = true
            }
            
            
            for (key, value) in withData {
                if key == "folio_data[logo][]" && isFileAdded{
                    continue
                }
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }},to: requestUrl, headers: getHeader())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    successResponse(response.result.value as AnyObject, response.response!.statusCode)
                }
            case .failure(let error):
                faliure("\(error)")
            }
        }
    }
    
}
