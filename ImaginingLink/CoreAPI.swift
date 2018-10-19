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
    
    func getCountryList(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
    let request =  SSHttpRequest(withuUrl: kCountryListAPI)
    let OTPRequestValues = ["token" : UserDefaults.standard.value(forKey: kToken) as! String] as [String:Any]
        
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
    
    
    func verifyMobileOTP(verificationCode : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void ) {
        let request =  SSHttpRequest(withuUrl: kTwoFactorAuthenticationMobileOTPAPI)
        let token = UserDefaults.standard.value(forKey: kToken) as! String
        let OTPRequestValues = ["Accept" : "application/json","verify_code" :  verificationCode] as [String:Any]
        let header : HTTPHeaders = ["Authorization":"Bearer \(token)"]
        
        request.postMethodWithHeaderasToken(dictParameter: OTPRequestValues, url: kTwoFactorAuthenticationMobileVerificationAPI, header: header, successResponse: {(response) in
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
    
    
    func requestResetPassword(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: kForgotPasswordUpdatePasswordAPI)
        request.postMethod(dictParameter: params, url: kForgotPasswordUpdatePasswordAPI, successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
}




