//
//  LanguageModel.swift
//  HalalDating
//
//  Created by Maulik Vora on 01/12/21.
//

import Foundation
import ObjectMapper

class LanguageModel: Mappable {
    
    var data: [LanguageData] = []
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

class LanguageData: Mappable {
    
    var id: Int = 0
    var name: String = ""
    var created_at: String = ""
    var updated_at: String = ""

    var isSelect = false
    

    init() {
    }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
    
        id <- map["id"]
        name <- map["name"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    
    }
}


