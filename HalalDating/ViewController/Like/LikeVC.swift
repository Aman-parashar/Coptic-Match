//
//  LikeVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit
import Alamofire

class LikeVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblFindPartner: UILabel!
    @IBOutlet weak var lblNoLikes: UILabel!
    @IBOutlet weak var collectionList: UICollectionView!
    @IBOutlet weak var lblLikeHeader: UILabel!
    @IBOutlet weak var viewbg_seewholikes: UIView!
    @IBOutlet weak var viewbg_blur_bothlike: UIView!
    @IBOutlet weak var viewbg_bothLike: UIView!
    @IBOutlet weak var imgLoginUser: UIImageView!
    @IBOutlet weak var imgLikedUser: UIImageView!
    @IBOutlet weak var lblLikedUser_name: UILabel!
    @IBOutlet weak var viewbg_empty: UIView!
    @IBOutlet weak var btnSeeWhoLikes: UIButton!
    
    //MARK: - Veriable
    var isSubscribedPremium = false
    var userListModel = UserModel()
    var arr:[[String:Any]] = []
    
    var timer = Timer()

    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.viewbg_empty.isHidden = true
        setLanguageUI()
        apiCall_checkSubscription()
        apiCall_likedUserList()
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        //
        DispatchQueue.global(qos: .userInitiated).async {
//            self.getNotificationsAPI()
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadge(notification:)), name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
        })

    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            collectionList.semanticContentAttribute = .forceRightToLeft
            
        }
        lblNoLikes.text = "No likes yet?".localizableString(lang: Helper.shared.strLanguage)
        lblFindPartner.text = "Find your partner faster with premium membership".localizableString(lang: Helper.shared.strLanguage)
        lblLikeHeader.text = "Likes".localizableString(lang: Helper.shared.strLanguage)
        btnSeeWhoLikes.setTitle("SEE WHO LIKES YOU".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    func registerCell(){
        collectionList.register(UINib(nibName: "LikeUserCollectionCell", bundle: nil), forCellWithReuseIdentifier: "LikeUserCollectionCell")
    }

//    @objc func refreshBadge(notification: Notification) {
        
//        setChatTabNotificationBadge()
//    }
    
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
    
    func redirectToSubscriptionUI() {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
        obj.strSubscriptionType = "Premium"
        obj.type_subscription = SubscriptionType.chat_swipe
        obj.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(obj, animated: true)
    }

    
    //MARK: - ApiCall
    func apiCall_userLikeDislike(like: String, op_user_id: String)  {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = ["op_user_id":op_user_id as AnyObject,
                                               "flag":like as AnyObject,
                                               "plan_purchased":ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new as AnyObject]
            let userModel = Login_LocalDB.getLoginUserModel()
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_userLikeDislike, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userLikeDislikeModel = UserLikeDislikeModel(JSON: dicsResponseFinal as! [String : Any])!
                if userLikeDislikeModel.code == 202 {
                    
                    let index = userListModel.dataList.firstIndex { $0.id ==  Int(op_user_id)}

                    if index != nil {
                        
                        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchVC") as! MatchVC
                        obj.userModel = userListModel.dataList[index!]
                        obj.strReceiverId = op_user_id
                        obj.delegate = self
                        obj.modalPresentationStyle = .overFullScreen
                        self.present(obj, animated: true, completion: nil)
                    }
                    
                }else if userLikeDislikeModel.code == 401{
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
            self.view.isUserInteractionEnabled = false
            print("API URL ",a_likedUserList)
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_likedUserList, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                userListModel = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel.code == 200{
                    collectionList.reloadData()
                    
                    //
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[1]
                        
                        if userListModel.dataList.count == 0 {
                            tabItem.badgeValue = nil
                        } else {
                            tabItem.badgeValue = "\(userListModel.dataList.count)"
                        }
                    }
                    
                    //
                    if userListModel.dataList.count != 0 {
                        viewbg_empty.isHidden = true
                        collectionList.isHidden = false
                    }else{
                        viewbg_empty.isHidden = false
                        collectionList.isHidden = true
                        
                        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "" {
                            
                            self.lblNoLikes.text = "No likes yet?".localizableString(lang: Helper.shared.strLanguage)
                            self.lblFindPartner.isHidden = false
                        } else if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe" {
                            
                            self.lblNoLikes.text = "No likes yet?".localizableString(lang: Helper.shared.strLanguage)
                            self.lblFindPartner.isHidden = false
                        } else {
                            self.lblNoLikes.text = "No likes yet".localizableString(lang: Helper.shared.strLanguage)
                            self.lblFindPartner.isHidden = true
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
                print(dicsResponseFinal as Any)
                
                let checkSubscriptionModel = CheckSubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!
                if checkSubscriptionModel.code == 200{
                    
                    
                    if let checkSubscriptionModel_ = CheckSubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        ManageSubscriptionInfo.saveSubscriptionInfo(strData: checkSubscriptionModel_)
                    }
                    
                    if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || checkSubscriptionModel.data?.is_buy_valid_subscription_new == "" {
                        
                        self.isSubscribedPremium = false
                        self.viewbg_seewholikes.isHidden = false
                    } else if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe" {
                        
                        self.isSubscribedPremium = false
                        self.viewbg_seewholikes.isHidden = false
                    } else {
                        self.isSubscribedPremium = true
                        self.viewbg_seewholikes.isHidden = true
                    }
                    self.collectionList.reloadData()
                    
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
//                    
//                }
//            }
//            //AppHelper.hideLinearProgress()
//        }
//    }
    
    func removeFromLikedListAPI(op_user_id:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request("\(remove_to_like_users_list)\(op_user_id)", method: .post, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            //print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    print(json["data"] as? [[String:Any]])
                    self.apiCall_likedUserList()
                    
                }
            }
        }
    }
    
    
    //MARK: - @IBAction
    @IBAction func btnSeeWhoLikes(_ sender: Any) {
        redirectToSubscriptionUI()
        
    }
    
    @objc func btnLike(sender:UIButton) {
        
        if isSubscribedPremium == true{
            //--
            apiCall_userLikeDislike(like: "0",op_user_id: "\(userListModel.dataList[sender.tag].id)")
        } else {
            redirectToSubscriptionUI()
        }
    }
    
    @objc func btnRemoveFromLikesList(sender:UIButton) {
        
        if isSubscribedPremium == true{
            //--
            removeFromLikedListAPI(op_user_id: "\(userListModel.dataList[sender.tag].id)")
        } else {
            redirectToSubscriptionUI()
        }
    }

}

