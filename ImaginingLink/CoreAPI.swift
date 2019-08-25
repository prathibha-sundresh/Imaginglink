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
        // Do something
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
        let token = UserDefaults.standard.value(forKey: kToken) as! String
         let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        let OTPRequestValues = ["mobile" :  phoneNumber, "country_code": countryCode] as [String:Any]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationMobileVerificationAPI, header: header, successResponse: {(response) in
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
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["" : "" ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationResendOTPAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func callPublicPresentation(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kpublicPresentaion)
        let OTPRequestValues = ["" : "" ]  as [String:Any]
        request.getMethod(dictParameter: OTPRequestValues, url: kpublicPresentaion, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestFavouriteUnfavorite(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kFavouriteUnfavorite)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["presentation_id" : presentationID ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kFavouriteUnfavorite, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestFollowUnFollow(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kFollowOrUnfollow)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["presentation_id" : presentationID ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kFollowOrUnfollow, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    func requestReportPost(presentationID: String,selectedIssue: String,reportedIssue: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kReportPost)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["presentation_id" : presentationID, "selected_issue": selectedIssue, "reported_issue":reportedIssue]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kReportPost, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    func requestAddRatingPost(presentationID: String,rating: Int, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kAddRatings)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["presentation_id" : presentationID, "rating": rating]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kAddRatings, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    func requestLikeUnLike(presentationID: String, likeUnLikeValue: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kPresentationLikeOrUnLike)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["presentation_id" : presentationID, "like_emoji": likeUnLikeValue ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kPresentationLikeOrUnLike, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    func requestNotify(presentationID: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kNotificationorNonNotify)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["presentation_id" : presentationID ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kNotificationorNonNotify, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }

    func requestOldEmailOTP(otpCode: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kVerifyOldEmailAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["otp_code" : otpCode ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kVerifyOldEmailAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestNewEmailOTP(otpCode: String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kVerifyNewEmailAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["otp_code" : otpCode ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kVerifyNewEmailAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestForcomments(comment: String,parentcommentid: String, commentedcondition:String,presentationid:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kComments)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let commentRequestValues = ["comment" : comment, "parent_comment_id" : parentcommentid, "commented_condition" : commentedcondition, "presentation_id" : presentationid ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)", "Accept" : "application/json"]
        
        request.postMethodWithHeaderasToken(dictParameter: commentRequestValues, url: kComments, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestLogout(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kLogOutAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["" : "" ]  as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kLogOutAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    func logOut(){
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.openRegularSignIn()
        self.requestLogout(successResponse: { (response) in
        
        }) { (error) in
            
        }
    }
    
    func verifyMobileOTP(verificationCode : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationMobileOTPAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["Accept" : "application/json","verify_code" :  verificationCode] as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationMobileOTPAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })

    }
    
    func DisableTwoFactorAuthentication(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationDisableAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["" : ""]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationDisableAPI, header: header, successResponse: {(response) in
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
//            let responseData = response as! [String:Any]
            
//            print("Response is \(responseData)")
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
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        request.postMethodWithHeaderasToken(dictParameter: params, url: kResetPasswordAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
    }
    
    func requestToUpdateEmail(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kUpdateEmailAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        request.postMethodWithHeaderasToken(dictParameter: params, url: kUpdateEmailAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestToInviteFriends(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kInviteFriendsAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let header : HTTPHeaders = ["Accept" : "application/json", "Authorization":"Bearer \(token)"]
        request.postMethodWithHeaderasToken(dictParameter: params, url: kInviteFriendsAPI, header: header, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
}




