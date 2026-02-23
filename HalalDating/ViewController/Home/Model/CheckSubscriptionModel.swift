//
//  CheckSubscriptionModel.swift
//  HalalDating
//
//  Created by Maulik Vora on 06/12/21.
//

import Foundation
import ObjectMapper

class CheckSubscriptionModel: Mappable {
    
    var data: CheckSubscriptionData?
    var code: Int = 0
    var message: String = ""
    var status: String = ""
    
    init() {
    }

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        data <- map["data"]
        code <- map["code"]
        message <- map["message"]
        status <- map["status"]
    }
}

class CheckSubscriptionData: Mappable {
    
    var is_buy_valid_subscription: String = "0"
    var type: String = ""
    var is_buy_valid_subscription_new: String = "0"
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
    
        is_buy_valid_subscription <- map["is_buy_valid_subscription"]
        type <- map["type"]
        is_buy_valid_subscription_new <- map["is_buy_valid_subscription_new"]
    
    }
}

