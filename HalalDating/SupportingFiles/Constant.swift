//
//  Constant.swift
//  BeeCrops
//
//  Created by Maulik Vinodbhai Vora on 24/07/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//
import UIKit
import Foundation

let appDelegate = UIApplication.shared.delegate as! AppDelegate



//Google Api Key
let googleApiKey = ""

struct SubscriptionType {
    static let chat_swipe = "Chat & Swipe"
    static let swipe = "Swipe"
}

//Veiable
var k_LoginUserTyepe = ""
let k_DateFormate = "yyyy-MM-dd HH:mm:ss"
let k_DateFormate_Date = "yyyy-MM-dd"
let k_DateFormate_Time = "hh:mm a"

 

//MARK:- Storyboards Objects
let objMainSB = UIStoryboard(name: "Main", bundle: nil)
let objSideMenuSB = UIStoryboard(name: "SideMenuSB", bundle: nil)






//MARK:- Api URL
var kImageBaseURL = "https://logosdatingapp.s3.amazonaws.com/"
//"https://halal-dating.com/test-app/public/uploads/"


var kBaseURL = "https://coptic-match.com/stage/api/"
//"https://coptic-match.com/stage/api/"
//"https://coptic-match.com/api/"
// Local - "http://192.168.1.56:8000/api/"
// Live URL - "https://coptic-match.com/api/"
//var kBaseURL = "https://coptic-match.com/test-live-v2/api/"



//Live ----
//Demo --



//--Api Name
let a_login = kBaseURL + "login"
let a_otpVerify = kBaseURL + "otp-verify"
let a_languageList = kBaseURL + "language-list"
let a_updateProfile = kBaseURL + "update-profile"
let a_updateImage = kBaseURL + "update-image"
let a_userList = kBaseURL + "v2-get-near-user"//"userList"
let a_userLikeDislike = kBaseURL + "user-like-dislike"
let a_checkSubscription = kBaseURL + "check-subscription"
let a_likedUserList = kBaseURL + "liked-user-list"
let a_subscriptionPlan = kBaseURL + "subscription-plan"
let detail_by_user_id = kBaseURL + "detail-by-user-id"
let terms = kBaseURL + "terms-condition"
let privacy = kBaseURL + "privacy"
let check_social_login = kBaseURL + "check-social-login"
let check_mobile_no = kBaseURL + "check-mobile-no?mobile_no="
let image_delete = kBaseURL + "image-delete"
let safety_tips = kBaseURL + "safety-tips"
let purchase_subscription = kBaseURL + "purchase-subscription"
let my_subscription = kBaseURL + "my-subscription"
let user_notification = kBaseURL + "user-notification"
let a_report = kBaseURL + "report"
let a_block = kBaseURL + "block"
let a_unMatches = kBaseURL + "un-matches"
let notification_status = kBaseURL + "notification-status"
let new_matches = kBaseURL + "new-matches"
let change_profile_status = kBaseURL + "change-profile-status?is_public="
let get_profile_status = kBaseURL + "get-profile-status"
let online_user = kBaseURL + "online-user"
let deactive_account = kBaseURL + "deactive-account"
let get_denomination = kBaseURL + "get-denomination"
let get_chat_room = kBaseURL + "get-chat-room"
let send_chat_msg = kBaseURL + "send-chat-msg"
let get_chat_msg = kBaseURL + "get-chat-msg"
let logout = kBaseURL + "logout"
let remove_to_like_users_list = kBaseURL + "remove-to-like-users-list?op_user_id="
let users_sub_or_unsubscribes = kBaseURL + "users-sub-or-unsubscribes"
let set_as_main_image = kBaseURL + "set-as-main-image"
let save_renewal_transaction = kBaseURL + "save-renewal-transaction"
let get_chat_count = kBaseURL + "get-unred-msg-count"
let set_rating = kBaseURL + "set-rating"
let get_rating = kBaseURL + "get-rating"
let update_address = kBaseURL + "address_update"

let update_screen_number = kBaseURL + "update-screen-number"
let update_profile_images = kBaseURL + "update-profile-images"

//MARK:- Veriable
let kAlertTitle = "Coptic Match"




// MARK: - Validation Messages
let internetConnectedTitle  = "No internet connection"
let internetConnected  = "Not detect internet"

let k_select_code = "Please enter country code"
let k_enter_phone = "Enter your phone number"
let k_enter_name = "Please enter name"
let k_select_date_of_birth = "Please enter your date of birth"
let k_enter_email = "Enter email"
let k_enter_valid_email = "Enter valid email"
let k_enter_valid_phone = "Please enter valid phone number"
let k_three_photo = "Please upload at least 3 real photos to your account. Accounts without real pictures may be subject to deactivation for verification reasons."


struct Constant {
    static let cancel = "Cancel"
    static let openSetting = "Open Settings"
    static let locationAlertTitle = "Location Needed"
    static let locationAlertMessageGetMarried = "Turn On Location Services To Allow CopticMatch to Determine Your Location"
    static let locationAlertMessageMain = "To provide accurate services, we need your location. Please enable it in Settings."
    static let locationAlertMessageHome = "We can’t show nearby people without access to your location. You can enable it in Settings."
}
