//
//  ChatVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit
import Quickblox
import Alamofire
import FirebaseFirestore

class ChatVC: UIViewController {
    
    //MARK: - Variable
    var arrInbox:[[String:Any]]?
    var arrDisableRoom:[[String:Any]]?
    var isSubscribedPremium = false
    var arr:[[String:Any]] = []
    var timer = Timer()
    var isCallFirstTime = true
    var inboxListener: ListenerRegistration?
    //MARK: - @IBOutlet
    @IBOutlet weak var heightCollview: NSLayoutConstraint!
    @IBOutlet weak var collview: UICollectionView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblMatches: UILabel!
    @IBOutlet weak var viewWelcome: UIView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblBadge: UILabel!
    
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    @IBOutlet weak var lblTopviewCount: UILabel!
    @IBOutlet weak var imgTopviewHeart: UIImageView!
    @IBOutlet weak var viewTopview: UIView!
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        setLanguageUI()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
        //getAllDialogs()
        listenForConversations()
        //getChatRoomAPI()
        // self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
        //     self.getChatRoomAPI()
        //     NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
        // })
        
        apiCall_checkSubscription()
        
        // Catch-all profile sync for existing logged-in users
        if let userModel = Login_LocalDB.getLoginUserModel().data {
            AppHelper.syncUserToFirestore(userModel: Login_LocalDB.getLoginUserModel())
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUI(notification:)), name: Notification.Name("NotificationIdentifier_RefreshInboxUI"), object: nil)
        

        //
        DispatchQueue.global(qos: .userInitiated).async {
//            self.getNotificationsAPI()
            self.apiCall_likedUserList()
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadge(notification:)), name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshInboxUI"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
        
        //
         inboxListener?.remove() 
        timer.invalidate()
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            lblMatches.semanticContentAttribute = .forceRightToLeft
            viewHeader.semanticContentAttribute = .forceRightToLeft
            lblHeaderTitle.semanticContentAttribute = .forceRightToLeft
            collview.semanticContentAttribute = .forceRightToLeft
            lblWelcome.semanticContentAttribute = .forceRightToLeft
            viewWelcome.semanticContentAttribute = .forceRightToLeft
        }
        lblHeaderTitle.text = "Messages".localizableString(lang: Helper.shared.strLanguage)
        lblMatches.text = "Matches".localizableString(lang: Helper.shared.strLanguage)
        //lblWelcome.text = "Welcome To HalalDating!".localizableString(lang: Helper.shared.strLanguage)
    }
//    @objc func refreshBadge(notification: Notification) {
//        
//        setChatTabNotificationBadge()
//    }
    @objc func refreshUI(notification: Notification) {
        
        //getAllDialogs()
        //getChatRoomAPI()
    }

    func setupUI() {
        
        viewTopview.layer.borderWidth = 2
//        viewTopview.layer.borderColor = #colorLiteral(red: 1, green: 0.2322891653, blue: 0.2753679752, alpha: 1)
        viewTopview.layer.borderColor = UIColor(named: "greenMate")?.cgColor
        viewTopview.layer.cornerRadius = viewTopview.frame.height/2
    }