extension LikeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        //let height = collectionView.frame.size.height
        return CGSize(width: (width/2)-5, height: 240)
      
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userListModel.dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeUserCollectionCell", for: indexPath) as! LikeUserCollectionCell
        
        //--
        var imgName = userListModel.dataList[indexPath.row].user_image.first?.image ?? ""
        imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
        
        //--
        ImageLoader().imageLoad(imgView: cell.ingUser, url: imgName)
        
        
        //--
        let dob_str = userListModel.dataList[indexPath.row].dob
        let dob_year = AppHelper.stringToDate(strDate: dob_str, strFormate: "yyyy-MM-dd")
            
        cell.lblName.text = "\(userListModel.dataList[indexPath.row].name), \(Date().years(from: dob_year))"
        cell.lblLocation.text = "\(userListModel.dataList[indexPath.row].city), \(userListModel.dataList[indexPath.row].country)"
        
        if !self.isSubscribedPremium {
            cell.makesViewBlur()
        } else {
            cell.viewWithTag(8001)?.removeFromSuperview()
        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnLike(sender:)), for: .touchUpInside)
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(btnRemoveFromLikesList(sender:)), for: .touchUpInside)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSubscribedPremium == true {
            let vc = ProfilePreviewVC(nibName: "ProfilePreviewVC", bundle: nil)
            vc.isFromProfile = false
            vc.strUserId = "\(userListModel.dataList[indexPath.row].id)"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
extension LikeVC: ProfileDetails {
    func backButtonClicked(flag: Bool) {
        print("")
    }
    
    func likeDislikeFromProfileDetails(likeStatus:Int, selectedIndex:Int) {
        //
        print("")
        
    }
}
extension LikeVC: SendMsgBtnMatchUI {
    
    func sendMsgBtnClick(strReceiverId: String, strRoomId: String) {
        
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
        vc.strReceiverId = strReceiverId
        vc.strRoomId = strRoomId
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
