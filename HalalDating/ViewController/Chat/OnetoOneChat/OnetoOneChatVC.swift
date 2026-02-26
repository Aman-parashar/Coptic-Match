//
//  OnetoOneChatVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit
import IQKeyboardManagerSwift
import Popover
//import Quickblox
//import QuickbloxWebRTC
import FirebaseFirestore
import UserNotifications
import Alamofire

class OnetoOneChatVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewBgMsg_Bottom: NSLayoutConstraint!
    @IBOutlet var viewbg_menu: UIView!
    @IBOutlet var viewbg_BlockConfirmation: UIView!
    @IBOutlet weak var btnBlock_popup: UIButton!
    @IBOutlet weak var lblMessage_BlockPopup: UILabel!
    @IBOutlet weak var lblTitle_BlockPopup: UILabel!
    @IBOutlet weak var btnBlock_menu: UIButton!
    @IBOutlet weak var btnReport_Menu: UIButton!
    
    @IBOutlet var viewbg_reportPopup2: UIView!
    @IBOutlet var viewbg_reportPopup: UIView!
    @IBOutlet weak var lblTitle_reportPopup: UILabel!
    @IBOutlet weak var lblTitle1_reportPopup: UILabel!
    @IBOutlet weak var lblTitle_reportPopup2: UILabel!
    @IBOutlet weak var lblTitle1_reportPopup2: UILabel!
    @IBOutlet weak var tblList_reportPopup: UITableView!
    @IBOutlet weak var tblList_reportPopup2: UITableView!
    @IBOutlet weak var lblTyping: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnUnmatch_menu: UIButton!
    @IBOutlet weak var viewHeader_BlockPopup: UIView!
    @IBOutlet weak var viewHeader_ReportPopup: UIView!
    @IBOutlet weak var viewHeader_reportPopup2: UIView!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblHeaderLocation: UILabel!
    @IBOutlet weak var bottomSheetBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMessageLimitWarning: UILabel!
    
    @IBOutlet weak var btnSendMessage: UIButton!
    
    
    //MARK: - Veriable
    var strReportType = ""
    var popover = Popover()
    var strRoomId:String = ""
    var strLegacyRoomId:String = ""
    var strReceiverId:String = ""
    var isCallFirstTime = true
    var timer = Timer()
    var messageListener: ListenerRegistration?
    var intMsgCount = 0
    var dictOpponentUserData:UserData?
    var delegate:ProfileDetails?
    
    var fromSayHiBtn = false
    var isOnline = false
    //EDIT
    //    var dictReceiver:QBChatDialog?
    //    var arrMsgs:[QBChatMessage]?
    //    var groupDialog: QBChatDialog!
    var arrMessages:[[String:Any]]?
    
    var filteredMessages: [[String: Any]] = []

    
    //var receiverId = ""
    
    //audio call
    //EDIT
    //    var counter:TimeInterval = 0
    //    var timer = Timer()
    //    let dateFormatter : DateComponentsFormatter = {
    //        let formatter = DateComponentsFormatter()
    //        formatter.allowedUnits = [.hour, .minute, .second]
    //        formatter.zeroFormattingBehavior = .pad
    //        return formatter
    //    }()
    //    let audioSession = QBRTCAudioSession.instance()
    
    var isBlockTapped = false
    var isUnmatchTapped = false
    
    let arrReportType = ["Report".localizableString(lang: Helper.shared.strLanguage),
                         "Report account".localizableString(lang: Helper.shared.strLanguage)]
    let arrReportReasons1 = ["Hate speech".localizableString(lang: Helper.shared.strLanguage),
                             "Scam".localizableString(lang: Helper.shared.strLanguage),
                             "Violence".localizableString(lang: Helper.shared.strLanguage),
                             "Spam".localizableString(lang: Helper.shared.strLanguage),
                             "I just don't like it".localizableString(lang: Helper.shared.strLanguage),
                             "It's posting content that shouldn't be on Coptic Match",
                             "It's pretending to be someone else".localizableString(lang: Helper.shared.strLanguage)]
    
    let arrReportReasons2 = ["It's posting content that shouldn't be on Coptic Match",
                             "It's pretending to be someone else".localizableString(lang: Helper.shared.strLanguage),
                             "The may be under the age of 13".localizableString(lang: Helper.shared.strLanguage)]
    
    //var strOpponentUserId = ""
    var strDeviceType = ""
    var strUsername = ""
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        
        // --- Standardize strRoomId flow ---
        let myId = Login_LocalDB.getLoginUserModel().data?.id ?? 0
        let receiverId = Int(strReceiverId) ?? 0
        
        // If the room ID is missing or invalid, generate it deterministically
        if strRoomId.isEmpty || strRoomId == "no" {
            strRoomId = AppHelper.getRoomId(id1: myId, id2: receiverId)
        }
        print("Using Firestore Room ID: \(strRoomId)")
        // ---------------------------------

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //EDIT
        //QBChat.instance.addDelegate(self)
        
        //EDIT
        //audio call
        //QBRTCClient.instance().add(self)
        
        setupUI()
        // self.getMessagesAPI() // Removed to prevent UI inconsistency with Firestore listener
        getUserDetailsAPI()
        
        if fromSayHiBtn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.txtMessage.text = "Hi"
                self.btnSendMessage(self.btnSendMessage)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setLanguageUI()
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
//        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
//            self.getMessagesAPI()
//        })
        self.listenForMessages()
        self.markConversationAsRead()
        //EDIT
        //groupDialog = QBChatDialog(dialogID: dictReceiver?.id, type: .group)
        
        //EDIT
        //makeConnection()
        //getChatHistory()
        
        // Handle App Background/Foreground
        NotificationCenter.default.addObserver(self, selector: #selector(markuserOffline), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(markConversationAsRead), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //EDIT
        //        groupDialog.leave { (error) in
        //
        //        }
        //
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //
        
        //
        timer.invalidate()
        
        //
        markuserOffline()
        messageListener?.remove()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            viewHeader.semanticContentAttribute = .forceRightToLeft
            txtMessage.textAlignment = .right
            viewBottom.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
            viewHeader_BlockPopup.semanticContentAttribute = .forceRightToLeft
            viewHeader_ReportPopup.semanticContentAttribute = .forceRightToLeft
            viewHeader_reportPopup2.semanticContentAttribute = .forceRightToLeft
            lblTitle_BlockPopup.semanticContentAttribute = .forceRightToLeft
            lblTitle_reportPopup.semanticContentAttribute = .forceRightToLeft
            lblTitle1_reportPopup.semanticContentAttribute = .forceRightToLeft
            lblTitle_reportPopup2.semanticContentAttribute = .forceRightToLeft
            lblTitle1_reportPopup2.semanticContentAttribute = .forceRightToLeft
        }
        txtMessage.placeholder = "Type a message...".localizableString(lang: Helper.shared.strLanguage)
        btnBlock_menu.setTitle("Block".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnReport_Menu.setTitle("Report".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnUnmatch_menu.setTitle("Unmatch".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTitle_reportPopup.text = "Report".localizableString(lang: Helper.shared.strLanguage)
        lblTitle1_reportPopup.text = "What would you like report?".localizableString(lang: Helper.shared.strLanguage)
        lblTitle_reportPopup2.text = "Report".localizableString(lang: Helper.shared.strLanguage)
        lblTitle1_reportPopup2.text = "Please select a problem to report".localizableString(lang: Helper.shared.strLanguage)
        lblMessage_BlockPopup.text = "Are you sure?".localizableString(lang: Helper.shared.strLanguage)
        btnBlock_popup.setTitle("Block".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            //viewMsg_Bottom.constant = keyboardSize.height
            
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight: CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            viewBgMsg_Bottom.constant = keyboardHeight
            self.scrollToBottom()
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            viewBgMsg_Bottom.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    func registerCell(){
        tblList_reportPopup.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        tblList_reportPopup2.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
        tblList.register(UINib(nibName: "SendMsgTblCell", bundle: nil), forCellReuseIdentifier: "SendMsgTblCell")
        tblList.register(UINib(nibName: "ReplayMsgTblCell", bundle: nil), forCellReuseIdentifier: "ReplayMsgTblCell")
    }
    // MARK: - Function
    func setupUI() {
        
        //self.hideKeyboardWhenTappedAround()
        
        //EDIT
        //gets receiver user id
        //        if let index = self.dictReceiver?.occupantIDs?.firstIndex(of: NSNumber(value: QBSession.current.currentUser!.id)) {
        //
        //            if index == 0 {
        //                receiverId = "\(self.dictReceiver?.occupantIDs![1] ?? 0)"
        //            } else {
        //                receiverId = "\(self.dictReceiver?.occupantIDs![0] ?? 0)"
        //            }
        //        }
        //        getOpponentUsername()
        
        //
        
        
        txtMessage.delegate = self
        
        let nib = UINib(nibName: "ChatHeaderView", bundle: nil)
        tblList.register(nib, forHeaderFooterViewReuseIdentifier: "ChatHeaderView")
        
        //EDIT
        //self.getUserDetailsAPI1(qbId: "\(self.receiverId)")
    }
    
    func scrollToBottom(){
//        if (arrMessages?.count ?? 0) > 0 {
//            DispatchQueue.main.async {
//                let indexPath = IndexPath(row: self.arrMessages!.count-1, section: 0)
//                self.tblList.scrollToRow(at: indexPath, at: .bottom, animated: false)
//            }
//        }
        
        if (filteredMessages.count) > 0 {
            DispatchQueue.main.async {
                let section = self.filteredMessages.count - 1
                let index = (self.filteredMessages[section]["messages"] as? [[String: Any]] ?? []).count - 1
                let indexPath = IndexPath(row: index, section: section)
                self.tblList.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func setDate(strDate:String) -> String {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var parsedDate: Date?
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: strDate) {
                parsedDate = date
                break
            }
        }
        
        guard let myDate = parsedDate else { return "" }
        
        let displayTimeFormatter = DateFormatter()
        displayTimeFormatter.dateFormat = "h:mm a"
        let getTime = displayTimeFormatter.string(from: myDate)
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MM-dd-yyyy"
        let getDate = displayDateFormatter.string(from: myDate)
        
        if Calendar.current.isDateInToday(myDate) {
            return "\(getTime)"
        } else if Calendar.current.isDateInYesterday(myDate) {
            return "Yesterday \(getTime)"
        } else {
            return "\(getDate) \(getTime)"
        }
    }
    
    //EDIT
    //    @objc func methodOfReceivedNotification(notification: Notification) {
    //
    //        groupDialog.join { (error) in
    //
    //            print(error)
    //            print(error)
    //            if error == nil {
    //                self.checkTypingStatus()
    //            }
    //        }
    //    }
    //
    //
    //    func checkTypingStatus() {
    //
    //        //
    //        self.groupDialog.onUserIsTyping = {(userID: UInt) in
    //            if self.groupDialog.type == .group {
    //                // fetch username or login name from userID
    //
    //                QBRequest.user(withID: userID) { res, user in
    //
    //                    if QBSession.current.currentUser?.id != userID {
    //                        if let name = user.fullName {
    //                            print("\(name) is typing...".localizableString(lang: Helper.shared.strLanguage))
    //                            self.lblTyping.text = "typing...".localizableString(lang: Helper.shared.strLanguage)//"\(name) is typing..."
    //                        } else if let login = user.login {
    //                            print("\(login) is typing...".localizableString(lang: Helper.shared.strLanguage))
    //                            self.lblTyping.text = "typing...".localizableString(lang: Helper.shared.strLanguage)//"\(login) is typing..."
    //                        }
    //                    }
    //                }
    //            } else if self.groupDialog.type == .private {
    //                print("Typing Starts...")
    //            }
    //        }
    //
    //        //
    //        self.groupDialog.onUserStoppedTyping = {(userID: UInt) in
    //            if self.groupDialog.type == .group {
    //                //No one is typing
    //                self.lblTyping.text = ""
    //            } else if self.groupDialog.type == .private {
    //                print("Typing Stopped")
    //            }
    //        }
    //    }
    //    func makeConnection() {
    //
    //        let currentUser = QBSession.current.currentUser//QBUUser()
    //        QBChat.instance.connect(withUserID: currentUser!.id, password: "quickblox", completion: { (error) in
    //            print(error)
    //
    //            self.joinGroup()
    //
    //        })
    //    }
    //    //remove it if private chat
    //    func joinGroup() {
    //
    //        groupDialog.join { (error) in
    //
    //            print(error)
    //            print(error)
    //            if error == nil {
    //                self.checkTypingStatus()
    //            }
    //        }
    //    }
    
    //    func getChatHistory() {
    //
    //        let page = QBResponsePage(limit: 100, skip: 0)
    //        let extendedRequest = ["sort_desc": "date_sent", "mark_as_read": "1"]
    //        QBRequest.messages(withDialogID: (dictReceiver?.id)!, extendedRequest: extendedRequest, for: page, successBlock: { (response, messages, page) in
    //
    //            print(messages)
    //            self.arrMsgs = messages.reversed()
    //
    //            //
    //            let grouped = self.arrMsgs?.sliced(by: [.year, .month, .day], for: \.dateSent!)
    //
    //            var arr:[[String:Any]] = []
    //            for (key, value) in grouped ?? [:] {
    //
    //                arr.append(["date":key,"messages":value])
    //            }
    //            self.arrMessages = arr.sorted{ $1["date"] as! Date > $0["date"] as! Date  }
    //            //
    //
    //            DispatchQueue.main.async {
    //                self.tblList.reloadData()
    //                self.tblList.scrollToBottom(isAnimated: false)
    //            }
    //
    //        }, errorBlock: { (response) in
    //
    //        })
    //    }
    
    
    //    func scrollToBottom(){
    //        DispatchQueue.main.async {
    //            if self.arrMessages?.count ?? 0 > 0 {
    //                let indexPath = IndexPath(row: (self.arrMessages?.count ?? 0)-1, section: 0)
    //                self.tblList.scrollToRow(at: indexPath, at: .bottom, animated: false)
    //            }
    //
    //        }
    //    }
    
    //    func sendPushNotification(message:String,receiverID:String,isCategory:Bool) {
    //
    //        let event = QBMEvent()
    //
    //        var pushParameters:[String : Any] = [:]
    //
    //        if strDeviceType == "iOS" {
    //
    //            event.notificationType = .push
    //            event.usersIDs = receiverID//"20,21"
    //            event.type = .oneShot
    //
    //            pushParameters["message"] = "\(strUsername):\(message)"
    //            pushParameters["ios_badge"] = "1"
    //            pushParameters["ios_sound"] = "default"//"app_sound.wav"
    //            pushParameters["type"] = "qb_chat"
    //
    //
    //            if isCategory == true {
    //                pushParameters["ios_category"] = "CallCategory"
    //            }
    //        } else {
    //
    //            event.notificationType = .push
    //            event.usersIDs = receiverID//"20,21"
    //            event.pushType = .GCM
    //
    //            pushParameters["data"] = ["title":strUsername,
    //                                      "body":message,
    //                                      "message":message,
    //                                      "op_id":"\(receiverID)",
    //                                      "vibrate":"1",
    //                                      "sound":"1",
    //                                      "type":"qb_chat"]
    //
    //        }
    //
    //
    //        // custom params
    //        //pushParameters["thread_likes"] = "24"
    //        //pushParameters["thread_id"] = "678923"
    //
    //        if let jsonData = try? JSONSerialization.data(withJSONObject: pushParameters, options: .prettyPrinted) {
    //            let jsonString = String(bytes: jsonData, encoding: String.Encoding.utf8)
    //            event.message = jsonString
    //        }
    //
    //        QBRequest.createEvent(event, successBlock: {(response, events) in
    //            print(response)
    //            print(events)
    //        }, errorBlock: {(response) in
    //            print(response)
    //            //print((response.error?.reasons?["errors"] as? [String])?[0])
    //
    //            if let msg = (response.error?.reasons?["errors"] as? [String])?[0] {
    //                //showAlert(message: msg, vc: self)
    //                print(msg)
    //            }
    //
    //        })
    //    }
    
    
    //audio call
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
    //    }
    //
    //    @objc func btnRejectCall() {
    //
    //        HelperAudioCall.shared.stopSound()
    //
    //        // userInfo - the custom user information dictionary for the reject call. May be nil.
    //        let userInfo = ["key":"value"] // optional
    //        HelperAudioCall.shared.session?.rejectCall(userInfo)
    //
    //        // and release session instance
    //        HelperAudioCall.shared.session = nil
    //        view.viewWithTag(5001)?.removeFromSuperview()
    //        cancelTimer()
    //    }
    //    @objc func btnAcceptCall() {
    //        (view.viewWithTag(5001) as? AudioCallView)?.lblTimer.isHidden = false
    //        HelperAudioCall.shared.stopSound()
    //        (view.viewWithTag(5001) as? AudioCallView)?.btnAcceptCall.isHidden = true
    //        (view.viewWithTag(5001) as? AudioCallView)?.btnRejectCall.isHidden = true
    //        (view.viewWithTag(5001) as? AudioCallView)?.btnHungUp.isHidden = false
    //        (view.viewWithTag(5001) as? AudioCallView)?.btnMute.isHidden = false
    //        (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.isHidden = false
    //
    //        // userInfo - the custom user information dictionary for the accept call. May be nil.
    //        let userInfo = ["key":"value"] // optional
    //        HelperAudioCall.shared.session?.acceptCall(userInfo)
    //        startTimer()
    //    }
    //    @objc func btnHungUpCall() {
    //
    //        // userInfo - the custom user information dictionary for the reject call. May be nil.
    //        let userInfo = ["key":"value"] // optional
    //        HelperAudioCall.shared.session?.hangUp(userInfo)
    //
    //        // and release session instance
    //        HelperAudioCall.shared.session = nil
    //        view.viewWithTag(5001)?.removeFromSuperview()
    //        cancelTimer()
    //    }
    //    @objc func btnMuteCall() {
    //
    //
    //        if HelperAudioCall.shared.session?.localMediaStream.audioTrack.isEnabled == true {
    //            (view.viewWithTag(5001) as? AudioCallView)?.btnMute.setImage(#imageLiteral(resourceName: "mic-off"), for: .normal)
    //        } else {
    //            (view.viewWithTag(5001) as? AudioCallView)?.btnMute.setImage(#imageLiteral(resourceName: "mic-on"), for: .normal)
    //        }
    //
    //        HelperAudioCall.shared.session?.localMediaStream.audioTrack.isEnabled = !(HelperAudioCall.shared.session?.localMediaStream.audioTrack.isEnabled)!
    //    }
    //    @objc func btnSpeakerCall() {
    //
    //        if (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.tag == 0 {
    //            (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.tag = 1
    //            (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.setImage(#imageLiteral(resourceName: "speaker-on"), for: .normal)
    //
    ////            let isActive = true
    ////            audioSession.setActive(isActive)
    //
    //            let speaker: AVAudioSession.PortOverride = .speaker
    //            audioSession.overrideOutputAudioPort(speaker)
    //
    //        } else {
    //            (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.tag = 0
    //            (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.setImage(#imageLiteral(resourceName: "speaker-off"), for: .normal)
    //
    ////            let isActive = false
    ////            audioSession.setActive(isActive)
    //            let receiver: AVAudioSession.PortOverride = .none
    //            audioSession.overrideOutputAudioPort(receiver)
    //        }
    //
    //    }
    //
    //
    //    func startTimer() {
    //        counter = 0
    //        timer.invalidate() // just in case this button is tapped multiple times
    //
    //        // start the timer
    //        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    //    }
    //
    //    // stop timer
    //    func cancelTimer() {
    //        timer.invalidate()
    //    }
    //
    //    @objc func timerAction() {
    //        counter += 1
    //
    //        if view.viewWithTag(5001) != nil {
    //            (view.viewWithTag(5001) as! AudioCallView).lblTimer.text = dateFormatter.string(from: counter)!
    //        }
    //
    //    }
    
    //    func getOpponentUsername() {
    //
    //        QBRequest.users(withIDs: [receiverId], page: nil, successBlock: { (response, page, users) in
    //
    //            let receiverUser = users[0]
    //
    //            if receiverUser != nil {
    //
    //                DispatchQueue.main.async {
    //                    // update ui here
    //                    self.lblHeaderTitle.text = receiverUser.fullName
    //                    self.imgHeader.sd_setImage(with: URL(string: "\(kImageBaseURL)\(receiverUser.customData ?? "")"), placeholderImage: UIImage(named: "man"))
    //                }
    //            }
    //        }, errorBlock:{ (response) in
    //        })
    //    }
    //
    //    func deleteQBDialog(msg:String) {
    //
    //        var isForAllUsers = false
    //        if QBSession.current.currentUser?.id == dictReceiver?.userID {
    //            isForAllUsers = true
    //        } else {
    //            isForAllUsers = false
    //        }
    //
    //        QBRequest.deleteDialogs(withIDs: Set<String>([dictReceiver?.id ?? ""]), forAllUsers: isForAllUsers, successBlock: { (deletedObjectsIDs, notFoundObjectsIDs, wrongPermissionsObjectsIDs,arr)  in
    //
    //            self.popover.dismiss()
    //            AppHelper.returnTopNavigationController().view.makeToast(msg)
    //            self.navigationController?.popViewController(animated: true)
    //        }, errorBlock: { (response) in
    //
    //            if let _ = (response.error?.reasons?["errors"] as? [String]) {
    //                if (response.error?.reasons?["errors"] as? [String])?.count != 0 {
    //
    //                    AppHelper.returnTopNavigationController().view.makeToast((response.error?.reasons?["errors"] as? [String])?[0])
    //                }
    //            }
    //        })
    //    }
    
    //MARK: - Webservice
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
    //    func getUserDetailsAPI1(qbId:String) {
    //
    //        if NetworkReachabilityManager()!.isReachable == false
    //        {
    //            return
    //        }
    //
    //        let dicParams:[String:String] = ["quickbox_id":qbId]
    //        //AppHelper.showLinearProgress()
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
    //                    self.strOpponentUserId = "\(dict?["id"] as? Int ?? 0)"
    //                    self.strDeviceType = dict?["device_type"] as? String ?? "iOS"
    //                    self.strUsername = userModel.data?.name ?? ""
    //                }
    //            }
    //
    //            //AppHelper.hideLinearProgress()
    //        }
    //    }
    func reportAPI(type:String, reason:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:Any] = ["type":type,
                                      "reason":reason,
                                      "reported_user_id":strReceiverId]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_report, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    self.popover.dismiss()
                    AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    func blockAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = ["status":"1",
                                         "op_user_id":strReceiverId]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_block, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    self.popover.dismiss()
                    AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    func unmatchAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = ["op_user_id":strReceiverId]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_unMatches, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    self.popover.dismiss()
                    AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String ?? "")
                    self.navigationController?.popViewController(animated: true)
                    
                    //EDIT
                    //self.deleteQBDialog(msg: json["message"] as? String ?? "")
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    func sendMessageAPI(text:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        let db = Firestore.firestore()
        let userModel = Login_LocalDB.getLoginUserModel()
        fetchOtherUserStatus { [weak self] isOnline in
            guard let self = self else { return }
            self.isOnline = isOnline
            
            var dicParams:[String:Any] = ["message":text,
                                          "reciver_id":self.strReceiverId,
                                          "sender_name":userModel.data?.name ?? "",
                                          "is_online" : self.isOnline,
                                          "is_buy_valid_subscription":self.dictOpponentUserData?.is_buy_valid_subscription_new ?? ""]
            print(
                dicParams,"sxnkjnxclac")
            
            var dictRoomInfo:[String:Any]?
            if self.dictOpponentUserData?.room_info.count != 0 {
                dictRoomInfo = self.dictOpponentUserData?.room_info[0]
            }
            
            if let value = dictRoomInfo?["is_both_like_count"] as? Int {
                dicParams["is_both_like_count"] = value
            } else {
                dicParams["is_both_like_count"] = 0 // if there is no room created then pass 0
            }
            
            let headers:HTTPHeaders = ["Accept":"application/json",
                                       "Authorization":userModel.data?.api_token ?? ""]
            
            AF.request(send_chat_msg, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                
                print(response)
                
                if let json = response.value as? [String:Any] {
                    
                    if json["status"] as? String == "Success" {
                        self.txtMessage.text = ""
                        
                        // -- Start Firestore Sync --
                        let timestamp = ISO8601DateFormatter().string(from: Date())
                        let serverTimestamp = FieldValue.serverTimestamp()
                        
                        let messageData: [String: Any] = [
                            "sender_id": userModel.data?.id ?? 0,
                            "reciver_id": Int(self.strReceiverId) ?? 0,
                            "message": text,
                            "created_at": timestamp
                        ]
                        
                        // Write to Room Messages
                        db.collection("rooms").document(self.strRoomId).collection("messages").addDocument(data: messageData)
                        
                        // Update Conversation Metadata for Both Users
                        self.updateFirestoreConversation(text: text, timestamp: timestamp, serverTimestamp: serverTimestamp,isOnline: isOnline)
                        // -- End Firestore Sync --
                    }
                }
            }
        }
    }
    
    func convertDateString(_ dateString: String) -> String? {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var parsedDate: Date?
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                parsedDate = date
                break
            }
        }
        
        guard let date = parsedDate else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        return outputFormatter.string(from: date)
    }
    func processMessages() {
        self.filteredMessages.removeAll()
        
        if let messages = self.arrMessages {
            for message in messages {
                // Grouping messages by date for the section headers
                if let index = self.filteredMessages.firstIndex(where: {
                    self.convertDateString($0["created_at"] as? String ?? "") ==
                    self.convertDateString(message["created_at"] as? String ?? "")
                }) {
                    if var existingMessages = self.filteredMessages[index]["messages"] as? [[String: Any]] {
                        existingMessages.append(message)
                        self.filteredMessages[index]["messages"] = existingMessages
                    }
                } else {
                    self.filteredMessages.append([
                        "created_at": message["created_at"] as? String ?? "",
                        "messages": [message]
                    ])
                }
            }
        }
        
        self.tblList.reloadData()
        
        // Auto-scroll logic and handling message limit bubble
        if self.isCallFirstTime {
            self.scrollToBottom()
            
            let userModel = Login_LocalDB.getLoginUserModel()
            let receivedMessages = self.arrMessages?.filter( { $0["sender_id"] as? Int == Int(self.strReceiverId) } )
            let senderMessages = self.arrMessages?.filter( { $0["sender_id"] as? Int == userModel.data?.id ?? 0 } )
            
            if receivedMessages?.count ?? 0 < 1 && senderMessages?.count ?? 0 >= 2 {
                self.txtMessage.resignFirstResponder()
                self.bottomSheetBottomConstraint.constant = -182.5
                UIView.animate(withDuration: 0.3) {
                    self.bottomSheetBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            if self.intMsgCount != self.arrMessages?.count {
                self.scrollToBottom()
            }
        }
        
        self.intMsgCount = self.arrMessages?.count ?? 0
        self.isCallFirstTime = false
    }
    func listenForMessages() {
        let db = Firestore.firestore()
      
        messageListener = db.collection("rooms").document(strRoomId).collection("messages")
            .order(by: "created_at", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error listening for messages: \(error)")
                    return
                }
                guard let snapshot = querySnapshot else { return }
                
                if snapshot.isEmpty && !UserDefaults.standard.bool(forKey: "migrated_room_\(self.strRoomId)") {
                    self.migrateExistingMessagesToFirestore()
                }

                var newMessages: [[String: Any]] = []
                for document in snapshot.documents {
                    newMessages.append(document.data())
                }
                self.arrMessages = newMessages
                self.processMessages()
            }
    }
    func fetchOtherUserStatus(completion: @escaping (Bool) -> Void){
        let db = Firestore.firestore()
        db.collection("users").document(self.strReceiverId).collection("conversations").document(strRoomId)
            .getDocument { [weak self] document, error in
                guard let self = self else { return }
                if let document = document, document.exists,
                   let data = document.data(),
                   let activeUsers = data["active_users"] as? [String: Any] {

                    let isRecipientActive = activeUsers[self.strReceiverId] as? Bool ?? false
                    completion(isRecipientActive)
                               }
                else{
                    completion(false)
                }
            }
    }
    @objc func markConversationAsRead() {
        let userModel = Login_LocalDB.getLoginUserModel()
        let myId = "\(userModel.data?.id ?? 0)"
        let db = Firestore.firestore()
       let database=db.collection("users").document(myId).collection("conversations").document(strRoomId)
    
        
            database.updateData([
            "count_unred_count": 0,
            "active_users.\(myId)": true
            
        ]) { error in
            if let error = error {
                print("Error marking conversation as read: \(error)")
            }
        }
    }
    @objc func markuserOffline(){
        let userModel = Login_LocalDB.getLoginUserModel()
        let myId = "\(userModel.data?.id ?? 0)"
        let db = Firestore.firestore()
        db.collection("users").document(myId).collection("conversations").document(strRoomId).updateData([
            "active_users.\(myId)": false
        ]){
            error in if let error = error {
                print("Error marking user offline: \(error)")
            }
        }
    }

    func updateFirestoreConversation(text: String, timestamp: String, serverTimestamp: Any,isOnline:Bool) {
        let db = Firestore.firestore()
        let myUserModel = Login_LocalDB.getLoginUserModel()
        let myId = "\(myUserModel.data?.id ?? 0)"
        let opponentId = self.strReceiverId

        // 1. Update My Conversation (Always set unread to 0 for myself)
        let myUpdate: [String: Any] = [
            "last_msg_info": ["message": text, "created_at": timestamp],
            "timestamp": serverTimestamp,
            "count_unred_count": 0
        ]
        db.collection("users").document(myId).collection("conversations").document(strRoomId).updateData(myUpdate)
    
        // 2. Update Their Conversation
        let theirConvRef = db.collection("users").document(opponentId).collection("conversations").document(strRoomId)
        

        var unreadUpdate: Any = isOnline ? 0 : FieldValue.increment(Int64(1))

            let theirUpdate: [String: Any] = [
                "last_msg_info": ["message": text, "created_at": timestamp],
                "timestamp": serverTimestamp,
                "count_unred_count": unreadUpdate
            ]
            
            theirConvRef.updateData(theirUpdate) { error in
                if let error = error {
                    print("Error updating opponent's conversation: \(error)")
                }
            }
        
    }

    func getMessagesAPI() {
        if NetworkReachabilityManager()!.isReachable == false { return }
        
        // If we don't have a legacy ID, we can't call the fallback API
        if strLegacyRoomId.isEmpty || strLegacyRoomId == "no" { return }
        
        if isCallFirstTime { AppHelper.showLinearProgress() }
        let userModel = Login_LocalDB.getLoginUserModel()
        let headers:HTTPHeaders = ["Accept":"application/json", "Authorization":userModel.data?.api_token ?? ""]
        AF.request("\(get_chat_msg)?room%20id=\(strLegacyRoomId)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let json = response.value as? [String:Any], json["status"] as? String == "Success" {
                self.arrMessages = (json["data"] as? [String:Any])?["messages"] as? [[String:Any]]
                self.processMessages()
            }
            AppHelper.hideLinearProgress()
        }
    }

    func migrateExistingMessagesToFirestore() {
        if NetworkReachabilityManager()!.isReachable == false { return }
        
        // If we don't have a legacy ID, we can't migrate from backend
        if strLegacyRoomId.isEmpty || strLegacyRoomId == "no" { return }

        // Flag as migrated immediately to prevent multiple sync attempts
        UserDefaults.standard.set(true, forKey: "migrated_room_\(self.strRoomId)")

        let userModel = Login_LocalDB.getLoginUserModel()
        let headers:HTTPHeaders = ["Accept":"application/json", "Authorization":userModel.data?.api_token ?? ""]
        let db = Firestore.firestore()

        AF.request("\(get_chat_msg)?room%20id=\(strLegacyRoomId)", method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let json = response.value as? [String:Any], json["status"] as? String == "Success" {
                let messages = (json["data"] as? [String:Any])?["messages"] as? [[String:Any]] ?? []
                
                let batch = db.batch()
                let messagesRef = db.collection("rooms").document(self.strRoomId).collection("messages")
                
                for msg in messages {
                    // Create a deterministic ID based on created_at or use addDocument (batch set is better if we have IDs)
                    // Since API doesn't give document IDs, we'll just use the messages collection add logic
                    // But batch requires DocRefs. We can generate them.
                    let docRef = messagesRef.document()
                    batch.setData(msg, forDocument: docRef)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("Error migrating messages: \(error)")
                        UserDefaults.standard.set(false, forKey: "migrated_room_\(self.strRoomId)") // Reset on failure
                    }
                }
            } else {
                UserDefaults.standard.set(false, forKey: "migrated_room_\(self.strRoomId)")
            }
        }
    }
    func getUserDetailsAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let dicParams:[String:AnyObject] = ["user_id":strReceiverId as AnyObject]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        HttpWrapper.requestMultipartFormDataWithImageAndFile(detail_by_user_id, dicsParams: dicParams, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
            self.view.isUserInteractionEnabled = true
            AppHelper.hideLinearProgress()
            let dicsResponseFinal = response.replaceNulls(with: "")
            print(dicsResponseFinal as Any)
            
            let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
            self.dictOpponentUserData = userListModel_.data
            
            // Backup: If strLegacyRoomId is missing, try to get it from the user details
            if (self.strLegacyRoomId.isEmpty || self.strLegacyRoomId == "no"), 
               let roomInfo = userListModel_.data?.room_info.first {
                if let legacyId = roomInfo["id"] as? Int {
                    self.strLegacyRoomId = "\(legacyId)"
                } else if let legacyId = roomInfo["id"] as? String {
                    self.strLegacyRoomId = legacyId
                }
            }

            if userListModel_.code == 200{
                
                //--
                let dob_str = userListModel_.data?.dob
                let dob_year = AppHelper.stringToDate(strDate: dob_str ?? "", strFormate: "yyyy-MM-dd")
                self.lblHeaderTitle.text = "\(userListModel_.data?.name ?? ""), \(Date().years(from: dob_year))"
                self.lblHeaderLocation.text = "\(userListModel_.data?.city ?? ""), \(userListModel_.data?.country ?? "")"
                self.imgHeader.sd_setImage(with: URL(string: "\(kImageBaseURL)\(userListModel_.data?.user_image[0].image ?? "")"), placeholderImage: UIImage(named: ""))
//                self.imgHeader.sd_setImage(with: URL(string: "\(kImageBaseURL)\(userListModel_.data?.selfie ?? "")"), placeholderImage: UIImage(named: ""))
                self.lblMessageLimitWarning.text = "Please wait for \(userListModel_.data?.name ?? "") to respond before sending another message."
                
            }else if userListModel_.code == 401{
                AppHelper.Logout(navigationController: self.navigationController!)
            }else{
                self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
            }
        }) { (error) in
            print(error)
            self.view.isUserInteractionEnabled = true
            AppHelper.hideLinearProgress()
        }
    }
    
    //MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        delegate?.backButtonClicked(flag: true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSendMessage(_ sender: Any) {
        
        if txtMessage.text == "" {
            return
        }
        var text = txtMessage.text
        txtMessage.text = ""
        
        
        ///to show message limit view
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let receivedMessages = self.arrMessages?.filter( { $0["sender_id"] as? Int == Int(self.strReceiverId) } )
        let senderMessages = self.arrMessages?.filter( { $0["sender_id"] as? Int == userModel.data?.id ?? 0 } )
        
        if receivedMessages?.count ?? 0 < 1 && senderMessages?.count ?? 0 >= 2 {
            
            txtMessage.resignFirstResponder()
            self.bottomSheetBottomConstraint.constant = -182.5
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        } else {
            sendMessageAPI(text: text!)
        }

        
        //EDIT
        //        //print(dictReceiver?.id)
        //        let message = QBChatMessage()
        //        message.text = txtMessage.text
        //        //message.readIDs = [(NSNumber(value: QBSession.current.currentUser!.id))]
        //        message.customParameters["save_to_history"] = true
        //        let privateDialog = QBChatDialog(dialogID: dictReceiver?.id, type: .group)
        //        privateDialog.occupantIDs = dictReceiver?.occupantIDs
        //
        //        privateDialog.send(message) { (error) in
        //            print(error)
        //            //self.getChatHistory()
        //            if error == nil {
        //
        //                //
        //                let arr = self.dictReceiver?.name?.components(separatedBy: " ")
        //
        //                var msg = ""
        //                if arr?[0] != "match" {
        //                    msg = "You got a new message".localizableString(lang: Helper.shared.strLanguage)
        //                } else {
        //                    msg = self.txtMessage.text ?? ""
        //                }
        //
        //                //
        //                self.sendPushNotification(message: msg, receiverID: self.receiverId, isCategory: false)
        //                self.txtMessage.text = ""
        //                self.groupDialog.sendUserStoppedTyping()
        //                self.tblList.scrollToBottom(isAnimated: false)
        //            } else {
        //                AppHelper.returnTopNavigationController().view.makeToast(error.debugDescription)
        //            }
        //
        //        }
        //
        //        //change dialog name to match
        //
        //        if dictReceiver?.name?.contains("direct_chat") ?? false {
        //
        //            let arr = dictReceiver?.name?.components(separatedBy: " ")
        //
        //            if arr?[1] != "\(QBSession.current.currentUser?.id ?? 0)" {
        //
        //                let privateDialog1 = QBChatDialog(dialogID: dictReceiver?.id, type: .group)
        //
        //                privateDialog1.name = "match \(QBSession.current.currentUser?.id ?? 0)"
        //
        //                QBRequest.update(privateDialog1, successBlock: { (response, updatedDialog) in
        //
        //                }, errorBlock: { (response) in
        //
        //                })
        //            }
        //        }
        
        //
    }
    //EDIT
    //    @IBAction func btnAudioCall(_ sender: Any) {
    //
    //        HelperAudioCall.shared.playSound()
    //
    //        // 2123, 2123, 3122 - opponent's
    //        let opponentsIDs = [NSNumber(value: Int(receiverId)!)]
    //        HelperAudioCall.shared.session = QBRTCClient.instance().createNewSession(withOpponents: opponentsIDs as [NSNumber], with: .audio)
    //        // userInfo - the custom user information dictionary for the call. May be nil.
    //        let userInfo = ["key":"value"] // optional
    //        HelperAudioCall.shared.session?.startCall(userInfo)
    //
    //
    //        HelperAudioCall.shared.isCallReceived = false
    //
    //
    //        getUserDetailsAPI(qbId:"\(receiverId)")
    //
    //        //send call notification
    //        self.sendPushNotification(message: "\(strUsername) \("is calling you".localizableString(lang: Helper.shared.strLanguage))", receiverID: self.receiverId, isCategory: true)
    //    }
    //    @IBAction func btnVideoCall(_ sender: Any) {
    //    }
    @IBAction func btnMenu(_ sender: Any) {
        self.view.endEditing(true)
        
        //--
        /*let options = [
            .type(.down),
            .cornerRadius(5),
            .animationIn(0.3),
            .arrowSize(CGSize(width: 0.0, height: 0.0))
        ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.dismissOnBlackOverlayTap = true
        popover.show(viewbg_menu, fromView: sender as! UIView)*/
        
        let alert = UIAlertController(title: kAlertTitle, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Block \(self.dictOpponentUserData?.name ?? "")", style: .default, handler: { _ in
            self.block()
        }))
        alert.addAction(UIAlertAction(title: "Report \(self.dictOpponentUserData?.name ?? "")", style: .default, handler: { _ in
            self.report()
        }))
        
        
        if dictOpponentUserData?.room_info.count != 0 {
            
            if self.dictOpponentUserData?.room_info[0]["is_both_like_count"] as? Int != 0 {
                alert.addAction(UIAlertAction(title: "Unmatch \(self.dictOpponentUserData?.name ?? "")", style: .default, handler: { _ in
                    self.unmatch()
                }))
            }
        }
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnOKAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.bottomSheetBottomConstraint.constant = -182.5
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func block() {
        isBlockTapped = true
        isUnmatchTapped = false
        
        btnBlock_popup.setTitle("Block".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTitle_BlockPopup.text = "\("Block".localizableString(lang: Helper.shared.strLanguage)) \(self.lblHeaderTitle.text ?? "")"
        popover.dismiss()
        //--
        let options = [
            .type(.down),
            .cornerRadius(15),
            .animationIn(0.3),
            .arrowSize(CGSize(width: 16.0, height: 10.0))
        ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.dismissOnBlackOverlayTap = true
        popover.show(viewbg_BlockConfirmation, fromView: btnMenu)
    }
    func report() {
        
        //popover.dismiss()
        viewbg_reportPopup.frame.size = CGSize(width: self.view.frame.width-20, height: viewbg_reportPopup.frame.height + 40)
        let aView = UIView()
        aView.frame = viewbg_reportPopup.frame
        aView.addSubview(viewbg_reportPopup)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)
    }
    func unmatch() {
        
        isBlockTapped = false
        isUnmatchTapped = true
        
        btnBlock_popup.setTitle("Unmatch".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTitle_BlockPopup.text = "\("Unmatch".localizableString(lang: Helper.shared.strLanguage)) \(self.lblHeaderTitle.text ?? "")"
        popover.dismiss()
        //--
        let options = [
            .type(.down),
            .cornerRadius(15),
            .animationIn(0.3),
            .arrowSize(CGSize(width: 16.0, height: 10.0))
        ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.dismissOnBlackOverlayTap = true
        popover.show(viewbg_BlockConfirmation, fromView: btnMenu)
    }
    


    
    @IBAction func btnBlock(_ sender: Any) {
        
        isBlockTapped = true
        isUnmatchTapped = false
        
        btnBlock_popup.setTitle("Block".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTitle_BlockPopup.text = "\("Block".localizableString(lang: Helper.shared.strLanguage)) \(self.lblHeaderTitle.text ?? "")"
        popover.dismiss()
        //--
        let options = [
            .type(.down),
            .cornerRadius(15),
            .animationIn(0.3),
            .arrowSize(CGSize(width: 16.0, height: 10.0))
        ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.dismissOnBlackOverlayTap = true
        popover.show(viewbg_BlockConfirmation, fromView: sender as! UIView)
    }
    @IBAction func btnReport(_ sender: Any) {
        //popover.dismiss()
        viewbg_reportPopup.frame.size = CGSize(width: self.view.frame.width-20, height: viewbg_reportPopup.frame.height)
        let aView = UIView()
        aView.frame = viewbg_reportPopup.frame
        aView.addSubview(viewbg_reportPopup)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)
    }
    
    @IBAction func btnUnmatch(_ sender: Any) {
        
        isBlockTapped = false
        isUnmatchTapped = true
        
        btnBlock_popup.setTitle("Unmatch".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTitle_BlockPopup.text = "\("Unmatch".localizableString(lang: Helper.shared.strLanguage)) \(self.lblHeaderTitle.text ?? "")"
        popover.dismiss()
        //--
        let options = [
            .type(.down),
            .cornerRadius(15),
            .animationIn(0.3),
            .arrowSize(CGSize(width: 16.0, height: 10.0))
        ] as [PopoverOption]
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.dismissOnBlackOverlayTap = true
        popover.show(viewbg_BlockConfirmation, fromView: sender as! UIView)
    }
    @IBAction func btnClose_Block(_ sender: Any) {
        popover.dismiss()
    }
    @IBAction func btnBlockSend(_ sender: Any) {
        
        if isBlockTapped {
            blockAPI()
        } else if isUnmatchTapped {
            unmatchAPI()
        }
        
        
    }
    @IBAction func btnClose_reportPopup(_ sender: Any) {
        popover.dismiss()
    }
    
    @IBAction func btnProfilePreview(_ sender: Any) {
        
        let vc = ProfilePreviewVC(nibName: "ProfilePreviewVC", bundle: nil)
        vc.isFromProfile = false
        vc.strUserId = strReceiverId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OnetoOneChatVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == tblList{
            return filteredMessages.count//arrMessages?.count ?? 0
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblList_reportPopup{
            if indexPath.row == 1 {
                return 0.0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblList{
//            return  arrMessages?.count ?? 0
            return  (filteredMessages[section]["messages"] as? [[String: Any]] ?? []).count
            
        }else if tableView == tblList_reportPopup{
            return arrReportType.count
        } else {
            
            if strReportType == "Report" {
                return arrReportReasons1.count
            } else if strReportType == "Report account" {
                return arrReportReasons2.count
            } else {
                return 0
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblList{
            
            if filteredMessages.count == 0 {
                return UITableViewCell()
            }
            
            let userModel = Login_LocalDB.getLoginUserModel()
            
//            let dict = arrMessages?[indexPath.row]
            let dict = (filteredMessages[indexPath.section]["messages"] as? [[String: Any]])?[indexPath.row]
            
            if dict?["sender_id"] as? Int == userModel.data?.id {
                
                if let msg = dict?["message"] as? String {
                    
                    if msg.containsOnlyEmoji {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SendMsgTblCell") as! SendMsgTblCell
                        //print("Message:\(msg)")
                        cell.selectionStyle = .none
                        
                        cell.imgBubble.image = UIImage(named: "outgoing-message-bubble")?
                            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                        cell.imgBubble.tintColor = UIColor(hex: "#266FA8")
                        cell.lblTitle.text = msg
                        
                        
                        if let createdAt = dict?["created_at"] as? String {
                            cell.lblTime.text = self.setDate(strDate: createdAt)
                            cell.lblTime.isHidden = false
                        } else {
                            cell.lblTime.isHidden = true
                        }
                        
                        
                        cell.setUI()
                        
                        
                        return cell
                    } else {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SendMsgTblCell") as! SendMsgTblCell
                        //print("Message:\(msg)")
                        cell.selectionStyle = .none
                        
                        cell.imgBubble.image = UIImage(named: "outgoing-message-bubble")?
                            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                        cell.imgBubble.tintColor = UIColor(hex: "#266FA8")
                        
                        //print("Message:\(msg)")
                        
                        cell.lblTitle.text = msg
                        
                        if let createdAt = dict?["created_at"] as? String {
                            cell.lblTime.text = self.setDate(strDate: createdAt)
                            cell.lblTime.isHidden = false
                        } else {
                            cell.lblTime.isHidden = true
                        }
                        
                        cell.setUI()
                        
                        return cell
                    }
                    
                    
                }
            } else {
                
                if let msg = dict?["message"] as? String {
                    
                    if msg.containsOnlyEmoji {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplayMsgTblCell", for: indexPath) as! ReplayMsgTblCell
                        cell.selectionStyle = .none
                        
                        cell.imgBubble.image = UIImage(named: "incoming-message-bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
                        
                        cell.lblTitle.text = msg
                        //cell.lblName.text = strHeader
                        
                        if let createdAt = dict?["created_at"] as? String {
                            cell.lblTime.text = self.setDate(strDate: createdAt)
                            cell.lblTime.isHidden = false
                        } else {
                            cell.lblTime.isHidden = true
                        }
                        
                        cell.setUI()
                        
                        return cell
                    } else {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplayMsgTblCell", for: indexPath) as! ReplayMsgTblCell
                        cell.selectionStyle = .none
                        
                        cell.imgBubble.image = UIImage(named: "incoming-message-bubble")?.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
                        
                        cell.lblTitle.text = msg
                        //cell.lblName.text = strHeader
                        
                        
                        if let createdAt = dict?["created_at"] as? String {
                            cell.lblTime.text = self.setDate(strDate: createdAt)
                            cell.lblTime.isHidden = false
                        } else {
                            cell.lblTime.isHidden = true
                        }
                        
                        cell.setUI()
                        
                        return cell
                    }
                    
                    
                }
                
            }
            
            
            
            return UITableViewCell()
        } else if tableView == tblList_reportPopup {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.selectionStyle = .none
            cell.lblTitle.text = arrReportType[indexPath.row]
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.selectionStyle = .none
            
            if strReportType == "Report" {
                cell.lblTitle.text = arrReportReasons1[indexPath.row]
            }
            if strReportType == "Report account" {
                cell.lblTitle.text = arrReportReasons2[indexPath.row]
            }
            
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblList{
            
        } else if tableView == tblList_reportPopup {
            
            strReportType = arrReportType[indexPath.row]
            var height = 0
            if strReportType == "Report" {
                height = 430
            }
            if strReportType == "Report account" {
                height = 300
            }
            viewbg_reportPopup2.frame.size = CGSize(width: Int(self.view.frame.width)-20, height: height)
            let aView = UIView()
            aView.frame = viewbg_reportPopup2.frame
            aView.addSubview(viewbg_reportPopup2)
            popover.dismissOnBlackOverlayTap = true
            popover.showAsDialog(aView, inView: self.view)
            tblList_reportPopup2.reloadData()
        } else {
            
            if strReportType == "Report" {
                reportAPI(type:"1", reason: arrReportReasons1[indexPath.row])
            }
            if strReportType == "Report account" {
                reportAPI(type:"2", reason: arrReportReasons2[indexPath.row])
            }
            
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //
    //        if tableView == tblList{
    //            return 44
    //        } else {
    //            return 0
    //        }
    //
    //    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        if tableView == tblList{
    //            let headerView = tblList.dequeueReusableHeaderFooterView(withIdentifier: "ChatHeaderView") as? ChatHeaderView
    //            headerView?.backgroundColor = .clear
    //
    //            if Helper.shared.getStringFromDate(fromFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "dd MMM", date: (arrMessages?[section]["date"])! as! Date) == Helper.shared.getStringFromDate(fromFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "dd MMM", date: Date()) {
    //                headerView?.lblTitle.text = "Today"
    //            } else {
    //                headerView?.lblTitle.text = Helper.shared.getStringFromDate(fromFormat: "yyyy-MM-dd HH:mm:ss Z", toFormat: "dd MMM", date: (arrMessages?[section]["date"])! as! Date)
    //            }
    //
    //            return headerView
    //        } else {
    //            return nil
    //        }
    //
    //    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.frame = CGRect(x: 16, y: 8, width: tableView.frame.width - 32, height: 25)
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 16, y: 8, width: tableView.frame.width - 32, height: 25)
        headerLabel.text = Helper.shared.timeAgoSinceDate(filteredMessages[section]["created_at"] as? String ?? "")
        headerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.gray
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    // Set the height for the header view
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25 // Adjust the height as needed
    }
}

extension OnetoOneChatVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let userModel = Login_LocalDB.getLoginUserModel()

        let receivedMessages = self.arrMessages?.filter( { $0["sender_id"] as? Int == Int(self.strReceiverId) } )
        let senderMessages = self.arrMessages?.filter( { $0["sender_id"] as? Int == userModel.data?.id ?? 0 } )
        
        if receivedMessages?.count ?? 0 < 1 && senderMessages?.count ?? 0 >= 2 {
            
            txtMessage.resignFirstResponder()
            self.bottomSheetBottomConstraint.constant = -182.5
            UIView.animate(withDuration: 0.3) {
                self.bottomSheetBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            return false
            
        } else {
            txtMessage.resignFirstResponder()
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtMessage.resignFirstResponder()
        return true
    }
    
    //EDIT
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //
    //        groupDialog.sendUserStoppedTyping()
    //        groupDialog.sendUserStoppedTyping()
    //    }
    //
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //
    //        groupDialog.sendUserIsTyping()
    //        return true
    //    }
}
/// MARK: - QBChatDelegate
/// //EDIT
//extension OnetoOneChatVC: QBChatDelegate {
//    // MARK: - Manage chat receive message callback's
//    func chatRoomDidReceive(_ message: QBChatMessage, fromDialogID dialogID: String) {
//        // Called whenever group chat dialog did receive a message.
//        // !!!note Will be called on both recipients' and senders' device (with corrected time from server)
//
//        self.arrMsgs?.append(message)
//
//        //
//        let grouped = self.arrMsgs?.sliced(by: [.year, .month, .day], for: \.dateSent!)
//
//        var arr:[[String:Any]] = []
//
//        for (key, value) in grouped ?? [:] {
//
//            arr.append(["date":key,"messages":value])
//        }
//        self.arrMessages = arr.sorted{ $1["date"] as! Date > $0["date"] as! Date  }
//
//        //
//        self.tblList.reloadData()
//        self.tblList.scrollToBottom(isAnimated: false)
//
//        //to mark message as read
//        if message.senderID != QBSession.current.currentUser?.id {
//            QBChat.instance.read(message) { (error) in
//
//            }
//        }
//
//
//        //
//    }
//    func chatDidReceive(_ message: QBChatMessage) {
//        // Called whenever new private message was received from QBChat.
//        // !!!note Will be called only on recipient device
//        print(message)
//    }
//
//    func chatDidReadMessage(withID messageID: String, dialogID: String, readerID: UInt) {
//
//        print(readerID)
//    }
//}
//extension OnetoOneChatVC: QBRTCClientDelegate {
//
//    //audio call
//    func session(_ session: QBRTCSession, userDidNotRespond userID: NSNumber) {
//        HelperAudioCall.shared.session = nil
//        cancelTimer()
//        view.viewWithTag(5001)?.removeFromSuperview()
//        AppHelper.returnTopNavigationController().view.makeToast("No answer".localizableString(lang: Helper.shared.strLanguage))
//        HelperAudioCall.shared.stopSound()
//    }
//
//    func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//
//        (view.viewWithTag(5001) as? AudioCallView)?.lblTimer.isHidden = false
//        HelperAudioCall.shared.stopSound()
//        startTimer()
//        (view.viewWithTag(5001) as? AudioCallView)?.btnAcceptCall.isHidden = true
//        (view.viewWithTag(5001) as? AudioCallView)?.btnRejectCall.isHidden = true
//        (view.viewWithTag(5001) as? AudioCallView)?.btnHungUp.isHidden = false
//        (view.viewWithTag(5001) as? AudioCallView)?.btnMute.isHidden = false
//        (view.viewWithTag(5001) as? AudioCallView)?.btnSpeaker.isHidden = false
//    }
//
//    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//        print("Rejected by user \(userID)")
//        HelperAudioCall.shared.session = nil
//        cancelTimer()
//        view.viewWithTag(5001)?.removeFromSuperview()
//        AppHelper.returnTopNavigationController().view.makeToast("Rejected".localizableString(lang: Helper.shared.strLanguage))
//        HelperAudioCall.shared.stopSound()
//    }
//
//    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//
//        HelperAudioCall.shared.session = nil
//        AppHelper.returnTopNavigationController().view.makeToast("Hung up".localizableString(lang: Helper.shared.strLanguage))
//        cancelTimer()
//        view.viewWithTag(5001)?.removeFromSuperview()
//    }
//}

extension Array {
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}
extension UITableView {
    
    func scrollToBottom(isAnimated:Bool = true){
        
        print(self.numberOfSections)
        
        if self.numberOfSections == 0 {
            return
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