func listenForConversations() {
    let userModel = Login_LocalDB.getLoginUserModel()
    let userId = "\(userModel.data?.id ?? 0)"
    let db = Firestore.firestore()

    inboxListener = db.collection("users")
        .document(userId)
        .collection("conversations")
        .order(by: "timestamp", descending: true)
        .addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            guard let documents = snapshot?.documents else { return }

            let allConversations = documents.map { $0.data() }
            
            // Match placeholder is set in MatchVC.swift
            let matchPlaceholder = "You matched! Say hi 👋"
            
            self.arrDisableRoom = allConversations.filter { 
                let lastMsg = $0["last_msg_info"] as? [String: Any]
                let msg = lastMsg?["message"] as? String
                // If message is the placeholder OR there's no message info, it's a match
                return msg == matchPlaceholder || lastMsg == nil || msg == nil || msg?.isEmpty == true
            }
            
            self.arrInbox = allConversations.filter { 
                let lastMsg = $0["last_msg_info"] as? [String: Any]
                let msg = lastMsg?["message"] as? String
                // If it has a real message (not the placeholder), it belongs in the inbox
                return msg != nil && !msg!.isEmpty && msg != matchPlaceholder
            }

            // --- Migration Check ---
            if !UserDefaults.standard.bool(forKey: "is_firestore_inbox_migrated") {
                self.migrateExistingConversationsToFirestore()
            }
            // --- End Migration Check ---
print("allConversations \(allConversations)",UserDefaults.standard.bool(forKey: "is_firestore_inbox_migrated"),)
            DispatchQueue.main.async {
                // Handle UI visibility layout
                if self.arrDisableRoom?.count ?? 0 > 0 {
                    self.heightCollview.constant = 100
                    self.heightTopView.constant = 0
                } else {
                    self.heightCollview.constant = 0
                    self.heightTopView.constant = 100
                }
                
                self.tblList.reloadData()
                self.collview.reloadData()
                self.isCallFirstTime = false
                AppHelper.hideLinearProgress()
                
                // Refresh global chat badge
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
            }
        }
}

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
//
//            //self.arrDialogs = dialogs
//            self.arrMatchedDialogs = dialogs.filter { $0.name!.contains("match") }
//            self.arrDirectDialogs = dialogs.filter { $0.name!.contains("direct_chat") }
//
//
//
//            //
//
//            if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || (ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe"){
//
//                if self.arrDirectDialogs?.count ?? 0 > 0 {
//
//                    self.imgTopviewHeart.isHidden = true
//                    self.lblTopviewCount.isHidden = false
//                    self.lblTopviewCount.text = "\(self.arrDirectDialogs?.count ?? 0)"
//                } else {
//                    self.imgTopviewHeart.isHidden = false
//                    self.lblTopviewCount.isHidden = true
//                }
//                self.heightCollview.constant = 0
//                self.heightTopView.constant = 100
//            } else {
//                if self.arrDirectDialogs?.count ?? 0 > 0 {
//                    self.heightCollview.constant = 100
//                } else {
//                    self.heightCollview.constant = 0
//                }
//
//                self.heightTopView.constant = 0
//            }
//
//
//
//            //
//
//
//            self.tblList.reloadData()
//            self.collview.reloadData()
//
//            DispatchQueue.global(qos: .userInitiated).async {
//                self.deleteQBDialogsWhichAlreadyDeletedByOpponent(dialogs: dialogs)
//            }
//
//        }, errorBlock: { response in
//
//        })
//    }
    
