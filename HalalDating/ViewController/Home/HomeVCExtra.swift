//
//  HomeVCExtra.swift
//  HalalDating
//
//  Created by Apple on 16/04/25.
//

import UIKit


//MARK: - QBRTCClientDelegate
//extension HomeVC: QBRTCClientDelegate {
//
//    //audio call
//    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
//
//        if HelperAudioCall.shared.session != nil {
//            // we already have a video/audio call session, so we reject another one
//            // userInfo - the custom user information dictionary for the call from caller. May be nil.
//            let userInfo = ["key":"value"] // optional
//            session.rejectCall(userInfo)
//            return
//        }
//        // saving session instance here
//        HelperAudioCall.shared.session = session
//
//        HelperAudioCall.shared.isCallReceived = true
//
//        getUserDetailsAPI(qbId:"\(session.initiatorID)")
//        HelperAudioCall.shared.playSound()
//
//    }
//
//    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {
//        HelperAudioCall.shared.session = nil
//        cancelTimer()
//        appDelegate.window?.viewWithTag(5001)?.removeFromSuperview()
//        AppHelper.returnTopNavigationController().view.makeToast("No answer".localizableString(lang: Helper.shared.strLanguage))
//        HelperAudioCall.shared.stopSound()
//    }
//
//    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.lblTimer.isHidden = false
//        HelperAudioCall.shared.stopSound()
//        startTimer()
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnAcceptCall.isHidden = true
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnRejectCall.isHidden = true
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnHungUp.isHidden = false
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnMute.isHidden = false
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.isHidden = false
//    }
//
//    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//        print("Rejected by user \(userID)")
//        HelperAudioCall.shared.session = nil
//        cancelTimer()
//        appDelegate.window?.viewWithTag(5001)?.removeFromSuperview()
//        AppHelper.returnTopNavigationController().view.makeToast("Rejected".localizableString(lang: Helper.shared.strLanguage))
//        HelperAudioCall.shared.stopSound()
//    }
//
//    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//
//        HelperAudioCall.shared.session = nil
//        AppHelper.returnTopNavigationController().view.makeToast("Hung up".localizableString(lang: Helper.shared.strLanguage))
//        cancelTimer()
//        appDelegate.window?.viewWithTag(5001)?.removeFromSuperview()
//    }
//
//    //this method gets called when our app in background and opponent hang up call
//    func session(_ session: QBRTCBaseSession, didChangeRconnectionState state: QBRTCReconnectionState, forUser userID: NSNumber) {
//
//        let state = UIApplication.shared.applicationState
//        if state == .background {
//            print("App in Background")
//            HelperAudioCall.shared.session = nil
//            //AppHelper.returnTopNavigationController().view.makeToast("Hung up".localizableString(lang: Helper.shared.strLanguage))
//            cancelTimer()
//            appDelegate.window?.viewWithTag(5001)?.removeFromSuperview()
//        }
//
//    }
//}


