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
    let kBaseUrl:String = "https://www.imaginglink.com/dev/api/"
	let termsandconditionUrl = "https://www.imaginglink.com/dev/terms-conditions"
	let privacyPolicyUrl = "https://www.imaginglink.com/dev/privacy-policy"
#else
	let kBaseUrl:String = "https://www.imaginglink.com/api/"
	let termsandconditionUrl = "https://www.imaginglink.com/terms-conditions"
	let privacyPolicyUrl = "https://www.imaginglink.com/privacy-policy"
#endif

let kTwoFactorAuthentication = "two_factor_authentication"
let kSetPhoneNumberValidated = "phoneValidated"
let kToken = "token"
let kAuthenticatedEmailId = "EmailID"
let kUserName = "fullName"
let kFirstName = "firstName"
let kLastName = "lastName"
let kUserType = "userType"
let kLoggedInUserId = "logged_in_user_id"

let kEmailOTP = "EmailOTPScreen"
let kResetPasswordOTP = "ResetPasswordOTPScreen"
let kLoggedIn = "kLoggedIn"

let kLoginAPI = "login"
let kLogOutAPI = "logout"
let kCountryListAPI = "countries"
let kUserTypeListAPI = "user-types"
let kSendOTPForForgotPasswordAPI = "forgot-password/send-otp"
let kForgotPasswordVerifyAPI = "forgot-password/verify-otp"
let kForgotPasswordUpdatePasswordAPI = "forgot-password/update-password"
let kResetPasswordAPI = "update-password"
let kUpdateEmailAPI = "update-email"
let kInviteFriendsAPI = "invite-friends"
let kSignUpSendOTPAPI = "signup/send-otp"
let kSignUpVerifyOTPAPI = "signup/verify-otp"
let kSignUpAPI = "signup/add-user-details"
let kVerifyOldEmailAPI = "update-email/verify-otp"
let kVerifyNewEmailAPI = "update-email/verify-otp/new-email"
let kTwoFactorAuthenticationMobileVerificationAPI = "authy/send-registration-code"
let kTwoFactorAuthenticationDisableAPI = "authy/enable-later"
let kUserTypeAPI = "user-types"
let kTwoFactorAuthenticationMobileOTPAPI = "authy/code-verification"
let kTwoFactorAuthenticationResendOTPAPI = "authy/code-resend"
let k2FASendOTPToEnabledUserAPI = "authy/send-code-to-enabled-user"
let k2FADisableAPI = "authy/disable"
let kpublicPresentaion = "presentations/public"
let kUserPresentation = "presentations/{id}"
let kPresentationCommentList = "comments/presentation/{presentation_id}"
let kComments = "comments"
let kFavouriteUnfavorite = "favourites"
let kFollowOrUnfollow = "follows"
let kNotificationorNonNotify = "notifications"
let kPresentationLikeOrUnLike = "presentations/save-like"
let kReportPost = "reports"
let kAddRatings = "ratings"
let KSavedPresentations = "presentations/user-favourite-presentations"

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


//UserDetails
let KGetUserDetails = "edit-user-profile-info"
let KUpdateUserDetails = "update-profile"
let KUpdateProfilePhoto = "update-profile-photo"

//Create Presentations
let KSectionsAndSubSections = "sections-related"
let KCreatePresentations = "presentations/user"
let KUserPresentationDetails = "presentations/user/{presentation_id}"
let KUpdatePresentationDetails = "presentations/details/{presentation_id}"
let KUpdatePresentationFile = "presentations/file-update"
let KCoAuthors = "co-authors"
let KSavePresentation = "user/save"
let KFilterPublishPresentation = "presentations/filter"
let KFilterUserPresentation = "presentations/user"
let KUserPresentationAcceptOrReject = "user/action-on-editor-modified"

//Settings
let KContactUs = "contact-us"