//    func getUserDetails(occupantIDs:[NSNumber], cell:ChatUserTblCell) {
//
//
//        DispatchQueue.global(qos: .background).async {
//            // do your job here
//
//            //gets receiver user id
//            var receiverId = ""
//            if let index = occupantIDs.firstIndex(of: NSNumber(value: QBSession.current.currentUser!.id)) {
//
//                if index == 0 {
//                    receiverId = "\(occupantIDs[1])"
//                } else {
//                    receiverId = "\(occupantIDs[0])"
//                }
//
//                //let page = QBGeneralResponsePage(currentPage: 5, perPage: 10)
//                QBRequest.users(withIDs: [receiverId], page: nil, successBlock: { (response, page, users) in
//
//                    let receiverUser = users[0]
//
//                    if receiverUser != nil {
//
//                        DispatchQueue.main.async {
//                            // update ui here
//                            cell.lblName.text = receiverUser.fullName
//                            cell.imgUser.sd_setImage(with: URL(string: "\(kImageBaseURL)\(receiverUser.customData ?? "")"), placeholderImage: UIImage(named: "man"))
//                        }
//                    }
//                }, errorBlock:{ (response) in
//                })
//            }
//        }
//    }
//
//    func getUserDetailsofDirectChat(occupantIDs:[NSNumber], cell:ChatUserDirectCell) {
//
//
//        DispatchQueue.global(qos: .background).async {
//            // do your job here
//
//            //gets receiver user id
//            var receiverId = ""
//            if let index = occupantIDs.firstIndex(of: NSNumber(value: QBSession.current.currentUser!.id)) {
//
//                if index == 0 {
//                    receiverId = "\(occupantIDs[1])"
//                } else {
//                    receiverId = "\(occupantIDs[0])"
//                }
//
//                //let page = QBGeneralResponsePage(currentPage: 5, perPage: 10)
//                QBRequest.users(withIDs: [receiverId], page: nil, successBlock: { (response, page, users) in
//
//                    let receiverUser = users[0]
//
//                    if receiverUser != nil {
//
//                        DispatchQueue.main.async {
//                            // update ui here
//                            cell.imgUser.sd_setImage(with: URL(string: "\(kImageBaseURL)\(receiverUser.customData ?? "")"), placeholderImage: UIImage(named: "man"))
//                        }
//                    }
//                }, errorBlock:{ (response) in
//                })
//            }
//        }
//    }
//
//    func deleteQBDialogsWhichAlreadyDeletedByOpponent(dialogs:[QBChatDialog]) {
//
//        //dispatchGroup is for async task in for loop
//        let group = DispatchGroup()
//
//        var counter = 0
//
//        for i in 0..<dialogs.count {
//            group.enter()
//
//            if (dialogs[i].occupantIDs?.count ?? 0) < 2 {
//                self.deleteSpecificQBDialog(dialogId: dialogs[i].id!, index: i) { result in
//                    defer { group.leave() }
//                    print(result)
//                    counter += 1
//                }
//            } else {
//                defer { group.leave() }
//                counter += 1
//            }
//        }
//
//        group.notify(queue: DispatchQueue.main) {
//            print("All tasks done - \(counter)")
//        }
//    }
//    func deleteSpecificQBDialog(dialogId:String, index: Int, completion: @escaping (String) -> Void) {
//
//        QBRequest.deleteDialogs(withIDs: Set<String>([dialogId]), forAllUsers: true, successBlock: { (deletedObjectsIDs, notFoundObjectsIDs, wrongPermissionsObjectsIDs,arr)  in
//
//            completion("Async Task \(index) Done")
//        }, errorBlock: { (response) in
//
//            if let _ = (response.error?.reasons?["errors"] as? [String]) {
//                if (response.error?.reasons?["errors"] as? [String])?.count != 0 {
//
//                    completion("Async Task \(index) Done")
//                    //AppHelper.returnTopNavigationController().view.makeToast((response.error?.reasons?["errors"] as? [String])?[0])
//                }
//            }
//        })
//    }
    func registerCell(){
        tblList.register(UINib(nibName: "ChatUserTblCell", bundle: nil), forCellReuseIdentifier: "ChatUserTblCell")
        
        collview?.register(UINib(nibName: "ChatUserDirectCell", bundle: nil), forCellWithReuseIdentifier: "ChatUserDirectCell")
    }
    
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
    
    //MARK: Webservice
    
    func getChatRoomAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        if isCallFirstTime {
            AppHelper.showLinearProgress()
        }
        
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(get_chat_room, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    self.arrInbox = (json["data"] as? [String:Any])?["room"] as? [[String:Any]]
                 
                    self.arrDisableRoom = (json["data"] as? [String:Any])?["disable_room"] as? [[String:Any]]
                    
                    //
                    if self.arrDisableRoom?.count ?? 0 > 0 {
                        self.heightCollview.constant = 100
                        self.heightTopView.constant = 0
                    } else {
                        self.heightCollview.constant = 0
                        self.heightTopView.constant = 100
                    }
                    self.tblList.reloadData()
                    self.collview.reloadData()
                    
                    //
                    self.isCallFirstTime = false
                }
            }
            AppHelper.hideLinearProgress()
        }
    }

    func migrateExistingConversationsToFirestore() {
        if NetworkReachabilityManager()!.isReachable == false { return }
        
        // Flag as migrated immediately to prevent multiple sync attempts while network is in progress
        UserDefaults.standard.set(true, forKey: "is_firestore_inbox_migrated")
        
        let userModel = Login_LocalDB.getLoginUserModel()
        let userId = "\(userModel.data?.id ?? 0)"
        let headers:HTTPHeaders = ["Accept":"application/json", "Authorization":userModel.data?.api_token ?? ""]
        let db = Firestore.firestore()

        AF.request(get_chat_room, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let json = response.value as? [String:Any], json["status"] as? String == "Success" {
                let rooms = (json["data"] as? [String:Any])?["room"] as? [[String:Any]] ?? []
                let disabledRooms = (json["data"] as? [String:Any])?["disable_room"] as? [[String:Any]] ?? []
                let allRooms = rooms + disabledRooms
                print("Total rooms to migrate: \(allRooms.count)")
                
                if let firstRoom = allRooms.first {
                    print("First room data keys: \(firstRoom.keys)")
                    print("room_id value: \(String(describing: firstRoom["room_id"])) type: \(type(of: firstRoom["room_id"] ?? "nil"))")
                }

                let batch = db.batch()
                
                for room in allRooms {
                    let senderId = room["sender_id"] as? Int ?? 0
                    let receiverId = room["reciver_id"] as? Int ?? 0
                    
                    // Generate roomId locally for Firestore
                    let roomId = AppHelper.getRoomId(id1: senderId, id2: receiverId)
                    
                    if senderId == 0 || receiverId == 0 { 
                        print("⚠️ Skipping room with invalid IDs: \(room)")
                        continue 
                    }
                    
                    var mutableRoom = room
                    
                    // -- Ensure Firebase-specific keys exist if missing from old backend --
                    if mutableRoom["count_unred_count"] == nil {
                        mutableRoom["count_unred_count"] = 0
                    }
                    if mutableRoom["last_msg_info"] == nil {
                        // If it's a new match with no messages, old backend might have nil last_msg_info
                        // We set it to nil or a placeholder to match our categorization logic
                        mutableRoom["last_msg_info"] = nil 
                    }

                    // Convert updated_at to a Date object for the 'timestamp' field
                    if let updatedAt = room["updated_at"] as? String {
                        let formats = ["yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ", "yyyy-MM-dd HH:mm:ss"]
                        let formatter = DateFormatter()
                        formatter.locale = Locale(identifier: "en")
                        var parsedDate: Date?
                        
                        for format in formats {
                            formatter.dateFormat = format
                            if let date = formatter.date(from: updatedAt) {
                                parsedDate = date
                                break
                            }
                        }
                        mutableRoom["timestamp"] = parsedDate ?? Date()
                    } else {
                        mutableRoom["timestamp"] = FieldValue.serverTimestamp()
                    }
                    
                    let docRef = db.collection("users").document(userId).collection("conversations").document(roomId)
                    batch.setData(mutableRoom, forDocument: docRef, merge: true)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("❌ Firestore batch commit failed:", error)
                        UserDefaults.standard.set(false, forKey: "is_firestore_inbox_migrated") // Reset on failure
                    } else {
                        print("✅ Firestore migration success")
                    }
                }
            } else {
                UserDefaults.standard.set(false, forKey: "is_firestore_inbox_migrated") // Reset on failure
            }
        }
    }

    
    func apiCall_checkSubscription()  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = [:]
            let userModel = Login_LocalDB.getLoginUserModel()
            //AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_checkSubscription, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                
                let checkSubscriptionModel = CheckSubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!
                if checkSubscriptionModel.code == 200{
                    
                    
                    if let checkSubscriptionModel_ = CheckSubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        ManageSubscriptionInfo.saveSubscriptionInfo(strData: checkSubscriptionModel_)
                    }
                    
                    if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0"  || checkSubscriptionModel.data?.is_buy_valid_subscription_new == "" {
                        
                        self.isSubscribedPremium = false
                    } else if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe" {
                        
                        self.isSubscribedPremium = false
                    } else {
                        self.isSubscribedPremium = true
                    }
                    
                }else if checkSubscriptionModel.code == 401{
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
    }
    
    
