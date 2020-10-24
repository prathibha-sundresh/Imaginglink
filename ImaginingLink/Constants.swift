//
//  Constants.swift
//  ImaginingLink
//
//  Created by Imaginglink Inc on 1/4/18.
//  Copyright © 2018 Imaginglink Inc. All rights reserved.
//

import Foundation


let OTP_Value = "OTP_VALUE"

#if DEV
    let kBaseUrl:String = "https://www.imaginglink.com/dev/"
#else
	let kBaseUrl:String = "https://www.imaginglink.com/"
#endif

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
let kNewEmailChange = "A 6-digit verification code has been sent to newmail@gmail.com  Please enter that code below to authenticate change request."
let kNewEmailLength = "A 6-digit verification code has been sent to "
let knewEmail = "newmail@gmail.com"

//links
let termsandconditionUrl = kBaseUrl + "terms-conditions"
let privacyPolicyUrl = kBaseUrl + "privacy-policy"

//UserDetails
let KGetUserDetails = "api/edit-user-profile-info"
let KUpdateUserDetails = "api/update-profile"
let KUpdateProfilePhoto = "api/update-profile-photo"

//Create Presentations
let KSectionsAndSubSections = "api/sections-related"
let KCreatePresentations = "api/presentations/user"
let KUserPresentationDetails = "api/presentations/user/{presentation_id}"
let KUpdatePresentationDetails = "api/presentations/details/{presentation_id}"
let KUpdatePresentationFile = "api/presentations/file-update"
let KCoAuthors = "api/co-authors"
let KSavePresentation = "api/user/save"
let KFilterPublishPresentation = "api/presentations/filter"
let KFilterUserPresentation = "api/presentations/user"
let KUserPresentationAcceptOrReject = "api/user/action-on-editor-modified"

//Folio
let kFolioPresentation = "api/social-connect/get-user-folio-groups"
let kCreateFolioGroup = "api/social-connect/create-folio-social-group"

//Settings
let KContactUs = "api/contact-us"

//Folio Types
let kFolioType:[String] = ["Institution/Hospital", "Practice Group", "Organization", "Society", "Business", "Product", "Focussed Group", "Educational Cource", "Conference", "Publisher", "Grant", "Clinical Trail", "Custom"]
let kHighlighedURLHEader = "Share youtube URL for sharing videos that can be promoted in this section where you can show current corporate & product videos or a message from the president."
let kURlHeader = "Social Media Links"

let kTokenExpire = "token is expired"
