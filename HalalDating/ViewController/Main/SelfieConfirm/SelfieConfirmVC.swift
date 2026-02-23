//
//  SelfieConfirmVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import Alamofire

class SelfieConfirmVC: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var imgSelfie: UIImageView!
    @IBOutlet weak var btnRetake: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var arrSelectedImage = NSMutableArray()
    var imgSelfieSelect = UIImage()
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setHeaderView()
        
        imgSelfie.image = imgSelfieSelect
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            
            view.semanticContentAttribute = .forceRightToLeft
            headerView.semanticContentAttribute = .forceRightToLeft
            headerView.lblTitle.semanticContentAttribute = .forceRightToLeft
        }
        
        btnRetake.setTitle("Retake".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnSubmit.setTitle("Submit".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Selfie".localizableString(lang: Helper.shared.strLanguage)
    }
    
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
    @IBAction func btnRetake(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmit(_ sender: Any) {
        
//        let vc = LocationVC(nibName: "LocationVC", bundle: nil)
//        vc.imgSelfieSelect = imgSelfieSelect
//        vc.userModel = self.userModel
//        vc.arrSelectedImage = self.arrSelectedImage
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.apiCall_updateProfile(quickblox_id: "")
    }
    
}
extension SelfieConfirmVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
