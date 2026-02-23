//
//  Quickblox_Authantication.swift
//  JustMyType
//
//  Created by Maulik Vinodbhai Vora on 30/05/20.
//  Copyright © 2020 Maulik Vora. All rights reserved.
//

import Foundation
import Quickblox
import QuickbloxWebRTC


//MARK:- Constant Value
var is_open_chat_screen = false
struct CredentialsConstant_Quickblox {
    static let applicationID:UInt = 94501
    static let authKey = "A7e777ubVdsjgzP"
    static let authSecret = "q8g2WFB23MQHzeO"
    static let accountKey = "zEdtD9YuzWdJzb8xCDM7"
}
struct TimeIntervalConstant {
    static let answerTimeInterval: TimeInterval = 60.0
    static let dialingTimeInterval: TimeInterval = 5.0
}
struct AppDelegateConstant {
    static let enableStatsReports: UInt = 1
}

//MARK: - Connect/Disconnect
func connect(completion: QBChatCompletionBlock? = nil) {
    let currentUser = Profile()
    
    guard currentUser.isFull == true else {
        completion?(NSError(domain: Validation.LoginConstant.chatServiceDomain,
                            code: Validation.LoginConstant.errorDomaimCode,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Please enter your login and username."
        ]))
        return
    }
    if QBChat.instance.isConnected == true {
        completion?(nil)
        registerForRemoteNotifications()
    } else {
        QBSettings.autoReconnectEnabled = true
        QBChat.instance.connect(withUserID: currentUser.ID, password: currentUser.password, completion: completion)
        registerForRemoteNotifications()
    }
}

func disconnect(completion: QBChatCompletionBlock? = nil) {
    QBChat.instance.disconnect(completionBlock: completion)
}

func registerForRemoteNotifications() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: { granted, error in
        if let error = error {
            // debugPrint("[AuthorizationViewController] registerForRemoteNotifications error: \(error.localizedDescription)")
            return
        }
        center.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus != .authorized {
                return
            }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        })
    })
}

//MARK:- INIT Chat
func initChat_Quickblox()  {
    //----
    QBSettings.applicationID = CredentialsConstant_Quickblox.applicationID
    QBSettings.authKey = CredentialsConstant_Quickblox.authKey
    QBSettings.authSecret = CredentialsConstant_Quickblox.authSecret
    QBSettings.accountKey = CredentialsConstant_Quickblox.accountKey
    // enabling carbons for chat
    QBSettings.carbonsEnabled = true
    // Enables Quickblox REST API calls debug console output.
    QBSettings.logLevel = .debug
    // Enables detailed XMPP logging in console output.
    QBSettings.enableXMPPLogging()
    
    //----
    QBSettings.autoReconnectEnabled = true
    QBSettings.logLevel = QBLogLevel.debug
    QBSettings.enableXMPPLogging()
    QBRTCConfig.setAnswerTimeInterval(TimeIntervalConstant.answerTimeInterval)
    QBRTCConfig.setDialingTimeInterval(TimeIntervalConstant.dialingTimeInterval)
    QBRTCConfig.setLogLevel(QBRTCLogLevel.verbose)
    
    if AppDelegateConstant.enableStatsReports == 1 {
        QBRTCConfig.setStatsReportTimeInterval(1.0)
    }
    
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
    QBRTCClient.initializeRTC()
}


//MARK:- SIGN UP
func Signup_Quickblox(fullName: String, phone: String, customData: String, completion: @escaping (_ response:QBResponse, _ user:QBUUser)->Void, errorBlock: @escaping (_ response:QBResponse)->Void)  {
    
    let newUser = QBUUser()
    newUser.fullName = fullName
    newUser.password = Validation.LoginConstant.defaultPassword
    newUser.login = phone
    newUser.customData = customData
    QBRequest.signUp(newUser, successBlock: {response, user in
        //--
        completion(response, user)
    }, errorBlock: { response in
        SVProgressHUD.dismiss()
        //        if response.status == QBResponseStatusCode.validationFailed {
        //            // The user with existent login was created earlier
        //
        //            return
        //        }
        print(response)
        errorBlock(response)
    })
}


//MARK:- Login
func Login_Quickblox(login: String, completion: @escaping (_ response:QBResponse, _ user:QBUUser)->Void, errorBlock: @escaping (_ response:QBResponse)->Void)  {
    
    QBRequest.logIn(withUserLogin: login, password: Validation.LoginConstant.defaultPassword, successBlock: { (response, user) in
        //--
        user.updatedAt = Date()
        Profile.synchronize(user)
        
        //--
        //updateFullName(fullName: Login_LocalDB.getLoginUserInfo(key: Login_UserKey.name))
        
        //--
        completion(response, user)
    }) { (response) in
        
        //--
        errorBlock(response)
    }
    
}

//MARK:- Update name
func updateFullName(fullName: String) {
    //SVProgressHUD.show()
    let updateUserParameter = QBUpdateUserParameters()
    updateUserParameter.fullName = fullName
    updateUserParameter.customData = ""//Login_LocalDB.getLoginUserInfo(key: Login_UserKey.image)
    QBRequest.updateCurrentUser(updateUserParameter, successBlock: { response, user in
        //--
        Profile.update(user)
        
        //self.connectToChat(user: user)
        }, errorBlock: { response in
            //self?.handleError(response.error?.error, domain: ErrorDomain.signUp)
    })
}