//    func getChatCount() {
//        
//        let userModel = Login_LocalDB.getLoginUserModel()
//        
//        if NetworkReachabilityManager()!.isReachable == false {
//            
//            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            
//        } else {
//            
//            AF.request(get_chat_count, method: .get, headers: ["Authorization":userModel.data?.api_token ?? ""]).responseJSON { response in
//                
//                if let json = response.value as? [String:Any] {
//                    
//                    
//                    if json["code"] as? Int == 200 {
//                                                    
//                        if let tabItems = self.tabBarController?.tabBar.items {
//                            let tabItem = tabItems[2]
//                            
//                            if let data = json["data"] as? [String: Any] {
//                                
//                                if data["un_read_msg"] as? Int == 0 {
//                                    tabItem.badgeValue = nil
//                                } else {
//                                    tabItem.badgeValue = "\(data["un_read_msg"] as? Int ?? 0)"
//                                }
//                            }
//                        }
//                    } else if json["code"] as? Int == 401{
//                        AppHelper.Logout(navigationController: self.navigationController!)
//                    }
//                }
//            }
//        }
//    }
    
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
//                        self.lblBadge.isHidden = true
//                        
//                        self.setChatTabNotificationBadge()
//                    }
//                    
//                    
//                }
//            }
//            //AppHelper.hideLinearProgress()
//        }
//    }
    func apiCall_likedUserList() {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = [:]
            let userModel = Login_LocalDB.getLoginUserModel()
            //AppHelper.showLinearProgress()
            print("API url is : \(a_likedUserList)")
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_likedUserList, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                
                let userListModel = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel.code == 200{
                    
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[1]
                        
                        if userListModel.dataList.count == 0 {
                            tabItem.badgeValue = nil
                        } else {
                            tabItem.badgeValue = "\(userListModel.dataList.count)"
                        }
                    }
                    
                }else if userListModel.code == 401{
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
    }
    

    func timeAgoSinceDate(_ dateString: String) -> String {
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
        
        guard let date = parsedDate else { return "" }
        
        let now = Date()
        let calendar = Calendar.current
        
        // Get the difference in components between the current time and the input date
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
        
        // Define the time ago logic checking larger units first
        if let year = components.year, year >= 1 {
            if let month = components.month, month >= 1 {
                let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
                return "\(monthName) \(calendar.component(.year, from: date))"
            }
        } else if let month = components.month, month >= 1 {
            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
            return monthName
        } else if let week = components.weekOfYear, week >= 1 {
            return "\(week) week\(week == 1 ? "" : "s") ago"
        } else if let day = components.day, day >= 2 {
            return "\(day) days ago"
        } else if let day = components.day, day == 1 {
            return "Yesterday"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else {
            return "Now"
        }
        
        return "Unknown"
    }

    
    
    
    //MARK: - IBAction
    
    @IBAction func btnNotification(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatIntroVC") as! ChatIntroVC
        navigationController?.pushViewController(obj, animated: true)
        
    }
    
    @IBAction func btnTopview(_ sender: Any) {
        
//        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
//        obj.strSubscriptionType = "Premium"
//        obj.type_subscription = SubscriptionType.chat_swipe
//        navigationController?.pushViewController(obj, animated: true)
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrInbox?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserTblCell") as! ChatUserTblCell
        cell.lblName.text = (arrInbox?[indexPath.row]["reciver_info"] as? [String:Any])?["name"] as? String
        cell.imgUser.sd_setImage(with: URL(string: "\(kImageBaseURL)\((arrInbox?[indexPath.row]["reciver_info"] as? [String:Any])?["selfie"] as? String ?? "")"), placeholderImage: UIImage(named: ""))
        cell.lblLastMessage.text = (arrInbox?[indexPath.row]["last_msg_info"] as? [String:Any])?["message"] as? String
        cell.lblunreadCount.text = "\(arrInbox?[indexPath.row]["count_unred_count"] as? Int ?? 0)"
        
        if arrInbox?[indexPath.row]["count_unred_count"] as? Int == 0 {
            cell.lblunreadCount.isHidden = true
        } else {
            cell.lblunreadCount.isHidden = false
        }
        
        if (arrInbox?[indexPath.row]["last_msg_info"] as? [String:Any])?["created_at"] as? String != nil {
            //cell.lblTime.text = Helper.shared.changeDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ", toFormat: "h:mm a", date: (arrInbox?[indexPath.row]["last_msg_info"] as? [String:Any])?["created_at"] as? String ?? "")
            
            let date = (arrInbox?[indexPath.row]["last_msg_info"] as? [String:Any])?["created_at"] as? String ?? ""
            
//            cell.lblTime.text = setDate(strDate:date)
            cell.lblTime.text = timeAgoSinceDate(date)
        }
        
        if let message = (arrInbox?[indexPath.row]["last_msg_info"] as? [String:Any])?["message"] as? String {
            cell.lblLastMessage.isHidden = false
            cell.youMatchedStackView.isHidden = true
        } else {
            cell.lblLastMessage.isHidden = true
            cell.youMatchedStackView.isHidden = false
        }
        
        cell.btnSayHiAction = {
            
            let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)

            let senderId = self.arrInbox?[indexPath.row]["sender_id"] as? Int ?? 0
            let receiverId = self.arrInbox?[indexPath.row]["reciver_id"] as? Int ?? 0
            
            vc.strReceiverId = "\(receiverId)"
            vc.strRoomId = AppHelper.getRoomId(id1: senderId, id2: receiverId)
            
            // Pass legacy room_id for API calls
            if let legacyId = self.arrInbox?[indexPath.row]["room_id"] as? Int {
                vc.strLegacyRoomId = "\(legacyId)"
            } else if let legacyId = self.arrInbox?[indexPath.row]["room_id"] as? String {
                vc.strLegacyRoomId = legacyId
            }
            
            vc.fromSayHiBtn = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
        //        if arrprofileImgs.count > 0 {
        //            cell.imgProfile.image = arrprofileImgs[indexPath.row]
        //        }
        
        //
        
//        if arrMatchedDialogs?[indexPath.row].occupantIDs != nil && (arrMatchedDialogs?[indexPath.row].occupantIDs?.count ?? 0) >= 2 {
//            getUserDetails(occupantIDs:(arrMatchedDialogs?[indexPath.row].occupantIDs)!, cell: cell)
//        }
        
        return cell
        
        //
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)

        let senderId = arrInbox?[indexPath.row]["sender_id"] as? Int ?? 0
        let receiverId = arrInbox?[indexPath.row]["reciver_id"] as? Int ?? 0
        
        vc.strReceiverId = "\(receiverId)"
        vc.strRoomId = AppHelper.getRoomId(id1: senderId, id2: receiverId)
        
        // Pass legacy room_id for API calls
        if let legacyId = self.arrInbox?[indexPath.row]["room_id"] as? Int {
            vc.strLegacyRoomId = "\(legacyId)"
        } else if let legacyId = self.arrInbox?[indexPath.row]["room_id"] as? String {
            vc.strLegacyRoomId = legacyId
        }
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if (arrMatchedDialogs?[indexPath.row].occupantIDs?.count ?? 0) < 2 {
//            return 0.0
//        }
        return UITableView.automaticDimension
    }
    
}

