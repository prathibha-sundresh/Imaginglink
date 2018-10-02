//
//  CoreAPI.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/9/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation

class CoreAPI {
    
    static let sharedManaged = CoreAPI()
    
    private init() {
        // Do something
        SSHttpRequest.setbaseUrl(url: kBaseUrl)
    }
//    first_name, last_name, email,password, otp_code, user_type
    func signUpWithEmailId(firstName : String, lastNAme: String, email:String, password:String, userType:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/signup/email")
        let signUpValues = ["first_name" : firstName, "last_name" : lastNAme, "email" : email, "password" : password, "user_type" : userType, "otp_code" : UserDefaults.standard.value(forKey: OTP_Value) as! String] as [String:Any]
        request.postMethod(dictParameter: signUpValues, url: "api/signup/email", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func signIn(userName : String, password : String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/login/email")
        let signInValues = ["email" : userName, "password" : password] as [String:Any]
        request.postMethod(dictParameter: signInValues, url: "api/login/email", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func RegisterEmail(Email : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/otp/send")
        let OTPRequestValues = ["email" : Email] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/otp/send", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestOTPWithEmail(Email : String, OTP: String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/otp/verify")
        let OTPRequestValues = ["requested_email" : Email, "otp_code" : OTP] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/otp/verify", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    

    func VerifyPhonenumber(phoneNumber : String,countryCode : String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/authy/send-registration-code")
        let OTPRequestValues = ["token" : UserDefaults.standard.value(forKey: kToken) as! String, "mobile" :  phoneNumber, "country_code": countryCode] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/authy/send-registration-code", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func getCountryList(successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
//
    let request =  SSHttpRequest(withuUrl: "http://52.39.123.104/api/countries")
    let OTPRequestValues = ["token" : UserDefaults.standard.value(forKey: kToken) as! String, "mobile" :  phoneNumber, "country_code": countryCode] as [String:Any]
    request.postMethod(dictParameter: OTPRequestValues, url: "api/authy/send-registration-code", successResponse: {(response) in
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
        let request =  SSHttpRequest(withuUrl: "api/presentation/getPublicPresentations")
        let OTPRequestValues = ["token" : UserDefaults.standard.value(forKey: kToken) as! String] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/presentation/getPublicPresentations", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requesrForgotPassword(emailId:String, successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/forgetPasswordRequest")
        let OTPRequestValues = ["requested_email" : emailId] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/forgetPasswordRequest", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    func requestOTPForResetPassword(Email : String, OTP: String,successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/forgot-password/otp/verify")
        let OTPRequestValues = ["requested_email" : Email, "otp_code" : OTP] as [String:Any]
        request.postMethod(dictParameter: OTPRequestValues, url: "api/forgot-password/otp/verify", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
    
    
    func requestResetPassword(params:[String:Any], successResponse:@escaping (_ response:AnyObject)-> Void, faliure:@escaping (_ errorMessage:String) -> Void) {
        let request =  SSHttpRequest(withuUrl: "api/updatePassword")
        request.postMethod(dictParameter: params, url: "api/updatePassword", successResponse: {(response) in
            successResponse(response)
        }, faliure: {(error) in
            faliure(error)
        })
        
    }
}




