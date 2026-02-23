//
//  SupportingFile.swift
//  Custome_Chat
//
//  Created by Maulik Vinodbhai Vora on 12/12/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//

import Foundation
import Quickblox


var select_dialog:QBChatDialog?
var select_QBUserForChat = QBUUser()

struct UsersConstant {
    static let pageSize: UInt = 50
    static let aps = "aps"
    static let alert = "alert"
    static let voipEvent = "VOIPCall"
}
struct UsersSegueConstant {
       static let settings = "PresentSettingsViewController"
       static let call = "CallViewController"
       static let sceneAuth = "SceneSegueAuth"
}
struct UsersAlertConstant {
    static let checkInternet = NSLocalizedString("Please check your Internet connection", comment: "")
    static let okAction = NSLocalizedString("Ok".localizableString(lang: Helper.shared.strLanguage), comment: "")
    static let shouldLogin = NSLocalizedString("You should login to use VideoChat API. Session hasn’t been created. Please try to relogin.", comment: "")
    static let logout = NSLocalizedString("Logout...", comment: "")
}




