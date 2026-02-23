//
//  ProfileVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit
import Alamofire
import MessageUI

class ProfileVC: UIViewController {
    
    var arr:[[String:Any]] = []
    var timer = Timer()

    
    //MARK: - @IBOutlet
    @IBOutlet weak var imgUse: UIImageView!
    @IBOutlet weak var lblUname: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblProfilePreview_title: UILabel!
    @IBOutlet weak var lblSharestory_title: UILabel!
    @IBOutlet weak var lblSettigns_title: UILabel!
    @IBOutlet weak var viewSubscribe: UIView!
    @IBOutlet weak var lblSafetytips_title: UILabel!
    @IBOutlet weak var viewProfilePreview: UIView!
    @IBOutlet weak var viewSafetyTips: UIView!
    @IBOutlet weak var viewSettings: UIView!
    @IBOutlet weak var viewMrgPhotos: UIView!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var lblSubscription: UILabel!
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    @IBOutlet weak var imgArrow3: UIImageView!
    @IBOutlet weak var imgArrow4: UIImageView!
    
    
    @IBOutlet weak var lblNoti_title: UILabel!
    @IBOutlet weak var switchNoti: UISwitch!
    @IBOutlet weak var lblSubscription_title: UILabel!
    @IBOutlet weak var lblTermsondition_title: UILabel!
    @IBOutlet weak var lblPrivacypolicy: UILabel!
    @IBOutlet weak var lblDeactivateAccount: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    
    @IBOutlet weak var imgArrow1a: UIImageView!
    @IBOutlet weak var imgArrow2a: UIImageView!
    @IBOutlet weak var imgArrow3a: UIImageView!
    @IBOutlet weak var imgArrow4a: UIImageView!
    @IBOutlet weak var imgArrow5: UIImageView!
    @IBOutlet weak var imgArrow6: UIImageView!

    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setLanguageUI()
        setupUI()
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        setProfile()
        apiCall_checkSubscription()
        
