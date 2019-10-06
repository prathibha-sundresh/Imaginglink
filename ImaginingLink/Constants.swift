//
//  Constants.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/4/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation


let OTP_Value = "OTP_VALUE"

let kBaseUrl:String = "http://52.39.123.104/dev/"
let kTwoFactorAuthentication = "two_factor_authentication"
let kSetPhoneNumberValidated = "phoneValidated"
let kToken = "token"
let kAuthenticatedEmailId = "EmailID"
let kUserName = "fullName"
let kFirstName = "firstName"
let kLastName = "lastName"
let kUserType = "userType"

let kEmailOTP = "EmailOTPScreen"
let kResetPasswordOTP = "ResetPasswordOTPScreen"
let kLoggedIn = "kLoggedIn"

let kLoginAPI = "api/login"
let kLogOutAPI = "api/logout"
let kCountryListAPI = "api/countries"
let kUserTypeListAPI = "api/user-types"
let kSendOTPForForgotPasswordAPI = "api/forgot-password/send-otp"
let kForgotPasswordVerifyAPI = "api/forgot-password/verify-otp"
let kForgotPasswordUpdatePasswordAPI = "api/forgot-password/update-password"
let kResetPasswordAPI = "api/update-password"
let kUpdateEmailAPI = "api/update-email"
let kInviteFriendsAPI = "api/invite-friends"
let kSignUpSendOTPAPI = "api/signup/send-otp"
let kSignUpVerifyOTPAPI = "api/signup/verify-otp"
let kSignUpAPI = "api/signup/add-user-details"
let kVerifyOldEmailAPI = "api/update-email/verify-otp"
let kVerifyNewEmailAPI = "api/update-email/verify-otp/new-email"
let kTwoFactorAuthenticationMobileVerificationAPI = "api/authy/send-registration-code"
let kTwoFactorAuthenticationDisableAPI = "api/authy/enable-later"
let kUserTypeAPI = "api/user-types"
let kTwoFactorAuthenticationMobileOTPAPI = "api/authy/code-verification"
let kTwoFactorAuthenticationResendOTPAPI = "api/authy/code-resend"
let k2FASendOTPToEnabledUserAPI = "api/authy/send-code-to-enabled-user"
let k2FADisableAPI = "api/authy/disable"
let kpublicPresentaion = "api/presentations/public"
let kUserPresentation = "api/presentations/{id}"
let kPresentationCommentList = "api/comments/presentation/{presentation_id}"
let kComments = "api/comments"
let kFavouriteUnfavorite = "api/favourites"
let kFollowOrUnfollow = "api/follows"
let kNotificationorNonNotify = "api/notifications"
let kPresentationLikeOrUnLike = "api/presentations/save-like"
let kReportPost = "api/reports"
let kAddRatings = "api/ratings"
let KSavedPresentations = "api/presentations/user-favourite-presentations"

//Screen Name
let kEmailVerifiedScreen = "EmailScreen"
let kSignUpScreen = "SignUp"
let kForgetPasswordScreen = "ForgetPasswordScreen"

//Locale
let kOldEmailVerificationText = "A 6-digit verification code is sent to OldEmail  Please enter that code below to authenticate change request."
let kNewEmailVerificationText = "A 6-digit verification code is sent to New Email  Please enter that code below to authenticate change request."
let kSupportText = "If you do not have access to this email, contact support@imaginglink.com for reset."
let kSupportLocationText = "If you do not have access to this email, contact "
let kSupportLinkText = "support@imaginglink.com"
let kNewEmailChange = "A 6-digit verification code is sent to newmail@gmail.com  Please enter that code below to authenticate change request."
let kNewEmailLenght = "A 6-digit verification code is sent to "
let knewEmail = "newmail@gmail.com"

//links
let termsandconditionUrl = "http://52.39.123.104/dev/terms-conditions"
let privacyPolicyUrl = "http://52.39.123.104/dev/privacy-policy"

//UserDetails
let KGetUserDetails = "api/edit-user-profile-info"
let KUpdateUserDetails = "api/update-profile"
let KUpdateProfilePhoto = "api/update-profile-photo"

