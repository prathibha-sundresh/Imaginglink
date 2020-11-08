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
	let kBaseUrl:String = "https://www.imaginglink.com/dev/"
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

//Settings
let KContactUs = "api/contact-us"

//SocialConnectAPI
let KUserTimelineData = "api/social-connect/get-user-timeline-data"
let kSaveAllPostLikesEmoji = "api/social-connect/save-all-post-likes"
let kCreateTimelineStatus = "api/social-connect/timeline-status-update"
let kTimelineFavouritePost = "api/social-connect/add-timeline-favourite-post"
let kTimelineHidePost = "api/social-connect/hide-post"
let kTimelineDeletePost = "api/social-connect/delete-shared-post"
let kReportTimeLinePost = "api/social-connect/timeline-report-user-post"
let kTimelineComments = "api/social-connect/add-comment"
let kTimelineDetails = "api/social-connect/load-timeline-post-details?timeline_id=%@"
let kDeleteCommentForTimelinePost = "api/social-connect/delete-comment"
let kShareAlbumPost = "api/social-connect/create-album"
let kShareFilesForPost = "api/social-connect/upload-files"
let kMyWallPosts = "api/social-connect/get-user-wall"
let kImageAndFileBaseUrl = "https://imaginglink.s3-us-west-2.amazonaws.com/"
let kUpdateTimelineStatus = "api/social-connect/update-user-post"
let kGetUserFriends = "api/social-connect/get-user-friends"
let kUnFriend = "api/social-connect/un-friend"
let kPendingFriendRequests = "api/social-connect/get-pending-friend-requests"
let kCancelFriendRequest = "api/social-connect/user-cancel-friend-request"
let kRejectFriendRequest = "api/social-connect/reject-friend-request"
let kApproveFriendRequest = "api/social-connect/approve-friend-request"
let kIgnoreFriendRequest = "api/social-connect/ignore-friend-request"
let kSearchFriend = "api/social-connect/search-friend"
let kAddFriend = "api/social-connect/add-friend"
let kUserAddMembersInGroup = "api/social-connect/user-add-members-in-group"

//PortFolioAPI
let kPortFolioBasicDetails = "api/get-portfolio-section-details?type=%@"
let kCurrentPositionType = "current_position"
let kTitleType = "current"
let kBasicEducationType = "basic_education"
let kAddPortFolioDetails = "api/add-portfolio-details"
let kPortFolioDetails = "api/get-portfolio-details"
let kDeletePortfolioDetails = "api/delete-portfolio-details"
let kShowHidePortfolioType = "api/portfolio-status-hide-and-show"
