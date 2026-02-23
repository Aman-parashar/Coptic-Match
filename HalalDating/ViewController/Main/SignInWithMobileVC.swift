//
//  SignInWithMobileVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 25/11/21.
//

import UIKit
import SKCountryPicker
import Alamofire
import Toast_Swift


class SignInWithMobileVC: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblByContinuingyouagreetothe_title: UILabel!
    @IBOutlet weak var lblTerms_title: UILabel!
    @IBOutlet weak var lblAnd_title: UILabel!
    @IBOutlet weak var lblPrivacyPolicy_title: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewTerms: UIView!
    @IBOutlet weak var imgFlag: UIImageView!
    
    
    
    //MARK: - Veriable
   
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--
        setLanguageUI()
        //loadGIF()
        
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Put your code which should be executed with a delay here
            self.txtMobileNumber.becomeFirstResponder()
        }
        
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            lblTerms_title.semanticContentAttribute = .forceRightToLeft
            lblAnd_title.semanticContentAttribute = .forceRightToLeft
            lblByContinuingyouagreetothe_title.semanticContentAttribute = .forceRightToLeft
            lblPrivacyPolicy_title.semanticContentAttribute = .forceRightToLeft
            txtMobileNumber.textAlignment = .right
            viewTerms.semanticContentAttribute = .forceRightToLeft
            view.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
        }
        
        
        lblTerms_title.text = "Terms".localizableString(lang: Helper.shared.strLanguage)
        lblAnd_title.text = "and".localizableString(lang: Helper.shared.strLanguage)
        lblByContinuingyouagreetothe_title.text = "By continuing you agree to the".localizableString(lang: Helper.shared.strLanguage)
        lblPrivacyPolicy_title.text = "Privacy Policy".localizableString(lang: Helper.shared.strLanguage)
        txtMobileNumber.placeholder = "Enter your phone number".localizableString(lang: Helper.shared.strLanguage)
        txtCode.placeholder = "Code".localizableString(lang: Helper.shared.strLanguage)
        btnNext.setTitle("Next".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
   
    
    
    
    //MARK: - ApiCall
    func apiCall_login() {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            let devicetoken = UserDefaults.standard.object(forKey: "fcm_devicetoken") as? String ?? "ios"
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

            
            let dicParam:[String:AnyObject] = ["country_code":txtCode.text as AnyObject,
                                               "mobile_no":txtMobileNumber.text as AnyObject,
                                               "fcm_token":devicetoken as AnyObject,
                                               "device_type":"iOS" as AnyObject,
                                               "app_version": appVersion as AnyObject
            ]
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_login, dicsParams: dicParam, headers: [:], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    
                    let vc = objMainSB.instantiateViewController(withIdentifier: "MobileVerificationVC") as! MobileVerificationVC
                    vc.userModel = userListModel_
                    vc.strMobile = self.txtMobileNumber.text!
                    vc.printedOtp = "\(userListModel_.data?.otp ?? 0)"
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    //AppHelper.returnTopNavigationController().view.makeToast("\(userListModel_.data?.otp ?? 0)")
                    print("OTP: \(userListModel_.data?.otp ?? 0)")
//                    AppHelper.showAlert("OTP", message: "OTP: \(userListModel_.data?.otp ?? 0)")
                    
                    
                }else if userListModel_.code == 201{
                    
                    let vc = AdminAppovalVC(nibName: "AdminAppovalVC", bundle: nil)
                    vc.message = dicsResponseFinal?.object(forKey: "message") as? String
                    vc.isBackToHome = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if userListModel_.code == 401{
                    //AppHelper.Logout(navigationController: self.navigationController!)
                }else{
//                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                    
                    if let message = dicsResponseFinal?.object(forKey: "message") as? String {
                        self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                        
                    } else if let messageDict = dicsResponseFinal?["message"] as? [String: Any],
                              let mobileErrors = messageDict["mobile_no"] as? [String],
                              let firstError = mobileErrors.first {
                        self.view.makeToast(firstError)
                    }
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
        if AppHelper.isNull(txtCode.text ?? "") == true {
            AppHelper.showAlert(kAlertTitle, message: k_select_code.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        if AppHelper.isNull(txtMobileNumber.text ?? "") == true {
            AppHelper.showAlert(kAlertTitle, message: k_enter_phone.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        if ("\(txtMobileNumber.text ?? "")").isValidPhoneNumber == false {

            AppHelper.showAlert(kAlertTitle, message: k_enter_valid_phone.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        
        
        apiCall_login()
        
    }
    @IBAction func btnCode(_ sender: Any) {
        self.view.endEditing(true)
        CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            guard let self = self else { return }
            self.txtCode.text = country.dialingCode ?? ""
            self.imgFlag.image = country.flag
        }
    }
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strName = "privacy"
        navigationController?.pushViewController(obj, animated: true)
    }
    @IBAction func btnTerms(_ sender: Any) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        obj.strName = "terms"
        navigationController?.pushViewController(obj, animated: true)
    }
    
}
extension SignInWithMobileVC:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}