        //
        DispatchQueue.global(qos: .userInitiated).async {
            //            self.getNotificationsAPI()
            self.apiCall_likedUserList()
        }
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshBadge(notification:)), name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
        timer.invalidate()
    }
    
    
    //MARK: - Functions
    func setupUI() {
        if UserDefaults.standard.value(forKey: "isNotificationOn") == nil || UserDefaults.standard.value(forKey: "isNotificationOn") as? Int == 0 {
            switchNoti.setOn(true, animated: false)
        } else {
            switchNoti.setOn(false, animated: false)
        }
    }

    
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            lblProfilePreview_title.semanticContentAttribute = .forceRightToLeft
            lblSafetytips_title.semanticContentAttribute = .forceRightToLeft
            lblSettigns_title.semanticContentAttribute = .forceRightToLeft
            lblSharestory_title.semanticContentAttribute = .forceRightToLeft
            lblSubscription.semanticContentAttribute = .forceRightToLeft
            
            viewProfilePreview.semanticContentAttribute = .forceRightToLeft
            viewSafetyTips.semanticContentAttribute = .forceRightToLeft
            viewSettings.semanticContentAttribute = .forceRightToLeft
            viewMrgPhotos.semanticContentAttribute = .forceRightToLeft
            viewSubscribe.semanticContentAttribute = .forceRightToLeft
            imgArrow1.semanticContentAttribute = .forceRightToLeft
            imgArrow2.semanticContentAttribute = .forceRightToLeft
            imgArrow3.semanticContentAttribute = .forceRightToLeft
            imgArrow4.semanticContentAttribute = .forceRightToLeft
            
        }
        btnEditProfile.setTitle("Edit profile".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnSubscribe.setTitle("Subscribe now".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        
        lblProfilePreview_title.text = "Profile preview".localizableString(lang: Helper.shared.strLanguage)
        
        lblSafetytips_title.text = "Safety tips".localizableString(lang: Helper.shared.strLanguage)
        lblSettigns_title.text = "Settings".localizableString(lang: Helper.shared.strLanguage)
        lblSharestory_title.text = "Successful Marriages Photos".localizableString(lang: Helper.shared.strLanguage)
        //lblSubscription.text = "With premium membership you get marry faster.".localizableString(lang: Helper.shared.strLanguage)
        
        lblLogout.text = "Logout".localizableString(lang: Helper.shared.strLanguage)
        lblPrivacypolicy.text = "Privacy Policy".localizableString(lang: Helper.shared.strLanguage)
        lblDeactivateAccount.text = "Manage Account".localizableString(lang: Helper.shared.strLanguage)
        lblNoti_title.text = "Notification".localizableString(lang: Helper.shared.strLanguage)
        lblSubscription_title.text = "Subscription".localizableString(lang: Helper.shared.strLanguage)
        lblTermsondition_title.text = "Terms & Conditions".localizableString(lang: Helper.shared.strLanguage)
        lblLanguage.text = "Change Language".localizableString(lang: Helper.shared.strLanguage)

    }
    
    func setProfile(){
        let userModel = Login_LocalDB.getLoginUserModel()
        if userModel.data?.user_image.count != 0{
            var imgName = userModel.data?.user_image.first?.image ?? ""
            imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
            
            //--
            ImageLoader().imageLoad(imgView: imgUse, url: imgName)
            
//            DispatchQueue.global(qos: .background).async {
//                    do
//                     {
//                          let data = try Data.init(contentsOf: URL.init(string:imgName)!)
//                           DispatchQueue.main.async {
//                               let image: UIImage = UIImage(data: data)!
//                               self.imgUse.image = image
//                           }
//                     }
//                    catch {
//                           // error
//                          }
//             }
        }
        lblUname.text = "\(userModel.data?.name ?? "")"
    }

//    @objc func refreshBadge(notification: Notification) {
//        
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
    
    //MARK: - Webservice
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
                    
                    if checkSubscriptionModel.data?.is_buy_valid_subscription_new == "0" || checkSubscriptionModel.data?.is_buy_valid_subscription_new == "" {
                        
                        self.viewSubscribe.isHidden = false
                    } else if checkSubscriptionModel.data?.is_buy_valid_subscription_new == "1" && checkSubscriptionModel.data?.type == "Swipe" {
                        
                        self.viewSubscribe.isHidden = false
                    } else {
                        self.viewSubscribe.isHidden = true
                    }
                    
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
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_likedUserList, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
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
    
    func notificationStatusAPI(status:Int) {
        if NetworkReachabilityManager()!.isReachable == false { return }
        
        let dicParams:[String:Any] = ["status":status]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(notification_status, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = json["data"] as? [String:Any]
                    AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String)
                }
            }
            
            AppHelper.hideLinearProgress()
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

    
    
    //MARK: - @IBAction
    @IBAction func btnEditProfile(_ sender: Any) {
        let vc = EditProfileVC(nibName: "EditProfileVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnProfileReview(_ sender: Any) {
        let vc = ProfilePreviewVC(nibName: "ProfilePreviewVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSuccessfulPhotos(_ sender: Any) {
        guard let url = URL(string: "https://halal-dating.com/#success_gallery") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        let vc = SettingsVC(nibName: "SettingsVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSafetytips(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strName = "tips"
        obj.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnDatingTips(_ sender: Any) {
        let vc = DatingTipsVC(nibName: "DatingTipsVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnShareApp(_ sender: Any) {
        
        if let urlStr = NSURL(string: "https://apps.apple.com/us/app/logos-dating/id6477770277?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnSubscribeNow(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
        obj.strSubscriptionType = "Premium"
        obj.type_subscription = SubscriptionType.chat_swipe
        obj.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(obj, animated: true)
    }

    @IBAction func switchNoti(_ sender: UISwitch) {
        
        if sender.isOn{
            
            UserDefaults.standard.setValue(0, forKey: "isNotificationOn")
            UserDefaults.standard.synchronize()
            notificationStatusAPI(status: 0)
        }else{
            UserDefaults.standard.setValue(1, forKey: "isNotificationOn")
            UserDefaults.standard.synchronize()
            notificationStatusAPI(status: 1)
        }
    }
    
    @IBAction func btnSubscription(_ sender: Any) {
        
        //--
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == ""  {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        } else {
            
            let url = URL(string: "https://apps.apple.com/account/subscriptions")
            UIApplication.shared.open(url!, options: [:])
            //            let vc = CurrentSubscriptionVC(nibName: "CurrentSubscriptionVC", bundle: nil)
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnTC(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strName = "terms"
        obj.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnPrivacypolicy(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strName = "privacy"
        obj.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnContactUs(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@coptic-match.com"])
            mail.setSubject("Coptic Match App")
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true)
        } else {
            print("Application is not able to send an email")
        }
    }
    
    @IBAction func btnDeactivateAccount(_ sender: Any) {
        let vc = ManageAccountVC(nibName: "ManageAccountVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension ProfileVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
