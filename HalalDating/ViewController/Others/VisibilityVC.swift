//
//  VisibilityVC.swift
//  HalalDating
//
//  Created by Apple on 23/02/23.
//

import UIKit
import Alamofire

class VisibilityVC: UIViewController {

    // MARK: - Variable
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var btnVisible: UIButton!
    @IBOutlet weak var btnInvisible: UIButton!
    @IBOutlet weak var lblTitleVisible: UILabel!
    @IBOutlet weak var lblSubtitleVisible: UILabel!
    @IBOutlet weak var lblTitleInvisible: UILabel!
    @IBOutlet weak var lblSubtitleInvisible: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLanguageUI()
        getProfileStatusAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        apiCall_checkSubscription()
    }
    

    // MARK: - Function
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            view1.semanticContentAttribute = .forceRightToLeft
            view2.semanticContentAttribute = .forceRightToLeft
            lblTitleVisible.semanticContentAttribute = .forceRightToLeft
            lblSubtitleVisible.semanticContentAttribute = .forceRightToLeft
            lblTitleInvisible.semanticContentAttribute = .forceRightToLeft
            lblSubtitleInvisible.semanticContentAttribute = .forceRightToLeft
            viewHeader.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
        }
        //lblTitleVisible.text = "Visible".localizableString(lang: Helper.shared.strLanguage)
        //lblSubtitleVisible.text = "Anyone can see your profile".localizableString(lang: Helper.shared.strLanguage)
        //lblTitleInvisible.text = "Invisible".localizableString(lang: Helper.shared.strLanguage)
        //lblSubtitleInvisible.text = "Your profile will not show on search. But you still able to like, match and chat".localizableString(lang: Helper.shared.strLanguage)
        
    }
    
    func openSubscriptionView() {
        
        let customView = Bundle.main.loadNibNamed("SubscriptionView", owner: self)?.first as! SubscriptionView
        customView.tag = 5001
        customView.btnSubscibe.addTarget(self, action: #selector(btnSubscribeNow(sender:)), for: .touchUpInside)
        customView.frame = self.view.frame
        self.view.addSubview(customView)
    }
    
    // MARK: - Webservice
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
    func getProfileStatusAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = [:]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(get_profile_status, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = (json["data"] as? [[String:Any]])?[0] as? [String:Any]
                    
                    if dict?["is_public"] as? Int == 0 {
                        self.btnVisible.setImage(UIImage(named: "radio_empty_template"), for: .normal)
                        self.btnInvisible.setImage(UIImage(named: "radio_filled_template"), for: .normal)
                    } else {
                        self.btnVisible.setImage(UIImage(named: "radio_filled_template"), for: .normal)
                        self.btnInvisible.setImage(UIImage(named: "radio_empty_template"), for: .normal)
                    }
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    func changeProfileStatusAPI(is_public:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = ["is_public":is_public]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(change_profile_status, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = json["data"] as? [String:Any]
                    
                    if is_public == "0" {
                        self.btnVisible.setImage(UIImage(named: "radio_empty_template"), for: .normal)
                        self.btnInvisible.setImage(UIImage(named: "radio_filled_template"), for: .normal)
                    } else {
                        self.btnVisible.setImage(UIImage(named: "radio_filled_template"), for: .normal)
                        self.btnInvisible.setImage(UIImage(named: "radio_empty_template"), for: .normal)
                    }
                    self.view.makeToast("Profile status has been changed successfully".localizableString(lang: Helper.shared.strLanguage))
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnVisible(_ sender: Any) {
        
        changeProfileStatusAPI(is_public: "1")
    }
    
    @IBAction func btnInvisible(_ sender: Any) {
        
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "" || (ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe") {
            
            openSubscriptionView()
        } else {
            changeProfileStatusAPI(is_public: "0")
        }
        
    }
    
    @objc func btnSubscribeNow(sender:UIButton) {
        
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
        obj.strSubscriptionType = "Premium"
        obj.type_subscription = SubscriptionType.chat_swipe
        obj.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(obj, animated: true)
    }
    
}
