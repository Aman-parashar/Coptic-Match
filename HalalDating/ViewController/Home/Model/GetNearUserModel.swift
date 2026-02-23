//
//  GetNearUserModel.swift
//  HalalDating
//
//  Created by Apple on 28/02/23.
//

import Foundation
import ObjectMapper

class GetNearUserResponse: Mappable {
    
    var data: [GetNearUserData]?
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
class GetNearUserData: Mappable {
    
    var userlist: [UserData]?
    var page:[String:Any]?
    
    
    init() {
    }

    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        userlist <- map["userlist"]
        page <- map["page"]
        
    }
}