//MARK: - Other Methosd
//extension HomeVC {
//    func getAllDialogs() {
//
//        //get dialogs that have been updated during the last month and sort by the date of the last message in descending order
//        //let monthAgoDate = Calendar.current.date( byAdding: .month, value: -1, to: Date())
//        //let timeInterval = monthAgoDate!.timeIntervalSince1970
//
//        let paramSort = "sort_desc"
//        let sortValue = "last_message_date_sent"
//        //let paramFilter = "updated_at[gte]"
//        //let filterValue = "\(timeInterval)"
//
//        var extendedRequest: [String: String] = [:]
//        extendedRequest[paramSort] = sortValue
//        //extendedRequest[paramFilter] = filterValue
//        let responsePage = QBResponsePage(limit: 0)
//
//        QBRequest.dialogs(for: responsePage, extendedRequest: extendedRequest, successBlock: { response, dialogs, dialogsUsersIDs, page in
//
//            print(dialogs)
//            self.arrDialogs = dialogs
//
//            //
//            DispatchQueue.global(qos: .userInitiated).async {
//                print("This is run on a background queue")
//                self.newMatchesAPI()
//            }
//        }, errorBlock: { response in
//
//        })
//    }
//
//    func createDialog(userId:UInt) {
//
//        let num = NSNumber(value: userId)
//        let num2 = NSNumber(value: QBSession.current.currentUser!.id)
//
//        let chatDialog = QBChatDialog(dialogID: nil, type: .group)
//        chatDialog.name = "direct_chat \(num2)"//"New group dialog"
//        chatDialog.occupantIDs = [num,num2]
//        Photo can be a link to a file in Content module, Custom Objects module or just a web link.
//        dialog.photo = "...";
//
//        QBRequest.createDialog(chatDialog, successBlock: { (response, dialog) in
//            dialog.join(completionBlock: { (error) in
//            })
//            print(response)
//            print(dialog)
//
//            let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
//            vc.dictReceiver = dialog
//            self.navigationController?.pushViewController(vc, animated: true)
//        }, errorBlock: { (response) in
//
//        })
//
//        let dialog = QBChatDialog(dialogID: nil, type: .private)
//        dialog.occupantIDs = [num]
//        QBRequest.createDialog(dialog, successBlock: { (response, createdDialog) in
//
//            print(createdDialog)
//        }, errorBlock: { (response) in
//            print(response)
//        })
//    }
//
//    func apiCallUserLikeDislike(like: String, op_user_id: String, index: Int) {
//        // Check network reachability
//        guard NetworkReachabilityManager()?.isReachable == true else {
//            let alert = UIAlertController(
//                title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage),
//                message: internetConnected,
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(
//                title: "OK".localizableString(lang: Helper.shared.strLanguage),
//                style: .default
//            ))
//            present(alert, animated: true)
//            return
//        }
//
//        // Prepare parameters
//        let dicParam: [String: Any] = [
//            "op_user_id": op_user_id,
//            "flag": like,
//            "plan_purchased": ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new ?? ""
//        ]
//
//        let userModel = Login_LocalDB.getLoginUserModel()
//
//        // Make API call with proper error handling
//        AF.request(a_userLikeDislike,
//                   method: .post,
//                   parameters: dicParam,
//                   encoding: JSONEncoding.default,
//                   headers: ["Authorization": userModel.data?.api_token ?? ""])
//        .validate()
//        .responseData { [weak self] response in
//            guard let self = self else { return }
//            self.view.isUserInteractionEnabled = true
//
//            switch response.result {
//            case .success(let data):
//                // Log raw response for debugging
//                if let rawString = String(data: data, encoding: .utf8) {
//                    print("Raw Response: \(rawString)")
//                }
//
//                do {
//                    // First, try to clean the response data
//                    let cleanedData: Data
//                    if let rawString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
//                       let cleanData = rawString.data(using: .utf8) {
//                        cleanedData = cleanData
//                    } else {
//                        cleanedData = data
//                    }
//
//                    // Try to parse as dictionary first
//                    let responseDict = try JSONSerialization.jsonObject(with: cleanedData, options: []) as? [String: Any] ?? [:]
//
//                    // Replace null values with empty string
//                    let cleanDict = responseDict.replaceNulls(with: "")
//
//                    // Create model from cleaned dictionary
//                    if let userLikeDislikeModel = UserLikeDislikeModel(JSON: cleanDict) {
//                        // Handle response based on code
//                        switch userLikeDislikeModel.code {
//                        case 200:
//                            if like == "0" {
//                                self.kolodaView?.swipe(.right)
//                            } else {
//                                self.kolodaView?.swipe(.left)
//                            }
//
//                        case 401:
//                            AppHelper.Logout(navigationController: self.navigationController!)
//
//                        case 201:
//                            let obj = UIStoryboard(name: "Main", bundle: nil)
//                                .instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
//                            obj.strSubscriptionType = "Premium"
//                            obj.type_subscription = SubscriptionType.chat_swipe
//                            self.navigationController?.pushViewController(obj, animated: true)
//
//                        case 202:
//                            if let index = self.arrUserList.firstIndex(where: { $0.id == Int(op_user_id) }) {
//                                self.kolodaView?.swipe(.left)
//
//                                let obj = UIStoryboard(name: "Main", bundle: nil)
//                                    .instantiateViewController(withIdentifier: "MatchVC") as! MatchVC
//                                obj.userModel = self.arrUserList[index]
//                                obj.strReceiverId = op_user_id
//                                obj.delegate = self
//                                obj.modalPresentationStyle = .overFullScreen
//                                self.present(obj, animated: true)
//                            }
//
//                        default:
//                            if let message = cleanDict["message"] as? String {
//                                self.view.makeToast(message)
//                            }
//                        }
//                    } else {
//                        self.view.makeToast("Failed to parse response")
//                    }
//                } catch {
//                    print("JSON Parsing Error: \(error)")
//                    self.view.makeToast("Failed to process response")
//                }
//
//            case .failure(let error):
//                print("API Error: \(error)")
//
//                // Handle specific AFError cases
//                if let afError = error.asAFError {
//                    switch afError {
//                    case .responseSerializationFailed(let reason):
//                        print("Serialization Failed: \(reason)")
//                        // Try to get error message from response
//                        if let data = response.data,
//                           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                           let message = json["message"] as? String {
//                            self.view.makeToast(message)
//                            return
//                        }
//                    default:
//                        break
//                    }
//                }
//
//                self.view.makeToast(error.localizedDescription)
//            }
//        }
//    }
//
//    //    if dialog isnot created between two matches then creates it here
//    func newMatchesAPI() {
//
//        if NetworkReachabilityManager()!.isReachable == false
//        {
//            return
//        }
//
//        let userModel = Login_LocalDB.getLoginUserModel()
//
//        let params = ["flag":"1"]
//
//        let headers:HTTPHeaders = ["Accept":"application/json",
//                                   "Authorization":userModel.data?.api_token ?? ""]
//
//        AF.request(new_matches, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
//
//            //print(response)
//
//            if let json = response.value as? [String:Any] {
//
//                if json["status"] as? String == "Success" {
//
//                    let arr = json["data"] as? [[String:Any]]
//
//                    //dispatchGroup is for async task in for loop
//                    let group = DispatchGroup()
//
//                    var counter = 0
//
//                    for i in 0..<(arr?.count ?? 0) {
//                        group.enter()
//
//                        let str = arr?[i]["quickbox_id"] as? String
//
//                        if str != "" && str != nil {
//                            self.createDialog1(quickbox_id: str!, index: i) { result in
//                                defer { group.leave() }
//                                print(result)
//                                counter += 1
//                            }
//                        } else {
//                            defer { group.leave() }
//                            counter += 1
//                        }
//                    }
//
//                    group.notify(queue: DispatchQueue.main) {
//                        print("All tasks done - \(counter)")
//                    }
//
//                }
//            }
//        }
//    }
//
//    func apiCall_userLikeDislike(like: String, op_user_id: String, customSwipe: String, index:Int) {
//
//        if NetworkReachabilityManager()!.isReachable == false
//        {
//            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else
//        {
//            //--
//            let dicParam:[String:AnyObject] = ["op_user_id":op_user_id as AnyObject,
//                                               "flag":like as AnyObject,
//                                               "plan_purchased":ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new as AnyObject]
//            let userModel = Login_LocalDB.getLoginUserModel()
//            //AppHelper.showLinearProgress()
//            //self.view.isUserInteractionEnabled = false
//            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_userLikeDislike, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
//                self.view.isUserInteractionEnabled = true
//                //AppHelper.hideLinearProgress()
//                let dicsResponseFinal = response.replaceNulls(with: "")
//                print(dicsResponseFinal as Any)
//
//                let userLikeDislikeModel = UserLikeDislikeModel(JSON: dicsResponseFinal as! [String : Any])!
//                if userLikeDislikeModel.code == 200{
//                    //                    if customSwipe == "1"{
//                    //                        if like == "0"{
//                    //                            kolodaView.swipe(.right)
//                    //                        }else if like == "1"{
//                    //                            kolodaView.swipe(.left)
//                    //                        }
//                    //                    }
//
//                }else if userLikeDislikeModel.code == 401{
//                    AppHelper.Logout(navigationController: self.navigationController!)
//                } else if userLikeDislikeModel.code == 201{
//
//                    //                    resetKolodaView(index:index)
//
//                    //
//                    arrFlag[index] = 0
//                    self.collview.reloadData()
//
//                    //
//                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
//                    //                    obj.strSubscriptionType = "Gold"
//                    //                    obj.type_subscription = SubscriptionType.swipe
//                    obj.strSubscriptionType = "Premium"
//                    obj.type_subscription = SubscriptionType.chat_swipe
//                    navigationController?.pushViewController(obj, animated: true)
//                } else if userLikeDislikeModel.code == 202 {
//
//                    let index1 = arrUserList.firstIndex { $0.id ==  Int(op_user_id)}
//
//                    if index1 != nil {
//
//                        //
//                        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchVC") as! MatchVC
//                        obj.userModel = arrUserList[index1!]
//                        obj.strReceiverId = op_user_id
//                        obj.delegate = self
//                        obj.modalPresentationStyle = .overFullScreen
//                        self.present(obj, animated: true, completion: nil)
//                    }
//
//                } else{
//                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
//                }
//            }) { (error) in
//                print(error)
//                self.view.isUserInteractionEnabled = true
//                //AppHelper.hideLinearProgress()
//            }
//        }
//    }
//
//
//    func getNotificationsAPI() {
//
//        if NetworkReachabilityManager()!.isReachable == false
//        {
//            return
//        }
//        //AppHelper.showLinearProgress()
//
//        let userModel = Login_LocalDB.getLoginUserModel()
//
//        let dicParams:[String:Any] = ["user_id":userModel.data?.id ?? 0]
//
//
//        let headers:HTTPHeaders = ["Accept":"application/json"]
//
//        AF.request(user_notification, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
//
//            print(response)
//
//            if let json = response.value as? [String:Any] {
//
//                if json["status"] as? String == "Success" {
//
//                    self.arr = json["data"] as? [[String:Any]] ?? []
//
//                    DispatchQueue.main.async {
//
//                        self.setChatTabNotificationBadge()
//                    }
//
//                }
//            }
//            //AppHelper.hideLinearProgress()
//        }
//    }
//
//
//    func getNotificationsAPI() {
//
//        if NetworkReachabilityManager()!.isReachable == false
//        {
//            return
//        }
//        //AppHelper.showLinearProgress()
//
//        let userModel = Login_LocalDB.getLoginUserModel()
//
//        let dicParams:[String:Any] = ["user_id":userModel.data?.id ?? 0]
//
//
//        let headers:HTTPHeaders = ["Accept":"application/json"]
//
//        AF.request(user_notification, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
//
//            print(response)
//
//            if let json = response.value as? [String:Any] {
//
//                if json["status"] as? String == "Success" {
//
//                    self.arr = json["data"] as? [[String:Any]] ?? []
//
//                    DispatchQueue.main.async {
//
//                        self.setChatTabNotificationBadge()
//                    }
//
//                }
//            }
//            //AppHelper.hideLinearProgress()
//        }
//    }
//
//
//    func getUserDetailsAPI(qbId:String) {
//
//        if NetworkReachabilityManager()!.isReachable == false
//        {
//            return
//        }
//
//        let dicParams:[String:String] = ["quickbox_id":qbId]
//        AppHelper.showLinearProgress()
//
//        let userModel = Login_LocalDB.getLoginUserModel()
//
//        let headers:HTTPHeaders = ["Accept":"application/json",
//                                   "Authorization":userModel.data?.api_token ?? ""]
//
//        AF.request(detail_by_quickbox, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
//
//            print(response)
//
//            if let json = response.value as? [String:Any] {
//
//                if json["status"] as? String == "Success" {
//
//                    let dict = json["data"] as? [String:Any]
//
//                    var imgName = ""
//                    if (dict?["user_image"] as? [[String:Any]])?.count != 0{
//                        let img = (dict?["user_image"] as? [[String:Any]])?[0]["image"] as? String
//                        imgName = "\(kImageBaseURL)\(img ?? "")".replacingOccurrences(of: " ", with: "%20")
//
//                    }
//
//                    self.openAudioCallView(img:imgName, name:dict?["name"] as? String ?? "")
//                }
//            }
//
//            AppHelper.hideLinearProgress()
//        }
//    }
//}


//MARK: - Call methods
//extension HomeVC {
//    //MARK: - Function
//    //audio call
//    //EDIT
//    func openAudioCallView(img:String, name:String) {
//
//        let customView = Bundle.main.loadNibNamed("AudioCallView", owner: self)?.first as? AudioCallView
//        customView?.tag = 5001
//        customView?.frame = view.bounds
//        if HelperAudioCall.shared.isCallReceived {
//            customView?.btnAcceptCall.isHidden = false
//            customView?.btnRejectCall.isHidden = false
//            customView?.btnHungUp.isHidden = true
//        } else {
//            customView?.btnAcceptCall.isHidden = true
//            customView?.btnRejectCall.isHidden = false
//            customView?.btnHungUp.isHidden = true
//        }
//
//        customView?.lblName.text = name
//        customView?.imgUser.sd_setImage(with: URL(string: img))
//
//        customView?.btnRejectCall.addTarget(self, action: #selector(btnRejectCall), for: .touchUpInside)
//        customView?.btnAcceptCall.addTarget(self, action: #selector(btnAcceptCall), for: .touchUpInside)
//        customView?.btnHungUp.addTarget(self, action: #selector(btnHungUpCall), for: .touchUpInside)
//        customView?.btnMute.addTarget(self, action: #selector(btnMuteCall), for: .touchUpInside)
//        customView?.btnSpeaker.addTarget(self, action: #selector(btnSpeakerCall), for: .touchUpInside)
//        self.view.addSubview(customView!)
//
//
//        appDelegate.window?.rootViewController = obj
//        appDelegate.window?.addSubview(customView!)
//
//    }
//
//    @objc func btnRejectCall() {
//
//        HelperAudioCall.shared.stopSound()
//
//        userInfo - the custom user information dictionary for the reject call. May be nil.
//                                                                let userInfo = ["key":"value"] // optional
//                                                                HelperAudioCall.shared.session?.rejectCall(userInfo)
//
//                                                                and release session instance
//                                                                HelperAudioCall.shared.session = nil
//                                                                appDelegate.window?.viewWithTag(5001)?.removeFromSuperview()
//                                                                cancelTimer()
//    }
//    @objc func btnAcceptCall() {
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.lblTimer.isHidden = false
//        HelperAudioCall.shared.stopSound()
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnAcceptCall.isHidden = true
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnRejectCall.isHidden = true
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnHungUp.isHidden = false
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnMute.isHidden = false
//        (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.isHidden = false
//
//        userInfo - the custom user information dictionary for the accept call. May be nil.
//                                                                let userInfo = ["key":"value"] // optional
//                                                                HelperAudioCall.shared.session?.acceptCall(userInfo)
//                                                                startTimer()
//    }
//    @objc func btnHungUpCall() {
//
//        userInfo - the custom user information dictionary for the reject call. May be nil.
//                                                                let userInfo = ["key":"value"] // optional
//                                                                HelperAudioCall.shared.session?.hangUp(userInfo)
//
//                                                                and release session instance
//                                                                HelperAudioCall.shared.session = nil
//                                                                appDelegate.window?.viewWithTag(5001)?.removeFromSuperview()
//                                                                cancelTimer()
//    }
//    @objc func btnMuteCall() {
//
//
//        if HelperAudioCall.shared.session?.localMediaStream.audioTrack.isEnabled == true {
//            (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnMute.setImage(#imageLiteral(resourceName: "mic-off"), for: .normal)
//        } else {
//            (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnMute.setImage(#imageLiteral(resourceName: "mic-on"), for: .normal)
//        }
//
//        HelperAudioCall.shared.session?.localMediaStream.audioTrack.isEnabled = !(HelperAudioCall.shared.session?.localMediaStream.audioTrack.isEnabled)!
//    }
//    @objc func btnSpeakerCall() {
//
//        if (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.tag == 0 {
//            (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.tag = 1
//            (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.setImage(#imageLiteral(resourceName: "speaker-on"), for: .normal)
//
//            let isActive = true
//            audioSession.setActive(isActive)
//
//            let speaker: AVAudioSession.PortOverride = .speaker
//            audioSession.overrideOutputAudioPort(speaker)
//
//        } else {
//            (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.tag = 0
//            (appDelegate.window?.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.setImage(#imageLiteral(resourceName: "speaker-off"), for: .normal)
//
//            let isActive = false
//            audioSession.setActive(isActive)
//            let receiver: AVAudioSession.PortOverride = .none
//            audioSession.overrideOutputAudioPort(receiver)
//        }
//
//    }
//
//    func startTimer() {
//        counter = 0
//        timer.invalidate() // just in case this button is tapped multiple times
//
//        start the timer
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//    }
//
//    stop timer
//    func cancelTimer() {
//        timer.invalidate()
//    }
//
//    @objc func timerAction() {
//        counter += 1
//
//        if appDelegate.window?.viewWithTag(5001) != nil {
//            (appDelegate.window?.viewWithTag(5001) as! AudioCallView).lblTimer.text = dateFormatter.string(from: counter)!
//        }
//
//    }
//    //    EDIT
//    func processChat(quickbox_id:String) {
//
//        let user = NSNumber(value: QBSession.current.currentUser!.id)
//        let receiver = NSNumber(value: UInt(Int(quickbox_id)!))
//
//        let arr:[NSNumber] = [receiver,user]
//
//        let index = arrDialogs?.firstIndex{$0.occupantIDs == arr}
//
//        if let _ = index {
//
//            //go to chat screen
//
//            let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
//            vc.dictReceiver = arrDialogs?[index!]
//            self.navigationController?.pushViewController(vc, animated: true)
//            //print(arrDialogs?[index!])
//        } else {
//
//            let arr2:[NSNumber] = [user,receiver]
//
//            let index2 = arrDialogs?.firstIndex{$0.occupantIDs == arr2}
//
//            if let _ = index2 {
//
//                //go to chat screen
//                let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
//                vc.dictReceiver = arrDialogs?[index2!]
//                self.navigationController?.pushViewController(vc, animated: true)
//                //print(arrDialogs?[index2!])
//            } else {
//
//                //create
//                createDialog(userId: UInt(Int(quickbox_id)!))
//            }
//        }
//
//    }
//
//    func setChatTabNotificationBadge() {
//
//        if let cnt = UserDefaults.standard.value(forKey: "notiBadgeCount") as? Int {
//
//            if self.arr != nil && self.arr.count != 0 {
//
//                if self.arr.count != cnt {
//
//                    if let tabItems = self.tabBarController?.tabBar.items {
//                        let tabItem = tabItems[2]
//
//                        Helper.shared.getUnreadMsgCount { count in
//                            tabItem.badgeValue = "\((self.arr.count-cnt)+count)"
//                        }
//                    }
//
//                } else {
//                    Helper.shared.setUnreadMsgCount(vc: self)
//                }
//            } else {
//                Helper.shared.setUnreadMsgCount(vc: self)
//            }
//        } else {
//            Helper.shared.setUnreadMsgCount(vc: self)
//            UserDefaults.standard.setValue(self.arr.count, forKey: "notiBadgeCount")
//            UserDefaults.standard.synchronize()
//        }
//    }
//}
