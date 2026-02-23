//
//  Validation.swift
//  Custome_Chat
//
//  Created by Maulik Vinodbhai Vora on 08/12/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//

import UIKit

class Validation: NSObject {

    struct LoginNameRegularExtention {
        static let username = "^[^_][\\w\\u00C0-\\u1FFF\\u2C00-\\uD7FF\\s]{2,19}$"
        static let login = "^[a-zA-Z][a-zA-Z0-9]{7,14}$"
    }
    
    struct LoginConstant {
        static let notSatisfyingDeviceToken = "Invalid parameter not satisfying: deviceToken != nil"
        static let enterToChat = NSLocalizedString("Enter to chat", comment: "")
        static let fullNameDidChange = NSLocalizedString("Full Name Did Change", comment: "")
        static let login = NSLocalizedString("Login", comment: "")
        static let checkInternet = NSLocalizedString("Please check your Internet connection", comment: "")
        static let enterUsername = NSLocalizedString("Please enter your login and username.", comment: "")
        static let shouldContainAlphanumeric = NSLocalizedString("Field should contain alphanumeric characters only in a range 3 to 20. The first character must be a letter.", comment: "")
        static let shouldContainAlphanumericWithoutSpace = NSLocalizedString("Field should contain alphanumeric characters only in a range 8 to 15, without space. The first character must be a letter.", comment: "")
        static let showDialogs = "ShowDialogsViewController"
        static let defaultPassword = "quickblox"
        static let infoSegue = "ShowInfoScreen"
        
        static let chatServiceDomain = "com.q-municate.chatservice"
        static let errorDomaimCode = -1000
    }
    
    struct LoginStatusConstant {
        static let signUp = "Signg up ..."
        static let intoChat = "Login into chat ..."
        static let withCurrentUser = "Login with current user ..."
    }
    
    enum ErrorDomain: UInt {
        case signUp
        case logIn
        case logOut
        case chat
    }
    
    
   
    
}