//SocialConnectAPI
let KUserTimelineData = "social-connect/get-user-timeline-data"
let kSaveAllPostLikesEmoji = "social-connect/save-all-post-likes"
let kCreateTimelineStatus = "social-connect/timeline-status-update"
let kTimelineFavouritePost = "social-connect/add-timeline-favourite-post"
let kTimelineHidePost = "social-connect/hide-post"
let kTimelineDeletePost = "social-connect/delete-shared-post"
let kReportTimeLinePost = "social-connect/timeline-report-user-post"
let kTimelineComments = "social-connect/add-comment"
let kTimelineDetails = "social-connect/load-timeline-post-details?timeline_id=%@"
let kDeleteCommentForTimelinePost = "social-connect/delete-comment"
let kShareAlbumPost = "social-connect/create-album"
let kShareFilesForPost = "social-connect/upload-files"
let kMyWallPosts = "social-connect/get-user-wall"
let kImageAndFileBaseUrl = "https://imaginglink.s3-us-west-2.amazonaws.com/"
let kUpdateTimelineStatus = "social-connect/update-user-post"
let kGetUserFriends = "social-connect/get-user-friends"
let kUnFriend = "social-connect/un-friend"
let kPendingFriendRequests = "social-connect/get-pending-friend-requests"
let kCancelFriendRequest = "social-connect/user-cancel-friend-request"
let kRejectFriendRequest = "social-connect/reject-friend-request"
let kApproveFriendRequest = "social-connect/approve-friend-request"
let kIgnoreFriendRequest = "social-connect/ignore-friend-request"
let kSearchFriend = "social-connect/search-friend"
let kAddFriend = "social-connect/add-friend"
let kUserAddMembersInGroup = "social-connect/user-add-members-in-group"

//PortFolioAPI
let kPortFolioBasicDetails = "get-portfolio-section-details?type=%@"
let kCurrentPositionType = "current_position"
let kTitleType = "current"
let kBasicEducationType = "basic_education"
let kAddPortFolioDetails = "add-portfolio-details"
let kPortFolioDetails = "get-portfolio-details"
let kDeletePortfolioDetails = "delete-portfolio-details"
let kShowHidePortfolioType = "portfolio-status-hide-and-show"

//Groups
let kUserGroups = "social-connect/get-user-groups"
let kCreateGroup = "social-connect/create-group"
let kGroupIdDetails = "social-connect/get-group-details?group_id=%@"
let kGroupDiscussions = "social-connect/get-group-discussions"
let kUpdateGroupDescription = "social-connect/update-group_description"
let kShareGroup = "social-connect/share-group"
let kUpdateUserGroupStatus = "social-connect/update-user-group-status"
let kGetGroupMembers = "social-connect/get-group-members?group_id=%@"
let kPinPost = "social-connect/pin-a-post"
let kUnPinPost = "social-connect/unpin-a-post"
let kReportGroupSharedPost = "social-connect/report-group-post"
let kGroupAdminApproveOrRejectMember = "social-connect/group-admin-approve-or-reject-member-in-group"
let kChangeGroupMemberPrivilege = "social-connect/change-group-member-privilege"
let kLeaveMemberFromGroup = "social-connect/leave-member-from-group"
let kGetGroupEvents = "social-connect/load-all-events?group_id=%@"
let kCreateGroupEvent = "social-connect/create-user-event"
let kDeleteGroupEvent = "social-connect/delete-event"
let kUpdateGroupEvent = "social-connect/update-user-event"
let kStoreEventRSVP = "social-connect/store-event-RSVP"
let kGroupEventDetail = "social-connect/get-group-event-discussions?group_id=%@&event_id=%@&limit=10&offset=0"
let kSendEventInvitation = "social-connect/send-event-invitation"
let kGetAllResources = "social-connect/get-all-resources?group_id=%@"
let kCreateOrUpdateResourcesFolder = "social-connect/create-resource-folder"
let kDeleteResourceFolder = "social-connect/delete-resource-folder"
let kAddYouTubeUrlResource = "social-connect/add-youtube-url-resource"
let kDeleteResourceFile = "social-connect/delete-resource-file"
let kUploadResourceFiles = "social-connect/upload-resource-files"
let kManagePosts = "social-connect/get-posts-to-manage?group_id=%@&limit=10"
let kApproveGroupPost = "social-connect/approve-group-post"
let kRejectGroupPost = "social-connect/reject-group-post"

let kCreateGroupPoll = "social-connect/create-poll"
let kLoadAllGroupPolls = "social-connect/load-all-polls?group_id=%@"
let kLoadActiveGroupPolls = "social-connect/load-active-polls?group_id=%@"
let kUpdateGroupPoll = "social-connect/update-poll"
let kDeleteGroupPoll = "social-connect/delete-poll"
let kStoreUserOpinionGroupPoll = "social-connect/store-user-opinion"

