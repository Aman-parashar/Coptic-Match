//
//  Login_LocalDB.swift
//  DatingApp
//
//  Created by Maulik Vinodbhai Vora on 24/09/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//

import Foundation
struct Login_UserKey {
    static let address: String = "address"
    
    
}

class Login_LocalDB: NSObject
{
    class func saveLoginInfo(strData: String)
    {
        //--
        UserDefaults.standard.set(strData, forKey: "login_response")
        UserDefaults.standard.synchronize()
    }
    class func getLoginUserModel() -> UserModel
    {
        let login_response = UserDefaults.standard.object(forKey: "login_response") as? String ?? ""
        if login_response.count != 0
        {
            return UserModel(JSONString: login_response)!
        }
        else
        {
            return UserModel()
        }
    }

    
}

class ManageSubscriptionInfo: NSObject
{
    class func saveSubscriptionInfo(strData: String)
    {
        //--
        UserDefaults.standard.set(strData, forKey: "CheckSubscription")
        UserDefaults.standard.synchronize()
    }
    class func getSubscriptionModel() -> CheckSubscriptionModel
    {
        let checkSub_response = UserDefaults.standard.object(forKey: "CheckSubscription") as? String ?? ""
        if checkSub_response.count != 0
        {
            return CheckSubscriptionModel(JSONString: checkSub_response)!
        }
        else
        {
            return CheckSubscriptionModel()
        }
    }

    
}