extension ChatVC:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDisableRoom?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatUserDirectCell", for: indexPath) as! ChatUserDirectCell
        
        cell.lblunreadCount.text = "\(arrDisableRoom?[indexPath.row]["count_unred_count"] as? Int ?? 0)"
        
        if arrDisableRoom?[indexPath.row]["count_unred_count"] as? Int == 0 {
            cell.lblunreadCount.isHidden = true
        } else {
            cell.lblunreadCount.isHidden = false
        }
        
//        if arrDirectDialogs?[indexPath.row].occupantIDs != nil && (arrDirectDialogs?[indexPath.row].occupantIDs?.count ?? 0) >= 2 {
//            getUserDetailsofDirectChat(occupantIDs:(arrDirectDialogs?[indexPath.row].occupantIDs)!, cell: cell)
//        }
        
        cell.imgUser.sd_setImage(with: URL(string: "\(kImageBaseURL)\((arrDisableRoom?[indexPath.row]["reciver_info"] as? [String:Any])?["selfie"] as? String ?? "")"), placeholderImage: UIImage(named: ""))
        
        if !self.isSubscribedPremium {
            cell.imgUser.unBlur()
            cell.imgUser.addBlur(0.8)
        } else {
            cell.imgUser.unBlur()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !self.isSubscribedPremium {
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
        } else {
            
            
            let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)

            let senderId = arrDisableRoom?[indexPath.row]["sender_id"] as? Int ?? 0
            let receiverId = arrDisableRoom?[indexPath.row]["reciver_id"] as? Int ?? 0
            
            vc.strReceiverId = "\(receiverId)"
            vc.strRoomId = AppHelper.getRoomId(id1: senderId, id2: receiverId)
            
            // Pass legacy room_id for API calls
            if let legacyId = self.arrDisableRoom?[indexPath.row]["room_id"] as? Int {
                vc.strLegacyRoomId = "\(legacyId)"
            } else if let legacyId = self.arrDisableRoom?[indexPath.row]["room_id"] as? String {
                vc.strLegacyRoomId = legacyId
            }
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //EDIT
//        if (arrDisableRoom?[indexPath.row].occupantIDs?.count ?? 0) < 2 {
//            return CGSize(width: 0.0, height: 0.0)
//        }
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
}
    
    
    

