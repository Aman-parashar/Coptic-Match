//
//  UserLikeDislikeModel.swift
//  HalalDating
//
//  Created by Maulik Vora on 06/12/21.
//

import Foundation
import ObjectMapper

class UserLikeDislikeModel: Mappable {
    
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
        data <- map["data"]
        code <- map["code"]
        message <- map["message"]
        status <- map["status"]
    }
}

//class UserLikeDislikeData: Mappable {
//    
//    
//    
//    required init?(map: Map) {
//    }
//    
//    // Mappable
//    func mapping(map: Map) {
//    
//        
//    
//    }
//}
