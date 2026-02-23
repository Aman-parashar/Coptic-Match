//
//  SettingsVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit
import Quickblox
import GoogleSignIn
import FBSDKLoginKit
import Alamofire
import MessageUI

class SettingsVC: UIViewController {
    
    //MARK: - Variable
    
    let arrLanguage = ["Change Language".localizableString(lang: Helper.shared.strLanguage),"English","العربية"]
    
    
    //MARK: - IBOutlet
//    @IBOutlet weak var headerView: HeaderView!
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
    
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    @IBOutlet weak var imgArrow3: UIImageView!
    @IBOutlet weak var imgArrow4: UIImageView!
    @IBOutlet weak var imgArrow5: UIImageView!
    @IBOutlet weak var imgArrow6: UIImageView!
    
    @IBOutlet weak var lblHeader: UILabel!
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
//        setHeaderView()
        setupUI()
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
//            headerView.semanticContentAttribute = .forceRightToLeft
//            headerView.lblTitle.semanticContentAttribute = .forceRightToLeft
            view1.semanticContentAttribute = .forceRightToLeft
            view2.semanticContentAttribute = .forceRightToLeft
            view3.semanticContentAttribute = .forceRightToLeft
            view4.semanticContentAttribute = .forceRightToLeft
            view5.semanticContentAttribute = .forceRightToLeft
            view6.semanticContentAttribute = .forceRightToLeft
            view7.semanticContentAttribute = .forceRightToLeft
            
            imgArrow1.semanticContentAttribute = .forceRightToLeft
            imgArrow2.semanticContentAttribute = .forceRightToLeft
            imgArrow3.semanticContentAttribute = .forceRightToLeft
            imgArrow4.semanticContentAttribute = .forceRightToLeft
            imgArrow5.semanticContentAttribute = .forceRightToLeft
            imgArrow6.semanticContentAttribute = .forceRightToLeft
            
            lblLogout.semanticContentAttribute = .forceRightToLeft
            lblPrivacypolicy.semanticContentAttribute = .forceRightToLeft
            lblDeactivateAccount.semanticContentAttribute = .forceRightToLeft
            lblNoti_title.semanticContentAttribute = .forceRightToLeft
            lblSubscription_title.semanticContentAttribute = .forceRightToLeft
            lblTermsondition_title.semanticContentAttribute = .forceRightToLeft
            lblLanguage.semanticContentAttribute = .forceRightToLeft
            
            switchNoti.semanticContentAttribute = .forceRightToLeft
        }
        lblLogout.text = "Logout".localizableString(lang: Helper.shared.strLanguage)
        lblPrivacypolicy.text = "Privacy Policy".localizableString(lang: Helper.shared.strLanguage)
        lblDeactivateAccount.text = "Manage Account".localizableString(lang: Helper.shared.strLanguage)
        lblNoti_title.text = "Notification".localizableString(lang: Helper.shared.strLanguage)
        lblSubscription_title.text = "Subscription".localizableString(lang: Helper.shared.strLanguage)
        lblTermsondition_title.text = "Terms & Conditions".localizableString(lang: Helper.shared.strLanguage)
        lblLanguage.text = "Change Language".localizableString(lang: Helper.shared.strLanguage)
    }
    
    func setupUI() {
        
        lblHeader.text = "Settings".localizableString(lang: Helper.shared.strLanguage)
        
        if UserDefaults.standard.value(forKey: "isNotificationOn") == nil || UserDefaults.standard.value(forKey: "isNotificationOn") as? Int == 0 {
            switchNoti.setOn(true, animated: false)
        } else {
            switchNoti.setOn(false, animated: false)
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }
//    func setHeaderView(){
//        headerView.delegate_HeaderView = self
//        headerView.progressBar.isHidden = true
//        headerView.imgAppIcon.isHidden = true
//        headerView.lblTitle.isHidden = false
//        headerView.lblTitle.text = "Settings".localizableString(lang: Helper.shared.strLanguage)
//    }
    
    //EDIT
    //    func logoutFromQB(completion:@escaping ()->()) {
    //
    //        //
    //        QBChat.instance.disconnect { (error) in
    //
    //            if (error == nil) {
    //                print("Chat disconnected")
    //            } else {
    //                print("Still connected",error?.localizedDescription)
    //            }
    //            QBRequest.logOut(successBlock: { (response) in
    //
    //                print(response.description)
    //                completion()
    //
    //            }, errorBlock: { (response) in
    //                print(response)
    //                completion()
    //            })
    //
    //        }
    //    }
    
    //MARK: - Webservice
    
    func notificationStatusAPI(status:Int) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
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
    
    func logoutAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(logout, method: .post, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    //EDIT
                    //self.logoutFromQB {
                    
                    //
                    GIDSignIn.sharedInstance.signOut()
                    let fbLoginManager : LoginManager = LoginManager()
                    fbLoginManager.logOut()
                    
                    //--
                    AppHelper.removeAllNsUserDefault()
                    DispatchQueue.main.async {
                        UserDefaults.standard.set("false", forKey: "is_Login")
                        UserDefaults.standard.synchronize()
                    }
                    
                    
                    //--
                    let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: vc)
                    //appDelegate.window?.makeKeyAndVisible()
                    //}
                    
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    //MARK: - @IBAction
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
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnPrivacypolicy(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strName = "privacy"
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
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    @IBAction func btnChangeLanguage(_ sender: Any) {
        
        picker.removeFromSuperview()
        toolBar.removeFromSuperview()
        
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done".localizableString(lang: Helper.shared.strLanguage), style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    @IBAction func btnDeactivateAccount(_ sender: Any) {
        
        //--
//        let vc = DeactivateAccountVC(nibName: "DeactivateAccountVC", bundle: nil)
        let vc = ManageAccountVC(nibName: "ManageAccountVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        let logoutAlert = UIAlertController(title: kAlertTitle, message: "Do you want to Logout ?".localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
        logoutAlert.addAction(UIAlertAction(title: "Yes".localizableString(lang: Helper.shared.strLanguage), style: .default, handler: { (action: UIAlertAction!) in
            
            //
            self.logoutAPI()
            
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "No".localizableString(lang: Helper.shared.strLanguage), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        self.navigationController?.present(logoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
}

extension SettingsVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLanguage[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 0 {
            return
        }
        print(arrLanguage[row])
        if row == 1 {
            Helper.shared.strLanguage = "en"
        } else if row == 2 {
            Helper.shared.strLanguage = "ar"
        }
        
        UserDefaults.standard.setValue(Helper.shared.strLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: vc)
    }
}
extension SettingsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
