//
//  MobileVerificationVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 25/11/21.
//

import UIKit
import Alamofire
import Quickblox

class MobileVerificationVC: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtOtp1: UITextField!
    @IBOutlet weak var txtOtp2: UITextField!
    @IBOutlet weak var txtOtp3: UITextField!
    @IBOutlet weak var txtOtp4: UITextField!
    @IBOutlet weak var lblDidantRecevieOTP: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var printedOtp = ""
    var strMobile = ""
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setOtpTextField()
        
        //--
        lblDetail.text = "\("Please enter the 4-digit code sent by SMS to".localizableString(lang: Helper.shared.strLanguage)) \(userModel.data?.country_code ?? "")\(userModel.data?.mobile_no ?? "")"
        
        //
        if strMobile == "69696969" || strMobile == "68686868" || strMobile == "65656565" || strMobile == "67676767" || strMobile == "63636363" || strMobile == "98989898" || strMobile == "9825729389" || strMobile == "9825729398" {
            let arr = Array(printedOtp)
            txtOtp1.text = "\(arr[0])"
            txtOtp2.text = "\(arr[1])"
            txtOtp3.text = "\(arr[2])"
            txtOtp4.text = "\(arr[3])"
        }
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            view.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
        }
        lbltitle.text = "Verification code".localizableString(lang: Helper.shared.strLanguage)
        lblDetail.text = "Please enter the 4-digit code sent by SMS to".localizableString(lang: Helper.shared.strLanguage)
        lblDidantRecevieOTP.text = "Didn't receive a verification code?".localizableString(lang: Helper.shared.strLanguage)
        btnNext.setTitle("Next".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnResendCode.setTitle("Resend the code".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        
        
    }
    func setOtpTextField()  {
        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
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
//            AppHelper.hideLinearProgress()
//            print(response)
//            print(user)
//            self.loginInQB()
//        }, errorBlock: { (response) in
//            //print(response.error?.reasons)
//            AppHelper.hideLinearProgress()
//            if let dict = response.error?.reasons {
//
//                let errorDict = dict["errors"] as? [String:Any]
//                if let _ = errorDict?["login"] as? [String] {
//                    print("Phone has already been taken")
//                    self.loginInQB()
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
//
//            print(response)
//            print(user)
//
//            DispatchQueue.main.async {
//                UserDefaults.standard.set("true", forKey: "is_Login")
//                UserDefaults.standard.set(self.userModel.data?.notification, forKey: "isNotificationOn")
//                UserDefaults.standard.synchronize()
//            }
//
//
//            AppHelper.openTabBar()
//
//        }, errorBlock: { (response) in
//
//            print(response)
//            AppHelper.hideLinearProgress()
//        })
//    }
    
    //MARK: - ApiCall
    func apiCall_otpVerify()  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let enter_otp = "\(txtOtp1.text ?? "")\(txtOtp2.text ?? "")\(txtOtp3.text ?? "")\(txtOtp4.text ?? "")"
            //--
            let dicParam:[String:AnyObject] = ["otp":enter_otp as AnyObject,
                                               "country_code":userModel.data?.country_code as AnyObject,
                                               "mobile_no":userModel.data?.mobile_no as AnyObject]
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_otpVerify, dicsParams: dicParam, headers: [:], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    
                    if userListModel_.data?.update_profile ?? "" == "1" {
                        
                        if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString() {
                            Login_LocalDB.saveLoginInfo(strData: userListModel_)
                        }
                        
                        //self.signUpInQB()
                        //EDIT
                        DispatchQueue.main.async {
                            UserDefaults.standard.set("true", forKey: "is_Login")
                            UserDefaults.standard.set(self.userModel.data?.notification, forKey: "isNotificationOn")
                            UserDefaults.standard.synchronize()
                        }
                        
                        
                        AppHelper.openTabBar()
                        
                    } else {
                        //--
//                        let vc = iAcceptVC(nibName: "iAcceptVC", bundle: nil)
//                        vc.userModel = userListModel_
//                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmailVC") as! AddEmailVC
                        vc.userModel = userListModel_
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        //--
                        //AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                        
                    }
                } else if userListModel_.code == 401 {
                    //AppHelper.Logout(navigationController: self.navigationController!)
                } else {
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
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any) {
        self.view.endEditing(true)
        
        apiCall_otpVerify()
        
    }
    @IBAction func btnResendCode(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension MobileVerificationVC:UITextFieldDelegate{
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
            case txtOtp3:
                txtOtp4.becomeFirstResponder()
            case txtOtp4:
                txtOtp4.resignFirstResponder()
            default:
                break
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count ?? 0) >= 1) && (string.count > 0) {
            switch textField{
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
            case txtOtp3:
                txtOtp4.becomeFirstResponder()
            case txtOtp4:
                txtOtp4.resignFirstResponder()
            default:
                break
            }
            return false
        }
        return true
    }
    
}
