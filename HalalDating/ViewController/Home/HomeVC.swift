//
//  HomeVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit
import Koloda
import Cartography
import Alamofire
import CoreLocation
import Quickblox
import QuickbloxWebRTC
import GoogleMaps


class HomeVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var collview: UICollectionView!
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var lblNoResultFound: UILabel!
    
    @IBOutlet weak var btnVisibility: UIButton!
    
    @IBOutlet weak var btnExplore: UIButton!
    @IBOutlet weak var btnRelationship: UIButton!
    @IBOutlet weak var btnMarriage: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    
    @IBOutlet weak var lblLogosHeader: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var headerBGView: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    
    
    //MARK: - Veriable
    var loadCardsFromXib = true
    var arrUserList:[UserData] = []
    var arrFlag:[Int] = []
    var selectIndexForDetailProfile = 0
    var arr:[[String:Any]] = []
    var isFromHomeDetailsScreen = false
    
    var intCountArr = 0
    var currentPage = 1
    var last_page = 0
    
    var isLimitCrossed = false
    
    //--
    var latitude = ""
    var longitude = ""
    var centerMapCoordinate:CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    
    //audio call
    var counter:TimeInterval = 0
    var timer = Timer()
    let dateFormatter : DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour,.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    //let audioSession = QBRTCAudioSession.instance()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //var arrDialogs:[QBChatDialog]?
    
    let refreshControl = UIRefreshControl()
    
    // prevent duplicate page requests
    var isFetchingNextPage = false
    var requestedPages = Set<Int>()

    // NEW: overlay loader state (above koloda)
    var isShowingLoaderAboveKoloda = false

    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupUI()
        sendOnlineUserStatusAPI()
        initCurrentLocation()
        
        //audio call
        //EDIT
        /*QBRTCClient.instance().add(self)
         
         
         //make connection to do chat and call
         let currentUser = QBSession.current.currentUser//QBUUser()
         
         if currentUser != nil {
         QBChat.instance.connect(withUserID: currentUser!.id, password: "quickblox", completion: { (error) in
         print(error)
         })
         } else {
         AppHelper.returnTopNavigationController().view.makeToast("Current user is not found")
         }
         
         self.getAllDialogs()*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguageUI()
        setTopView()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
        apiCall_checkSubscription()

        
        if isFromHomeDetailsScreen == false {
            reloadData()
        } else {
            isFromHomeDetailsScreen = false
        }
        
        
        //
        getProfileStatusAPI()
        
        //
        DispatchQueue.global(qos: .userInitiated).async {
//            self.getNotificationsAPI()
//            self.getChatCount()
            self.apiCall_likedUserList()
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.getChatCount()
        })

//        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadge(notification:)), name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadge(notification:)), name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
        timer.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
    }
    
    func setLanguageUI() {
        if Helper.shared.strLanguage == "ar"  {
            viewHeader.semanticContentAttribute = .forceRightToLeft
            //stackviewFilter.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func setupUI() {
        
        collview.dataSource = self
        collview.delegate = self
        
        collview.register(UINib(nibName: "HomeCollCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollCell")
        
        self.kolodaView.dataSource = self
        self.kolodaView.delegate   = self

        //
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collview.alwaysBounceVertical = true
        collview.refreshControl = refreshControl
        
        //
        showLocationSettingsAlert()
        
        //
        ReceiptValidationIAP.shared.receiptValidation()
    }
    
    @objc func refreshBadge(notification: Notification) {
        getChatCount()
//        setChatTabNotificationBadge()
    }
    
    func initCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func showLocationSettingsAlert() {
        
        let userModel = Login_LocalDB.getLoginUserModel()
        if userModel.data?.lat == "" {
            checkAndPromptForLocation()

//            if !hasLocationPermission() {
//                checkIfLocationServicesEnabled()
//            } else {
//                //API call made in locationManager method to update location
//            }
            
        }
//        else if userModel.data?.your_zodiac == "" {
//            showZodiacAlert()
//        }
    }
    
    func checkAndPromptForLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            // Services globally disabled — you could show an alert here if you want
            return
        }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Ask for permission for the first time
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // User already denied — show settings alert
            showSettingsAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            // You’re good to go
            break
        @unknown default:
            break
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: Constant.locationAlertTitle,
            message: Constant.locationAlertMessageHome,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: Constant.cancel, style: .cancel))
        alert.addAction(.init(title: Constant.openSetting, style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        present(alert, animated: true)
    }

    
//    func checkIfLocationServicesEnabled() {
//        
//        if !hasLocationPermission() {
//            let alertController = UIAlertController(title: "Set your location services", message: "We use your location to show you users in your area.", preferredStyle: .alert)
//            
//            let okAction = UIAlertAction(title: "Set location services", style: .default, handler: {(cAlertAction) in
//                //Redirect to Settings app
//                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//                
//                //closes app so that viewdidload called again because alert dismiss on btn tap and doesnt appear again
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        exit(0)
//                    }
//                }
//            })
//            
//            //            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//            //            alertController.addAction(cancelAction)
//            
//            alertController.addAction(okAction)
//            
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
    
    
    func showZodiacAlert() {
        let alertController = UIAlertController(title: kAlertTitle, message: "Please add zodiac sign in Edit Profile", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        
        //alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func didPullToRefresh(_ sender: Any) {
        // Do you your api calls in here, and then asynchronously remember to stop the
        // refreshing when you've got a result (either positive or negative)
        self.collview!.refreshControl?.beginRefreshing()
        //
        reloadData()
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        
        arrFlag.removeAll()
        arrUserList.removeAll()
        intCountArr = 0
        currentPage = 1
        
        isShowingLoaderAboveKoloda = true
        AppHelper.showLinearProgress()
        apiCall_userList(page: 1, isResetIndex: true)
    }
    
    func setTopView() {
        
        if UserDefaults.standard.object(forKey: "status_filter") == nil && UserDefaults.standard.object(forKey: "looking_for_filter") == nil {
            
            //
            btnExplore.setTitleColor(UIColor.black, for: .normal)
            btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
            btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
            btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        } else {
            
            //
            let str_looking_for_filter = UserDefaults.standard.object(forKey: "looking_for_filter") as? String
            let str_status_filter = UserDefaults.standard.object(forKey: "status_filter") as? String
            
            if str_looking_for_filter != nil {
                if str_looking_for_filter == "Marriage" {
                    
                    btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnMarriage.setTitleColor(UIColor.black, for: .normal)
                    btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                } else if str_looking_for_filter == "Relationship" {
                    
                    btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnRelationship.setTitleColor(UIColor.black, for: .normal)
                    btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                } else {
                    
                    btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                    btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                }
            } else if str_status_filter != nil {
                
                btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
                btnOnline.setTitleColor(UIColor.black, for: .normal)
            }
            
        }
        
    }
    
    
    //MARK: - ApiCall
    func apiCall_checkSubscription()  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
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
//                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
//                print(dicsResponseFinal as Any)
                
                let checkSubscriptionModel = CheckSubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!
                if checkSubscriptionModel.code == 200{
                    
                    if let checkSubscriptionModel_ = CheckSubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        ManageSubscriptionInfo.saveSubscriptionInfo(strData: checkSubscriptionModel_)
                    }
                    
                }else if checkSubscriptionModel.code == 401{
                    AppHelper.Logout(navigationController: self.navigationController!)
                }else{
                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                }
            }) { (error) in
                print(error)
                self.view.isUserInteractionEnabled = true
//                AppHelper.hideLinearProgress()
            }
        }
    }
    
    func apiCall_userList(page: Int, isResetIndex: Bool = false, completion: ((Bool) -> Void)? = nil) {
        
        if requestedPages.contains(page) {
            completion?(false)
            return
        }
        requestedPages.insert(page)

        if NetworkReachabilityManager()!.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            requestedPages.remove(page)
            completion?(false)
            return
            
        } else {
            //--
            let age_minimum_filter = UserDefaults.standard.object(forKey: "age_minimum_filter") ?? "18"
            let age_maximum_filter = UserDefaults.standard.object(forKey: "age_maximum_filter") ?? "70"
            let distance_value_filter = UserDefaults.standard.object(forKey: "distance_value_filter") ?? "500"
            let status_filter = UserDefaults.standard.object(forKey: "status_filter") ?? OnlineStatus.no.rawValue
            let relationship_status_filter = UserDefaults.standard.object(forKey: "relationship_status_filter") ?? ""
            let denomination_filter = UserDefaults.standard.object(forKey: "denomination_filter") ?? ""
            let looking_for_filter = UserDefaults.standard.object(forKey: "looking_for_filter") ?? ""
            
            //--
            let dicParam:[String:AnyObject] = ["min_age":age_minimum_filter as AnyObject,
                                               "max_age":age_maximum_filter as AnyObject,
                                               "lat": latitude as AnyObject,
                                                //latitude as AnyObject, //"40.4721137"
                                               "lng": longitude as AnyObject,
                                                //longitude as AnyObject, //"-74.465882"
                                               "distance":distance_value_filter as AnyObject,
                                               "is_online_user":status_filter as AnyObject,
                                               "relation_status":relationship_status_filter as AnyObject,
                                               "denomination":denomination_filter as AnyObject,
                                               "looking_for":looking_for_filter as AnyObject,
                                               "page":page as AnyObject,
                                               "limit":15 as AnyObject]
            let userModel = Login_LocalDB.getLoginUserModel()
            //AppHelper.showLinearProgress()
            //self.view.isUserInteractionEnabled = false
            
            let startTime = Date() // 🕒 Start timestamp
            
            print("URL: \(a_userList)")
//            print("Headers: \(["Authorization":userModel.data?.api_token ?? ""])")
            print("Parameter: \(dicParam)")
            
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_userList, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                
                // hide overlay if needed
                if self.isShowingLoaderAboveKoloda {
                    DispatchQueue.main.async {
                        AppHelper.hideLinearProgress()
                    }
                    self.isShowingLoaderAboveKoloda = false
                }
                 
                if isResetIndex {
                    self.kolodaView.resetCurrentCardIndexSmoothly()
                }
                
                // remove page from requested set now that we have a response
                self.requestedPages.remove(page)
                self.isFetchingNextPage = false

                let dicsResponseFinal = response.replaceNulls(with: "")

                let userListModel = GetNearUserResponse(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel.code == 200{
                    
                    let elapsedTime = Date().timeIntervalSince(startTime)
                    print(String(format: "✅ API succeeded in %.2f seconds", elapsedTime))

                    
                    let dictPage = userListModel.data?[0].page
                    self.last_page = dictPage?["total_page"] as? Int ?? 0
                    print("Total page:\(self.last_page)")

                    self.arrUserList += userListModel.data?[0].userlist ?? []
                    for i in 0..<(userListModel.data?[0].userlist?.count ?? 0) {
                        self.arrFlag.append(userListModel.data?[0].userlist?[i].is_liked_count ?? 0)
                    }

                    DispatchQueue.main.async {
                        if self.arrUserList.count == 0 {
                            UIView.animate(withDuration: 0.3) {
                                self.headerBGView.alpha = 1
                                self.lblLogosHeader.textColor = .black
                                self.imgLogo.tintColor = .white
                                self.btnFilter.tintColor = .white
                                self.btnVisibility.tintColor = .white
                                self.lblNoResultFound.alpha = 1
                            }
                            
                        } else {
                            UIView.animate(withDuration: 0.3) {
                                self.headerBGView.alpha = 0
                                self.lblLogosHeader.textColor = .white
                                self.imgLogo.tintColor = .white
                                self.btnFilter.tintColor = .white
                                self.btnVisibility.tintColor = .white
                                self.lblNoResultFound.alpha = 0
                            }
                        }
                        
                        // after appending & setting currentPage (inside success branch), before dispatching to main:
                        self.currentPage = page
                        self.intCountArr = self.arrUserList.count


                        // then reload UI on main thread as you already do
                        DispatchQueue.main.async {
//                            AppHelper.hideLinearProgress()
                            self.kolodaView.reloadData()
                            self.collview.reloadData()
                            completion?(true)
                        }
                    }
                    
                    //                    let dictPage = userListModel.data?[0].page
                    //
                    //                    if (dictPage?["current_page"] as? Int ?? 0) <= (dictPage?["total_page"] as? Int ?? 0) {
                    //                        print((dictPage?["current_page"] as? Int ?? 0))
                    //
                    //                        if (dictPage?["current_page"] as? Int ?? 0) != (dictPage?["next_page"] as? Int ?? 0) {
                    //                            self.apiCall_userList(page: (dictPage?["next_page"] as? Int ?? 0))
                    //                        } else {
                    //                            print("Last page called")
                    //
                    //                        }
                    //
                    //                    }
                    
                } else if userListModel.code == 401 {
                    AppHelper.Logout(navigationController: self.navigationController!)
                    completion?(false)
                    
                } else {
                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                    completion?(false)
                }
            }) { (error) in
                print(error)
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                completion?(false)
            }
        }
    }
    
    func getChatCount() {
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        guard let networkManager = NetworkReachabilityManager(), networkManager.isReachable else {
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage)",
                    message: internetConnected.localizableString(lang: Helper.shared.strLanguage),
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "OK".localizableString(lang: Helper.shared.strLanguage),
                    style: .default
                ))
                self.present(alert, animated: true)
            }
            return
        }
        
        AF.request( get_chat_count, method: .get, headers: ["Authorization": userModel.data?.api_token ?? ""]).responseJSON { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                do {
                    guard let json = response.value as? [String: Any] else {
                        print("Invalid JSON response")
                        return
                    }
                    
                    guard let code = json["code"] as? Int else {
                        print("Missing or invalid code")
                        return
                    }
                    
                    switch code {
                    case 200:
                        guard let tabItems = self.tabBarController?.tabBar.items, tabItems.count > 2, let data = json["data"] as? [String: Any] else {
                            return
                        }
                        
                        let tabItem = tabItems[2]
                        if let unreadCount = data["un_read_msg"] as? Int {
                            tabItem.badgeValue = unreadCount == 0 ? nil : "\(unreadCount)"
                        }
                        
                    case 401:
                        if let navigationController = self.navigationController {
                            AppHelper.Logout(navigationController: navigationController)
                        }
                        
                    default:
                        print("Unexpected response code: \(code)")
                    }
                }
            }
        }
    }
    
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
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_likedUserList, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
//                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
//                print(dicsResponseFinal as Any)
                
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
    
    func sendOnlineUserStatusAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false { return }
        
        var appVersion = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(online_user, method: .post, parameters: ["app_version": appVersion], encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            //print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
//                    print(json["data"] as? [[String:Any]])
                    
                    
                } else {
                    
                    if json["code"] as? Int == 403 {
                        
                        AppHelper.Logout(navigationController: self.navigationController!)
                        
                        self.view.makeToast(json["message"] as? String ?? "")
                    }
                }
            }
        }
    }
    
    func getProfileStatusAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = [:]
        //AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(get_profile_status, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
//            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = (json["data"] as? [[String:Any]])?[0] as? [String:Any]
                    
                    if dict?["is_public"] as? Int == 0 {
                        self.btnVisibility.setImage(UIImage(named: "eye_hide"), for: .normal)
                    } else {
                        self.btnVisibility.setImage(UIImage(named: "eye_show"), for: .normal)
                    }
                }
            }
            
            //AppHelper.hideLinearProgress()
        }
    }
    
    func apiCall_updateProfile(lat:String, lng:String, address:String, state:String, country:String, country_code:String)  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            let userModel = Login_LocalDB.getLoginUserModel()
            
            //--
            let dicParam:[String:AnyObject] = ["lat":lat as AnyObject,
                                               "lng":lng as AnyObject,
                                               "address":address as AnyObject,
                                               "city":state as AnyObject,
                                               "country":country as AnyObject,
                                               "country_code":country_code as AnyObject]
            
            //AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateProfile, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                //AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
//                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    //--
                    if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        Login_LocalDB.saveLoginInfo(strData: userListModel_)
                    }
                    
                    //show alert if zodiac is not added in profile
//                    if userListModel_.data?.your_zodiac == "" {
//                        self.showZodiacAlert()
//                    }
                    
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
    }
    
    func startChat(userData: UserData) {
        
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "" {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        }
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe" {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        }
        
//        print(userData.room_info)
        
        var dictRoomInfo:[String:Any]?
        if userData.room_info.count != 0 {
            dictRoomInfo = userData.room_info[0]
        }
        
        
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
        
        vc.strReceiverId = "\(userData.id ?? 0)"
        if let room_id = dictRoomInfo?["room_id"] as? String {
            vc.strRoomId = room_id
        } else {
            vc.strRoomId = "no"//if there is no room created then pass "no" to get empty array with 200 response. As Passing empty string ll not give 200 response
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //EDIT
        //let quickbox_id = "\(userData?.quickbox_id ?? "")"
        //processChat(quickbox_id: quickbox_id)
    }
    
    func apiCallUserLikeDislike(like: String, op_user_id: String, index:Int,completion: @escaping (Bool) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            //--
            let dicParam:[String:AnyObject] = ["op_user_id":op_user_id as AnyObject,
                                               "flag":like as AnyObject,
                                               "plan_purchased":ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new as AnyObject]
            
            let userModel = Login_LocalDB.getLoginUserModel()
            //AppHelper.showLinearProgress()
            //self.view.isUserInteractionEnabled = false
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_userLikeDislike, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                //AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userLikeDislikeModel = UserLikeDislikeModel(JSON: dicsResponseFinal as! [String : Any])!
                
                if userLikeDislikeModel.code == 200 {
                    
                    //                    if like == "0" {
                    //                        self.kolodaView?.swipe(.right)
                    //                    } else {
                    //                        self.kolodaView?.swipe(.left)
                    //                    }
                    //                    self.apiCall_userList(page: currentPage)
                    self.isLimitCrossed = false
                    completion(false)
                    print("like success")
                    
                } else if userLikeDislikeModel.code == 401 {
                    completion(true)
                    AppHelper.Logout(navigationController: self.navigationController!)
                    
                    
                } else if userLikeDislikeModel.code == 201 {
                    self.isLimitCrossed = true
                    completion(true)
                    
                    //                    resetKolodaView(index:index)
                    //
                    
                    //                    arrFlag[index] = 0
                    //                    self.collview.reloadData()
                    
                    
                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
                    //                    obj.strSubscriptionType = "Gold"
                    //                    obj.type_subscription = SubscriptionType.swipe
                    obj.strSubscriptionType = "Premium"
                    obj.type_subscription = SubscriptionType.chat_swipe
                    obj.hidesBottomBarWhenPushed = true
                    obj.delegate = self
                    navigationController?.pushViewController(obj, animated: true)
                    
                } else if userLikeDislikeModel.code == 202 {
                    completion(true)
                    
                    let index1 = arrUserList.firstIndex { $0.id ==  Int(op_user_id)}
                    
                    if index1 != nil {
                        
                        //
                        self.kolodaView?.swipe(.left)
                        
                        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchVC") as! MatchVC
                        obj.userModel = arrUserList[index1!]
                        obj.strReceiverId = op_user_id
                        obj.delegate = self
                        obj.modalPresentationStyle = .overFullScreen
                        self.present(obj, animated: true, completion: nil)
                    }
                    
                } else {
                    completion(true)
                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                }
            }) { (error) in
                print(error)
                completion(true)
                self.view.isUserInteractionEnabled = true
                //AppHelper.hideLinearProgress()
            }

            
            ///for testing via log
//            AF.request(a_userLikeDislike, method: .post, parameters: dicParam, encoding: URLEncoding.default, headers: ["Authorization":userModel.data?.api_token ?? ""])
//              .responseData { response in
//                // Request info
//                if let req = response.request {
//                  print("➡️ REQUEST: \(req.httpMethod ?? "") \(req.url?.absoluteString ?? "no-url")")
//                  if let body = req.httpBody, let bodyStr = String(data: body, encoding: .utf8) {
//                    print("➡️ Request body:\n\(bodyStr)")
//                  }
//                }
//
//                // Response status & headers
//                if let http = response.response {
//                  print("⬅️ STATUS: \(http.statusCode)")
//                  print("⬅️ HEADERS: \(http.allHeaderFields)")
//                } else {
//                  print("⬅️ No HTTPURLResponse (possible network error)")
//                }
//
//                // Raw response preview (safe truncation)
//                if let data = response.data {
//                  if let raw = String(data: data, encoding: .utf8) {
//                    let preview = raw.count > 2000 ? String(raw.prefix(2000)) + "\n…(truncated)" : raw
//                    print("🔍 RAW RESPONSE (\(data.count) bytes):\n\(preview)")
//                  } else {
//                    let hexPreview = data.prefix(200).map { String(format: "%02x", $0) }.joined()
//                    print("🔍 RAW RESPONSE (non-utf8, hex preview): \(hexPreview) …")
//                  }
//                } else {
//                  print("🔍 No response data")
//                }
//
//                // Try normal JSON parse and print error if it fails
//                switch response.result {
//                case .success:
//                  do {
//                    let json = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: [])
//                    print("✅ Parsed JSON:", json)
//                  } catch {
//                    print("❌ JSON parse failed:", error)
//                  }
//                case .failure(let afError):
//                  print("❌ Alamofire error:", afError)
//                }
//              }
        }
    }
    
    private func reportUser(id: Int) {
        if NetworkReachabilityManager()!.isReachable == false {
            return
        }
        
        let dicParams:[String:Any] = [
            "type":"Report",
            "reason":"Fake profile",
            "reported_user_id": id
        ]
        
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_report, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
//            print(response)
            AppHelper.hideLinearProgress()
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
//                    self.popover.dismiss()
//                    AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String)
//                    self.navigationController?.popViewController(animated: true)
                    self.view.makeToast(json["message"] as? String)
                } else {
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    

    func submitReport(id: Int, reason: String) {
        if NetworkReachabilityManager()!.isReachable == false {
            return
        }
        
        let userModel = Login_LocalDB.getLoginUserModel()

        let dicParams:[String:Any] = [
            "type":2,
            "reason": reason,
            "reported_user_id": id,
            "user_id": userModel.data?.id ?? 0
        ]
        
        AppHelper.showLinearProgress()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_report, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
//            print(response)
            AppHelper.hideLinearProgress()
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    self.view.makeToast(json["message"] as? String)
                    self.reloadData()
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    func blockUser(id: Int) {
        if NetworkReachabilityManager()!.isReachable == false {
            return
        }
        
        let userModel = Login_LocalDB.getLoginUserModel()

        let dicParams:[String:Any] = [
            "status":1,
            "op_user_id": id,
            "user_id": userModel.data?.id ?? 0
        ]
        
        AppHelper.showLinearProgress()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_block, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            AppHelper.hideLinearProgress()
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    self.view.makeToast(json["message"] as? String)
                    self.reloadData()
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }

    
    func showReportOptions(for userId: Int) {
        let alert = UIAlertController(title: "Report User", message: "Why are you reporting this user?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Fake Profile", style: .default, handler: { _ in
            self.submitReport(id: userId, reason: "Fake Profile")
        }))
        
        alert.addAction(UIAlertAction(title: "Inappropriate Photos", style: .default, handler: { _ in
            self.submitReport(id: userId, reason: "Inappropriate Photos")
        }))
        
        alert.addAction(UIAlertAction(title: "Spam or Scam", style: .default, handler: { _ in
            self.submitReport(id: userId, reason: "Spam or Scam")
        }))
        
        alert.addAction(UIAlertAction(title: "Harassment", style: .default, handler: { _ in
            self.submitReport(id: userId, reason: "Harassment")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // For iPad (prevent crash)
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        self.present(alert, animated: true)
    }
    
    func showBlockUserAlert(userId: Int) {
        let alert = UIAlertController(
            title: "Block User",
            message: "Are you sure you want to block this user? You won't see or match with them again.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Block", style: .destructive) { _ in
            self.blockUser(id: userId)
        })

        present(alert, animated: true)
    }


    
    //MARK: - @IBAction
    @IBAction func btnVisibility(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisibilityVC") as! VisibilityVC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let vc = FilterVC(nibName: "FilterVC", bundle: nil)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTopViewExplore(_ sender: UIButton) {
        
        btnExplore.setTitleColor(UIColor.black, for: .normal)
        btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        
        UserDefaults.standard.setValue(nil, forKey: "looking_for_filter")
        UserDefaults.standard.setValue(nil, forKey: "status_filter")
        UserDefaults.standard.synchronize()
        
        reloadData()
    }
    
    @IBAction func btnTopViewRelationship(_ sender: UIButton) {
        
        btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnRelationship.setTitleColor(UIColor.black, for: .normal)
        btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        
        UserDefaults.standard.setValue("Relationship", forKey: "looking_for_filter")
        UserDefaults.standard.setValue(nil, forKey: "status_filter")
        UserDefaults.standard.synchronize()
        
        //
        reloadData()
    }
    
    @IBAction func btnTopViewMarriage(_ sender: UIButton) {
        
        btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnMarriage.setTitleColor(UIColor.black, for: .normal)
        btnOnline.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        
        UserDefaults.standard.setValue("Marriage", forKey: "looking_for_filter")
        UserDefaults.standard.setValue(nil, forKey: "status_filter")
        UserDefaults.standard.synchronize()
        
        //
        reloadData()
    }
    
    @IBAction func btnTopViewOnline(_ sender: Any) {
        
        btnExplore.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnRelationship.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnMarriage.setTitleColor(UIColor(named: "AppGray"), for: .normal)
        btnOnline.setTitleColor(UIColor.black, for: .normal)
        
        UserDefaults.standard.setValue(nil, forKey: "looking_for_filter")
        UserDefaults.standard.setValue(OnlineStatus.yes.rawValue, forKey: "status_filter")
        UserDefaults.standard.synchronize()
        
        //
        reloadData()
    }
    
    @objc func btnLikeDislike(sender: UIButton){
        
        if arrFlag[sender.tag] == 1 {
            //arrFlag[sender.tag] = 0
            //dislike
            //apiCall_userLikeDislike(like: "1",op_user_id: "\(arrUserList[sender.tag].id)", customSwipe: "", index: sender.tag)
        } else {
            arrFlag[sender.tag] = 1
            //like
//            apiCall_userLikeDislike(like: "0",op_user_id: "\(arrUserList[sender.tag].id)", customSwipe: "", index: sender.tag)
        }
        collview.reloadData()
    }
    
    @objc func btnChat(sender: UIButton) {
        
        
        //
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "" {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        }
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe" {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        //EDIT
        //let quickbox_id = "\(arrUserList[sender.tag].quickbox_id)"
        //processChat(quickbox_id: quickbox_id)
        
//        print(arrUserList[sender.tag].room_info)
        
        var dictRoomInfo:[String:Any]?
        if arrUserList[sender.tag].room_info.count != 0 {
            dictRoomInfo = arrUserList[sender.tag].room_info[0]
        }
        
        
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
        
        vc.strReceiverId = "\(arrUserList[sender.tag].id)"
        if let room_id = dictRoomInfo?["room_id"] as? String {
            vc.strRoomId = room_id
        } else {
            vc.strRoomId = "no"//if there is no room created then pass "no" to get empty array with 200 response. As Passing empty string ll not give 200 response
        }
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeVC:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        if arrUserList.count == 0 {
        //            lblNoResultFound.isHidden = false
        //        } else {
        //            lblNoResultFound.isHidden = true
        //        }
        return arrUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollCell", for: indexPath) as! HomeCollCell
        
        if arrUserList.count != 0 {
            
            //--
            var imgName = arrUserList[indexPath.row].user_image.first?.image ?? ""
            imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
            
            //--
            ImageLoader().imageLoad(imgView: cell.imgMain, url: imgName)
            
            //--
            let dob_str = arrUserList[indexPath.row].dob
            let dob_year = AppHelper.stringToDate(strDate: dob_str, strFormate: "yyyy-MM-dd")
            
            cell.lblTitle.text = "\(arrUserList[indexPath.row].name), \(Date().years(from: dob_year))"
            cell.lblDetail.text = "\(arrUserList[indexPath.row].city), \(arrUserList[indexPath.row].country)"
            
            
            
            //
            let strDeno = "\(((arrUserList[indexPath.row].denomination_id).replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
            cell.lblDenomination.text = strDeno
            
            //
            if arrUserList[indexPath.row].is_online == 1 {// 1 online
                
                cell.imgOnline.isHidden = false
                //cell.imgOnline.image = #imageLiteral(resourceName: "green-circle")
                cell.lblOnlineStatus.text = ""
                cell.lblOnlineDot.isHidden = true
                
            } else if arrUserList[indexPath.row].is_online == 2 {// 2 recently online
                
                cell.imgOnline.isHidden = true
                //cell.imgOnline.image = #imageLiteral(resourceName: "gray-circle")
                cell.lblOnlineStatus.text = "Recently Online"
                cell.lblOnlineDot.isHidden = false
                
            } else if arrUserList[indexPath.row].is_online == 0 {// 0 offline
                
                cell.imgOnline.isHidden = true
                //cell.imgOnline.image = #imageLiteral(resourceName: "gray-circle")
                cell.lblOnlineStatus.text = ""
                cell.lblOnlineDot.isHidden = true
                
            }
            
            if arrFlag[indexPath.row] == 0 {
                cell.btnLikeDislike.setImage(UIImage(named: "ic_like"), for: .normal)
            } else {
                cell.btnLikeDislike.setImage(UIImage(named: "ic_likes_active"), for: .normal)
            }
            
            //         if Helper.shared.strLanguage == "ar"  {
            //             cell.lblTitle.semanticContentAttribute = .forceRightToLeft
            //             cell.lblDetail.semanticContentAttribute = .forceRightToLeft
            //         }
            
            
            //--
            //        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" {
            //            cell?.viewbg_chat.isHidden = false
            //        }else{
            //            cell?.viewbg_chat.isHidden = true
            //        }
            
            //--
            cell.btnLikeDislike.tag = indexPath.row
            cell.btnLikeDislike.addTarget(self, action: #selector(btnLikeDislike(sender:)), for: .touchUpInside)
            cell.btnChat.tag = indexPath.row
            cell.btnChat.addTarget(self, action: #selector(btnChat(sender:)), for: .touchUpInside)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //--
        selectIndexForDetailProfile = indexPath.row
        
        //--
        let vc = OtherProfileVC(nibName: "OtherProfileVC", bundle: nil)
        //vc.userData = arrUserList[indexPath.row]
        vc.delegate = self
        //vc.is_liked_count = arrFlag[indexPath.row]
        vc.intUserId = arrUserList[indexPath.row].id
        vc.intSelectedIndex = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-1, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if intCountArr != self.arrUserList.count {
            if (indexPath.row == (self.arrUserList.count ) - 1 ) { //it's your last cell
                if last_page != currentPage {
                    
                    //Load more data & reload your collection view
                    print("Last row")
                    currentPage = currentPage + 1
                    intCountArr = self.arrUserList.count
                    apiCall_userList(page: currentPage)
                }
            }
        }
    }
}


extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        if latitude == "" && longitude == ""
        {
            latitude = "\(manager.location?.coordinate.latitude ?? 0.0)"
            longitude = "\(manager.location?.coordinate.longitude ?? 0.0)"
            
        }
        
        
        let userModel = Login_LocalDB.getLoginUserModel()
        if userModel.data?.lat == "" && userModel.data?.lng == ""
        {
            
            locationManager.delegate = nil
            getAddressFromCoords(latitude: "\(manager.location?.coordinate.latitude ?? 0.0)", longitude: "\(manager.location?.coordinate.longitude ?? 0.0)")
        }
    }
    
    func getAddressFromCoords(latitude: String, longitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        //21.228124
        let lon: Double = Double("\(longitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        //ceo.accessibilityLanguage = "en-US"
        
        let locale = Locale(identifier: "en_US")
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, preferredLocale: locale, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                print(pm.country)
                print(pm.locality)
                print(pm.subLocality)
                print(pm.thoroughfare)
                print(pm.postalCode)
                print(pm.subThoroughfare)
                
                
                var addressString : String = ""
                var stateString : String = ""
                var countryString : String = ""
                var country_codeString : String = ""
                
                //                        if place.name != nil {
                //                            addressString = addressString + place.name! + ", "
                //                        }
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                    //cityString = pm.locality!
                }
                if pm.administrativeArea != nil {
                    addressString = addressString + pm.administrativeArea! + ", "
                    stateString = pm.administrativeArea!
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                    countryString = pm.country!
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                print(addressString)
                
                //
                self.apiCall_updateProfile(lat: "\(loc.coordinate.latitude)", lng: "\(loc.coordinate.longitude)", address: addressString, state: stateString, country: countryString, country_code: country_codeString)
            }
        })
    }
}


//MARK: -
extension HomeVC: Filter {
    func applyFilter() {
        reloadData()
    }
}


//MARK: -
extension HomeVC: ProfileDetails {
    func likeDislikeFromProfileDetails(likeStatus:Int, selectedIndex:Int) {
        arrFlag[selectedIndex] = likeStatus
        collview.reloadData()
    }
    
    func backButtonClicked(flag: Bool) {
        isFromHomeDetailsScreen = true
    }
}


//MARK: -
extension HomeVC: PremiumMembershipDelegate {
    func backButtonClicked() {
        isFromHomeDetailsScreen = true
    }
}


//MARK: -
extension HomeVC: SendMsgBtnMatchUI {
    func sendMsgBtnClick(strReceiverId: String, strRoomId: String) {
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
        vc.strReceiverId = strReceiverId
        vc.strRoomId = strRoomId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: - Koloda View methods -
extension HomeVC: KolodaViewDataSource {
    func koloda(_ koloda: Koloda.KolodaView, viewForCardAt index: Int) -> UIView {
        
        //        let cell = Bundle.main.loadNibNamed("ProfileOverlayView", owner: self, options: nil)?[0] as? ProfileOverlayView
        //
        //        if !self.arrUserList.isEmpty {
        //            cell?.userData = self.arrUserList[index]
        //        }
        
        //        if !self.arrUserList.isEmpty {
        //            guard index < self.arrUserList.count else {
        //                buttonEnable(false)
        //
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        //                    buttonEnable(true)
        //
        //                    guard index < self.arrUserList.count else {
        //                        print("Error: Index \(index) is still out of bounds after delay.")
        //                        return
        //                    }
        //
        //                    cell?.userData = self.arrUserList[index]
        //                }
        //
        //                // Ensure a view is always returned
        //                return cell ?? ProfileOverlayView()
        //            }
        //
        //            cell?.userData = self.arrUserList[index]
        //        }
        
        
        let cell = Bundle.main.loadNibNamed("ProfileOverlayView", owner: self, options: nil)?[0] as? ProfileOverlayView
        cell?.userData = arrUserList[index] // Direct assignment
        
        
        
        cell?.btnCancelAction = {
            print(index)
            
            guard index < self.arrUserList.count else {
                //buttonEnable(false)
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    buttonEnable(true)
//                    
//                    guard index < self.arrUserList.count else {
//                        print("Error: Index \(index) is still out of bounds after delay.")
//                        return
//                    }
//                    
////                    if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
////                        self.kolodaView.swipe(.left)
////                    }
//                    
//                    let userData = self.arrUserList[index]
////                    self.apiCallUserLikeDislike(like: "1", op_user_id: "\(userData.id)", index: index) {
////                        success in
////                        if !success {
////                            if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
////                                self.kolodaView.swipe(.left)
////                            }
////                        }
////                        
////                    }
//                }
                
                return
            }
            
//            if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
//                self.kolodaView.swipe(.left)
//            }
            
            let userData = self.arrUserList[index]
            buttonEnable(false)
            self.apiCallUserLikeDislike(like: "1", op_user_id: "\(userData.id)", index: index) {
                success in
                buttonEnable(true)
                if !success {
                    if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
                        self.kolodaView.swipe(.left)
                    }
                }
            }

        }
        
        cell?.btnLikeAction = {
            
            guard index < self.arrUserList.count else {
                //buttonEnable(false)
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    buttonEnable(true)
//                    
//                    guard index < self.arrUserList.count else {
//                        print("Error: Index \(index) is still out of bounds after delay.")
//                        return
//                    }
//                    
////                    if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
////                        self.kolodaView.swipe(.right)
////                    }
//                    
//                    let userData = self.arrUserList[index]
////                    self.apiCallUserLikeDislike(like: "0", op_user_id: "\(userData.id)", index: index) {
////                        
////                        success in
////                        if !success {
////                            if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
////                                self.kolodaView.swipe(.right)
////                            }
////                        }
////                    }
//                }
                
                return
            }
            
//            if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
//                self.kolodaView.swipe(.right)
//            }
            
            let userData = self.arrUserList[index]
            buttonEnable(false)
            self.apiCallUserLikeDislike(like: "0", op_user_id: "\(userData.id)", index: index) {
                success in
                buttonEnable(true)
                if !success {
                    if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription == "1" || !self.isLimitCrossed {
                        self.kolodaView.swipe(.right)
                    }
                }
                
            }

        }
        
        cell?.btnCommentAction = {
            
            guard index < self.arrUserList.count else {
                buttonEnable(false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    buttonEnable(true)
                    
                    guard index < self.arrUserList.count else {
                        print("Error: Index \(index) is still out of bounds after delay.")
                        return
                    }
                    
                    self.startChat(userData: self.arrUserList[index])
                }
                return
            }
            
            self.startChat(userData: self.arrUserList[index])
        }
        
        cell?.btnReportAction = {
            guard index < self.arrUserList.count else {
                buttonEnable(false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    buttonEnable(true)
                    
                    guard index < self.arrUserList.count else {
                        print("Error: Index \(index) is still out of bounds after delay.")
                        return
                    }
                    
                    self.showReportOptions(for: self.arrUserList[index].id)
                }
                return
            }
            
            self.showReportOptions(for: self.arrUserList[index].id)
        }
        
        cell?.btnBlockAction = {
            guard index < self.arrUserList.count else {
                buttonEnable(false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    buttonEnable(true)
                    
                    guard index < self.arrUserList.count else {
                        print("Error: Index \(index) is still out of bounds after delay.")
                        return
                    }
                    
                    self.showBlockUserAlert(userId: self.arrUserList[index].id)
                }
                return
            }
            
            self.showBlockUserAlert(userId: self.arrUserList[index].id)
        }
        
        //        cell?.didScroll = { contentOffset in
        //
        //            DispatchQueue.main.async {
        //                if contentOffset > 430  {
        //                    if self.headerBGView.alpha == 0 {
        //                        UIView.animate(withDuration: 0.3) {
        //                            self.headerBGView.alpha = 1
        ////                            self.lblLogosHeader.textColor = .black
        ////                            self.btnFilter.tintColor = .black
        ////                            self.btnVisibility.tintColor = .black
        //                        }
        //                    }
        //                } else {
        //                    if self.headerBGView.alpha == 1 {
        //                        UIView.animate(withDuration: 0.3) {
        //                            self.headerBGView.alpha = 0
        ////                            self.lblLogosHeader.textColor = .white
        ////                            self.btnFilter.tintColor = .white
        ////                            self.btnVisibility.tintColor = .white
        //                        }
        //                    }
        //                }
        //            }
        //        }
        
        cell?.didScroll = { contentOffset in
            UIView.animate(withDuration: 0.1) { // Faster animation
                self.headerBGView.alpha = (contentOffset > 430) ? 1 : 0
                //                self.lblLogosHeader.textColor = (contentOffset > 430) ? .black : .white
            }
        }
        
        func buttonEnable(_ value: Bool) {
            cell?.btnLike.isEnabled = value
            cell?.btnComment.isEnabled = value
            cell?.btnCancel.isEnabled = value
            cell?.btnReport.isEnabled = value
            cell?.btnBlock.isEnabled = value
        }
        
        return cell ?? ProfileOverlayView()
    }
    
    func kolodaNumberOfCards(_ koloda: Koloda.KolodaView) -> Int {
        let cardCount = self.arrUserList.count
        
     
        
        // Prefetch when we're close to end, but guard against duplicate requests
        if cardCount > 0 && cardCount - koloda.currentCardIndex <= 8 && currentPage < last_page && !isFetchingNextPage {
            
            let nextPage = currentPage + 1
            isFetchingNextPage = true
            
            apiCall_userList(page: nextPage) { success in
                AppHelper.hideLinearProgress()
                self.isFetchingNextPage = false
            }
        }
        
        //        if cardCount > 0 && cardCount - koloda.currentCardIndex <= 3 && currentPage < last_page{
        //            currentPage += 1
        //            print("Page added: \(currentPage)")
        //            apiCall_userList(page: currentPage)
        //        }
        
        
        return cardCount
    }
}


extension HomeVC: KolodaViewDelegate, UIScrollViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        // If more pages are available, loader state handled as usual
        if isFetchingNextPage {
            AppHelper.showLinearProgress()
            return
        }
        
        // 👉 Case: No next page and all profiles are liked/swiped
        if currentPage >= last_page && arrUserList.count > 0 {
            UIView.animate(withDuration: 0.3) {
                self.headerBGView.alpha = 1
                self.lblLogosHeader.textColor = .black
                self.imgLogo.tintColor = .white
                self.btnFilter.tintColor = .white
                self.btnVisibility.tintColor = .white
                self.lblNoResultFound.alpha = 1
            }
            AppHelper.hideLinearProgress()
        } else {
            AppHelper.hideLinearProgress()
        }
    }

    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        true
    }

    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
        false
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        false
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return DragSpeed(rawValue: 0.1) ?? .fast // 0.1 seconds for faster animation
    }
}



import Koloda

extension KolodaView {
    /// Smooth reset to first card without flicker
    func resetCurrentCardIndexSmoothly() {
        // Ensure layout is up to date before resetting
        self.layoutIfNeeded()

        UIView.transition(with: self,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.resetCurrentCardIndex()
                          }, completion: nil)
    }
}
