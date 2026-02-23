//
//  UserModel.swift
//  HalalDating
//
//  Created by Maulik Vora on 01/12/21.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    
    var dataList: [UserData] = []
    var data: UserData?
    var code: Int = 0
    var message: String = ""
    var status: String = ""
    
    init() {
    }

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        dataList <- map["data"]
        data <- map["data"]
        code <- map["code"]
        message <- map["message"]
        status <- map["status"]
    }
}
class UserData: Mappable {
    var id: Int = 0
    var api_token: String = ""
    var country_code: String = ""
    var mobile_no: String = ""
    var email: String = ""
    var quickbox_id: String = ""
    var name: String = ""
    var dob: String = ""
    var gender: String = ""
    var relation_status: String = ""
    var kids: String = ""
    var education: String = ""
    var height: String = ""
    var looking_for: String = ""
    var work_out: String = ""
    var language_id: String = ""
    var religious: String = ""
    var pray: String = ""
    var eating: String = ""
    var smoke: String = ""
    var alcohol: String = ""
    var married_year: String = ""
    var google_id: String = ""
    var facebook_id: String = ""
    var apple_id: String = ""
    var fcm_token: String = ""
    var fcm_id: String = ""
    var device_type: String = ""
    var otp: Int = 0
    var otp_verify: String = ""
    var selfie: String = ""
    var lat: String = ""
    var lng: String = ""
    var address: String = ""
    var city: String = ""
    var country: String = ""
    var state: String = ""
    var update_profile: String = ""
    var is_active: Int = 0
    var reason: String = ""
    var notification: Int = 0
    var created: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var language_name: String = ""
    var age: Int = 0
    var incrementing: String = ""
    var user_image: [User_Image] = []
    var exists: String = ""
    var wasRecentlyCreated: String = ""
    var timestamps: String = ""
    var phone_status: Int = 0
    var is_liked_count: Int = 0
    var is_online: Int = 0
    
    var denomination_name: String = ""
    var denomination_id: String = ""
    var go_church: String = ""
    var room_info: [[String:Any]] = []
    var is_buy_valid_subscription: Int = 0
    var is_buy_valid_subscription_new: String = ""
    var your_zodiac: String = ""
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
       
        id <- map["id"]
        api_token <- map["api_token"]
        country_code <- map["country_code"]
        mobile_no <- map["mobile_no"]
        email <- map["email"]
        quickbox_id <- map["quickbox_id"]
        name <- map["name"]
        dob <- map["dob"]
        gender <- map["gender"]
        relation_status <- map["relation_status"]
        kids <- map["kids"]
        education <- map["education"]
        height <- map["height"]
        looking_for <- map["looking_for"]
        work_out <- map["work_out"]
        language_id <- map["language_id"]
        religious <- map["religious"]
        pray <- map["pray"]
        eating <- map["eating"]
        smoke <- map["smoke"]
        alcohol <- map["alcohol"]
        married_year <- map["married_year"]
        google_id <- map["google_id"]
        facebook_id <- map["facebook_id"]
        apple_id <- map["apple_id"]
        fcm_token <- map["fcm_token"]
        fcm_id <- map["fcm_id"]
        device_type <- map["device_type"]
        otp <- map["otp"]
        otp_verify <- map["otp_verify"]
        selfie <- map["selfie"]
        lat <- map["lat"]
        lng <- map["lng"]
        address <- map["address"]
        city <- map["city"]
        country <- map["country"]
        state <- map["state"]
        update_profile <- map["update_profile"]
        is_active <- map["is_active"]
        reason <- map["reason"]
        notification <- map["notification"]
        created <- map["created"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        language_name <- map["language_name"]
        age <- map["age"]
        incrementing <- map["incrementing"]
        user_image <- map["user_image"]
        exists <- map["exists"]
        wasRecentlyCreated <- map["wasRecentlyCreated"]
        timestamps <- map["timestamps"]
        phone_status <- map["phone_status"]
        is_liked_count <- map["is_liked_count"]
        is_online <- map["is_online"]
        
        denomination_name <- map["denomination_name"]
        denomination_id <- map["denomination_id"]
        go_church <- map["go_church"]
        room_info <- map["room_info"]
        is_buy_valid_subscription <- map["is_buy_valid_subscription"]
        is_buy_valid_subscription_new <- map["is_buy_valid_subscription_new"]
        your_zodiac <- map["your_zodiac"]
    }
}

class User_Image: Mappable {
    var created_at: String = ""
    var id: Int = 0
    var image: String = ""
    var primary: String = ""
    var updated_at: String = ""
    var user_id: String = ""

    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        created_at <- map["created_at"]
        id <- map["id"]
        image <- map["image"]
        primary <- map["primary"]
        updated_at <- map["updated_at"]
        user_id <- map["user_id"]
    
    }
}

