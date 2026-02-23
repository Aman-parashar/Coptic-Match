//
//  Quickblox_Session.swift
//  JustMyType
//
//  Created by Maulik Vinodbhai Vora on 30/05/20.
//  Copyright © 2020 Maulik Vora. All rights reserved.
//

import Foundation
import Quickblox


//MARK:- connectToChat
func ConnectToChat_Quickblox(userid: UInt, completion: @escaping (_ isResponse:Bool)->Void, errorBlock: @escaping (_ response:Error)->Void)  {
    
    QBChat.instance.connect(withUserID: userid, password: Validation.LoginConstant.defaultPassword, completion: { error in
        if let error = error {
            errorBlock(error)
        } else {
            completion(true)
            registerForRemoteNotifications()
        }
    })
}


/*func createOneToOneDialog(arrIds:[Int], completion: @escaping (_ dialog:QBChatDialog)->Void, errorBlock: @escaping (_ response:Error)->Void){
    let dialog = QBChatDialog(dialogID: nil, type: .private)
    dialog.occupantIDs = arrIds as [NSNumber]
    QBRequest.createDialog(dialog, successBlock: { (response, createdDialog) in
        print(createdDialog)
        completion(createdDialog)
    }, errorBlock: { (response) in
        print(response)
    })
}

func retrieveListOfDialogs(completion: @escaping (_ response:[QBChatDialog])->Void, errorBlock: @escaping (_ response:Error)->Void)  {
    QBRequest.dialogs(for: QBResponsePage(limit: 50, skip: 100), extendedRequest: nil, successBlock: { (response, dialogs, dialogsUsersIDs, page) in
        print(dialogs)
        completion(dialogs)
    }, errorBlock: { (response) in
        print(response)
    })
}*/
