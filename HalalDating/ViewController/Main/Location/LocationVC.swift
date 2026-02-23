//
//  LocationVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 01/12/21.
//

import UIKit
import Alamofire
import Quickblox

class LocationVC: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK: - Veriable
    var userModel = UserModel()
    var arrSelectedImage = NSMutableArray()
    var imgSelfieSelect = UIImage()
    
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setHeaderView()
        setHorizontalGradientColor(view: scrollview)
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            
            headerView.semanticContentAttribute = .forceRightToLeft
        }
        lblTitle.text = "Welcome to halaldating".localizableString(lang: Helper.shared.strLanguage)
        lblDetail.text = "The Best Islamic marriage app worldwide  We have a lot of successful marriage stories and we wish you will be the next story".localizableString(lang: Helper.shared.strLanguage)
        btnDone.setTitle("Welcome".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = ""
    }
    func setHorizontalGradientColor(view: UIView) {
        
        let gradientLayer = CAGradientLayer()
        var updatedFrame = view.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [#colorLiteral(red: 1, green: 0.3333333333, blue: 0.3333333333, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.6862745098, blue: 0.2941176471, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.7058823529, blue: 0.3137254902, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    //EDIT
//    func signUpInQB() {
//
//        AppHelper.showLinearProgress()
//
//        let user = QBUUser()
//        user.login = "\(userModel.data?.country_code ?? "")\(userModel.data?.mobile_no ?? "")"//"myLogin"
//        //user.fullName = "Ramesh"
//        //user.email = txtEmail.text
//        user.password = "quickblox"
//
//        QBRequest.signUp(user, successBlock: { response, user in
//
//            AppHelper.hideLinearProgress()
//
//            print(response)
//            print(user)
//            self.loginInQB()
//        }, errorBlock: { (response) in
//            //print(response.error?.reasons)
//            AppHelper.hideLinearProgress()
//
//            if let dict = response.error?.reasons {
//
//                let errorDict = dict["errors"] as? [String:Any]
//                if let _ = errorDict?["login"] as? [String] {
//                    print("Mobile number has already been taken")
//                    AppHelper.showAlert(kAlertTitle, message: "Mobile number has already been taken")
//                    //self.loginInQB()
//                }
//            }
//        })
//    }
//
//    func loginInQB() {
//
//        AppHelper.showLinearProgress()
//
//        QBRequest.logIn(withUserLogin: "\(userModel.data?.country_code ?? "")\(userModel.data?.mobile_no ?? "")", password: "quickblox", successBlock: { (response, user) in
//            //Block with response and user instances if the request is succeeded.
//            AppHelper.hideLinearProgress()
//            print(response)
//            print(user)
//
//            self.updateQB_ServerUserDetails()
//
//        }, errorBlock: { (response) in
//            //Block with response instance if the request is failed.
//            //print(response.error?.reasons)
//            AppHelper.hideLinearProgress()
//            print("Unauthorized")
//            AppHelper.returnTopNavigationController().view.makeToast("Unauthorized")
//        })
//    }
//
//    func updateQB_ServerUserDetails() {
//
//        AppHelper.showLinearProgress()
//
//        let updateUserParameter = QBUpdateUserParameters()
//        updateUserParameter.fullName = userModel.data?.name
//        //updateUserParameter.password = nil//"quickblox"
//
//        if userModel.data?.user_image.count != 0 && userModel.data?.user_image != nil {
//
//            if let img = userModel.data?.user_image[0].image {
//                updateUserParameter.customData = img
//            }
//        }
//
//        QBRequest.updateCurrentUser(updateUserParameter, successBlock: {response, user in
//
//            AppHelper.hideLinearProgress()
//            print(response)
//            print(user)
//
//
//
//            self.apiCall_updateProfile(quickblox_id: "\(user.id)")
//
//        }, errorBlock: { (response) in
//
//            AppHelper.hideLinearProgress()
//            print(response)
//        })
//    }
    
    //MARK: - ApiCall

    func apiCall_updateProfile(quickblox_id: String)  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            var strEmail = ""
            
            if userModel.data?.email == "" || userModel.data?.email == nil {
                strEmail = Helper.shared.email
            } else {
                strEmail = userModel.data?.email ?? ""
            }
            
            
            let devicetoken = UserDefaults.standard.object(forKey: "fcm_devicetoken") as? String ?? "ios"
            
            
            let dicParam:[String:AnyObject] = ["name":userModel.data?.name as AnyObject,
                                               "dob":userModel.data?.dob as AnyObject,
                                               "gender":userModel.data?.gender as AnyObject,
                                               "relation_status":userModel.data?.relation_status as AnyObject,
                                               "kids":userModel.data?.kids as AnyObject,
                                               "education":userModel.data?.education as AnyObject,
                                               "height":userModel.data?.height as AnyObject,
                                               "looking_for":userModel.data?.looking_for as AnyObject,
                                               "work_out":userModel.data?.work_out as AnyObject,
                                               "language_id":userModel.data?.language_id as AnyObject,
                                               "denomination_id":userModel.data?.denomination_id as AnyObject,
                                               "religious":userModel.data?.religious as AnyObject,
                                               "pray":userModel.data?.pray as AnyObject,
                                               "eating":userModel.data?.eating as AnyObject,
                                               "go_church":userModel.data?.go_church as AnyObject,
                                               "smoke":userModel.data?.smoke as AnyObject,
                                               "alcohol":userModel.data?.alcohol as AnyObject,
                                               "your_zodiac":userModel.data?.your_zodiac as AnyObject,
                                               "married_year":userModel.data?.married_year as AnyObject,
                                               "fcm_token":devicetoken as AnyObject,
                                               "device_type":"iOS" as AnyObject,
                                               "email":strEmail as AnyObject,
                                               "quickbox_id":quickblox_id as AnyObject,
                                               "lat":userModel.data?.lat as AnyObject,
                                               "lng":userModel.data?.lng as AnyObject,
                                               "address":userModel.data?.address as AnyObject,
                                               "city":userModel.data?.state as AnyObject,
                                               "country":userModel.data?.country as AnyObject,
                                               "mobile_no":userModel.data?.mobile_no as AnyObject,
                                               "country_code":userModel.data?.country_code as AnyObject,
                                               "update_profile":"1" as AnyObject,
                                               "selfie":arrSelectedImage[0] as AnyObject,
                                               "image[]":arrSelectedImage as AnyObject]
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateProfile, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    
                    if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        Login_LocalDB.saveLoginInfo(strData: userListModel_)
                    }
                    
                    UserDefaults.standard.set("true", forKey: "is_Login")
                    UserDefaults.standard.set(self.userModel.data?.notification, forKey: "isNotificationOn")
                    UserDefaults.standard.synchronize()
                    
                    AppHelper.openTabBar()
                    
//                    let vc = CompleteProfileVC(nibName: "CompleteProfileVC", bundle: nil)
//                    vc.userModel = userListModel_
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    //AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                    
                }else if userListModel_.code == 401{
                    //AppHelper.Logout(navigationController: self.navigationController!)
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
    
    //MARK: - @IBAction
    @IBAction func btnDone(_ sender: Any) {
        
        //signUpInQB()
        //EDIT
        self.apiCall_updateProfile(quickblox_id: "")
    }
    
}
extension LocationVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
