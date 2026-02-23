//
//  SubscriptionModel.swift
//  HalalDating
//
//  Created by Maulik Vora on 07/12/21.
//

import Foundation
import ObjectMapper

class SubscriptionModel: Mappable {
    
    var data: SubscriptionData?
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

class SubscriptionData: Mappable {
    
    var current_time: Int = 0
    var remain_time: String = "0"
    var current_date_time: String = ""
    var end_date_time: String = ""
    var plan:[SubscriptionPlan] = []
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
    
        current_time <- map["current_time"]
        remain_time <- map["remain_time"]
        current_date_time <- map["current_date_time"]
        end_date_time <- map["end_date_time"]
        plan <- map["plan"]
        
    }
}
class SubscriptionPlan: Mappable {
    var created_at: String = ""
    var description: String = ""
    var discount: String = ""
    var id: Int = 0
    var image: String = ""
    var per_month: String = ""
    var price: Int = 0
    var time: Int = 0
    var time_period: String = ""
    var title: String = ""
    var type: String = ""
    var updated_at: String = ""
    
    var isSelect = false
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
    
        created_at <- map["created_at"]
        description <- map["description"]
        discount <- map["discount"]
        id <- map["id"]
        image <- map["image"]
        per_month <- map["per_month"]
        price <- map["price"]
        time <- map["time"]
        time_period <- map["time_period"]
        title <- map["title"]
        type <- map["type"]
        updated_at <- map["updated_at"]
        
    
    }
}
