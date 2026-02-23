//
//  MainVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 25/11/21.
//


import UIKit
import SwiftyGif
import Alamofire
import Quickblox
import FBSDKLoginKit
import AuthenticationServices
import SKCountryPicker
import GoogleSignIn
import CoreLocation
import MessageUI

class MainVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var lblSignInwithmobile: UILabel!
    @IBOutlet weak var lblContinuewithapple: UILabel!
    @IBOutlet weak var lblContinuewithFacebook: UILabel!
    @IBOutlet weak var lblByContinuingyouagreetothe_title: UILabel!
    @IBOutlet weak var lblTerms_title: UILabel!
    @IBOutlet weak var lblAnd_title: UILabel!
    @IBOutlet weak var lblPrivacyPolicy_title: UILabel!
    
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var viewEnglish: UIView!
    @IBOutlet weak var viewArabic: UIView!
    @IBOutlet weak var viewSigninMobile: UIView!
    @IBOutlet weak var stackviewLang: UIStackView!
    @IBOutlet weak var viewSigninApple: UIView!
    @IBOutlet weak var viewSigninFB: UIView!
    @IBOutlet weak var viewSigninG: UIView!
    @IBOutlet weak var lblContinueWithG: UILabel!
    @IBOutlet weak var viewTerms: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var textViewTermsAndPrivacy: UITextView!
    @IBOutlet weak var btnLoginWithNumber: UIButton!
    @IBOutlet weak var lblMadewithLove: UILabel!
    

    //MARK: - Variables
    var userListModel_:UserModel?
    let locationManager = CLLocationManager()
    
    private var isLocationUpdated = false
    private var currentCountry = ""

    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        //--
        //loadGIF()
        lblMadewithLove.font = UIFont(name: "Fredoka-Regular", size: 24)
        //--
        if UserDefaults.standard.value(forKey: "selectedLanguage") != nil {
            Helper.shared.strLanguage = UserDefaults.standard.value(forKey: "selectedLanguage") as! String
        }
        checkAlreadyLogin()
        setLanguageUI()
//        getCountryName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        checkLocationPermission()
    }
    
    
    //MARK: - Functions
    func setupUI() {
        let attributedString = NSMutableAttributedString(string: "Terms & Condition and Privacy Policy")
        let termsConditionsRange = (attributedString.string as NSString).range(of: "Terms & Condition")
        let privacyPolicyRange = (attributedString.string as NSString).range(of: "Privacy Policy")

        attributedString.addAttribute(.font, value: UIFont(name: "SF Pro Text Regular", size: 14) ?? .systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))

        // Add links
        attributedString.addAttribute(.link, value: "terms://", range: termsConditionsRange) // Custom URL scheme for Terms & Conditions
        attributedString.addAttribute(.font, value: UIFont(name: "SF Pro Text Regular", size: 14) ?? .systemFont(ofSize: 14), range: termsConditionsRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsConditionsRange) // Underline


        attributedString.addAttribute(.link, value: "privacy://", range: privacyPolicyRange) // Custom URL scheme for Privacy Policy
        attributedString.addAttribute(.font, value: UIFont(name: "SF Pro Text Regular", size: 14) ?? .systemFont(ofSize: 14), range: privacyPolicyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange) // Underline

        textViewTermsAndPrivacy.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        textViewTermsAndPrivacy.textAlignment = .center
        textViewTermsAndPrivacy.contentMode = .center
        textViewTermsAndPrivacy.attributedText = attributedString
        textViewTermsAndPrivacy.backgroundColor = .clear
        textViewTermsAndPrivacy.delegate = self
        textViewTermsAndPrivacy.isSelectable = true
        textViewTermsAndPrivacy.isEditable = false
        textViewTermsAndPrivacy.delaysContentTouches = false
        textViewTermsAndPrivacy.isScrollEnabled = false
    }
    
        
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            stackviewLang.semanticContentAttribute = .forceRightToLeft
            lblSignInwithmobile.semanticContentAttribute = .forceRightToLeft
            lblContinuewithapple.semanticContentAttribute = .forceRightToLeft
            lblContinuewithFacebook.semanticContentAttribute = .forceRightToLeft
            lblContinueWithG.semanticContentAttribute = .forceRightToLeft
            lblTerms_title.semanticContentAttribute = .forceRightToLeft
            lblAnd_title.semanticContentAttribute = .forceRightToLeft
            lblByContinuingyouagreetothe_title.semanticContentAttribute = .forceRightToLeft
            lblPrivacyPolicy_title.semanticContentAttribute = .forceRightToLeft
            viewSigninMobile.semanticContentAttribute = .forceRightToLeft
            viewSigninApple.semanticContentAttribute = .forceRightToLeft
            viewSigninFB.semanticContentAttribute = .forceRightToLeft
            viewSigninG.semanticContentAttribute = .forceRightToLeft
            viewTerms.semanticContentAttribute = .forceRightToLeft
            viewBg.semanticContentAttribute = .forceRightToLeft
        }
        lblLanguage.text = "English".localizableString(lang: Helper.shared.strLanguage)
        //lblTItle.text = "#1 Marriage App For Muslims 🥇".localizableString(lang: Helper.shared.strLanguage)
        //lblSignInwithmobile.text = "Signin with phone number".localizableString(lang: Helper.shared.strLanguage)
        lblContinuewithapple.text = "Continue with Apple".localizableString(lang: Helper.shared.strLanguage)
        lblContinuewithFacebook.text = "Continue with Facebook".localizableString(lang: Helper.shared.strLanguage)
        lblContinueWithG.text = "Continue with Google".localizableString(lang: Helper.shared.strLanguage)
        //lblTerms_title.text = "Terms".localizableString(lang: Helper.shared.strLanguage)
        //lblAnd_title.text = "and".localizableString(lang: Helper.shared.strLanguage)
        //lblByContinuingyouagreetothe_title.text = "By continuing you agree to the".localizableString(lang: Helper.shared.strLanguage)
        //lblPrivacyPolicy_title.text = "Privacy Policy".localizableString(lang: Helper.shared.strLanguage)
        
        
    }
    
    func loadGIF(){
        do {
            let gif = try UIImage(gifName: "home_ezgif.gif")
            imgBackground.setGifImage(gif, loopCount: -1)
        } catch {
            print(error)
        }
    }
    
    func checkAlreadyLogin(){
        let userModel_ = Login_LocalDB.getLoginUserModel()
        if userModel_.data?.mobile_no.count != 0 && userModel_.data?.mobile_no != nil{
            
            if (UserDefaults.standard.value(forKey: "is_Login") as? String) == "true" && (UserDefaults.standard.value(forKey: "is_Login") as? String) != nil {
                
//                if QBSession.current.currentUser == nil {
//                    AppHelper.showLinearProgress()
//                    QBRequest.logIn(withUserLogin: "\(userModel_.data?.country_code ?? "")\(userModel_.data?.mobile_no ?? "")", password: "quickblox", successBlock: { (response, user) in
//                        //Block with response and user instances if the request is succeeded.
//                        AppHelper.hideLinearProgress()
//                        print(response)
//                        print(user)
//                        AppHelper.openTabBar()
//
//                    }, errorBlock: { (response) in
//                        //Block with response instance if the request is failed.
//                        //print(response.error?.reasons)
//                        AppHelper.hideLinearProgress()
//                        print("Unauthorized")
//                        AppHelper.returnTopNavigationController().view.makeToast("Unauthorized")
//                    })
//                } else {
                //EDIT
                    AppHelper.openTabBar()
                //}
            }
            
        }
    }

    func getFBUserData(){
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start { connection, result, error in
                
                if (error == nil){
                    print(result!)
                    let dict = result as! [String:Any]
                    
                    let pictureDict = dict["picture"] as? [String:Any]
                    
                    let dataDict = pictureDict?["data"] as? [String:Any]
                    let strPictureURL = dataDict?["url"] ?? ""
                    print(strPictureURL)
                    
                    var dict1:[String:String] = [:]
                    //dict1["first_name"] = (dict["first_name"] ?? "") as? String
                    //dict1["last_name"] = (dict["last_name"] ?? "") as? String
                    //dict1["email"] = (dict["email"] ?? "") as? String
                    dict1["facebook_id"] = (dict["id"] ?? "") as? String
                    
                    Helper.shared.email = (dict["email"] ?? "") as? String ?? ""
                    
                    self.socialLoginAPI(dict:dict1)
                }
            }
        }
    }
    
    private func getCountryName() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        let status = locationManager.authorizationStatus
        if status == .denied || status == .restricted {
//            handleDeniedPermission()
        } else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func handleDeniedPermission() {
        let alert = UIAlertController(
            title: Constant.locationAlertTitle,
            message: Constant.locationAlertMessageMain,
            preferredStyle: .alert
        )
        //        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Constant.openSetting, style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
//        let cancelAction = UIAlertAction(
//            title: "Cancel",
//            style: .cancel,
//            handler: nil
//        )
//        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
//    func signUpInQB() {
//
//        AppHelper.showLinearProgress()
//
//        let user = QBUUser()
//        user.login = "\(self.userListModel_?.data?.country_code ?? "")\(self.userListModel_?.data?.mobile_no ?? "")"//"myLogin"
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
//        QBRequest.logIn(withUserLogin: "\(self.userListModel_?.data?.country_code ?? "")\(self.userListModel_?.data?.mobile_no ?? "")", password: "quickblox", successBlock: { (response, user) in
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
//        updateUserParameter.fullName = self.userListModel_?.data?.name
//        //updateUserParameter.password = nil//"quickblox"
//
//        if self.userListModel_?.data?.user_image.count != 0 && self.userListModel_?.data?.user_image != nil {
//
//            if let img = self.userListModel_?.data?.user_image[0].image {
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
//            UserDefaults.standard.set("true", forKey: "is_Login")
//            UserDefaults.standard.set(self.userListModel_?.data?.notification, forKey: "isNotificationOn")
//            UserDefaults.standard.synchronize()
//
//            AppHelper.openTabBar()
//
//        }, errorBlock: { (response) in
//
//            print(response)
//            AppHelper.hideLinearProgress()
//        })
//    }

    
    
    //MARK: - Webservice
    func socialLoginAPI(dict:[String:Any])  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let devicetoken = UserDefaults.standard.object(forKey: "fcm_devicetoken") as? String ?? "ios"
            //dict["facebook_id"]
            var dicParam:[String:AnyObject] = ["device_type":"iOS" as AnyObject,
                                               "fcm_token":devicetoken as AnyObject]
            
            for (key, value) in dict {
                dicParam[key] = value as AnyObject?
            }
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(check_social_login, dicsParams: dicParam, headers: [:], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                self.userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if self.userListModel_?.code == 200{
                    
                    if self.userListModel_?.data?.mobile_no == "" || self.userListModel_?.data?.mobile_no == nil {
                        
                        let customView = Bundle.main.loadNibNamed("EnterPhoneNumberView", owner: self)?.first as! EnterPhoneNumberView
                        customView.tag = 5001
                        customView.btnDone.addTarget(self, action: #selector(self.btnDoneTappedOnPhonePopup(sender:)), for: .touchUpInside)
                        customView.btnCountryCode.addTarget(self, action: #selector(self.btnCountryCode(sender:)), for: .touchUpInside)
                        customView.frame = self.view.frame
                        self.view.addSubview(customView)
                    }
                    
                    if self.userListModel_?.data?.phone_status == 1 {
                        
                        if self.userListModel_?.data?.update_profile == "0" {
                            
                            let vc = iAcceptNewVC(nibName: "iAcceptNewVC", bundle: nil)
                            vc.userModel = self.userListModel_!
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            
                            //AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                        } else {
                            if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString() {
                                Login_LocalDB.saveLoginInfo(strData: userListModel_)
                            }
                            //self.signUpInQB()
                            //EDIT
                            UserDefaults.standard.set("true", forKey: "is_Login")
                            UserDefaults.standard.set(self.userListModel_?.data?.notification, forKey: "isNotificationOn")
                            UserDefaults.standard.synchronize()
                            
                            AppHelper.openTabBar()
                        }
                    }
                    
                    if self.userListModel_?.data?.phone_status == 0 && self.userListModel_?.data?.mobile_no != "" && self.userListModel_?.data?.mobile_no != nil {
                        
                        let vc = objMainSB.instantiateViewController(withIdentifier: "MobileVerificationVC") as! MobileVerificationVC
                        vc.userModel = self.userListModel_!
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        //AppHelper.returnTopNavigationController().view.makeToast("\(self.userListModel_?.data?.otp ?? 0)")
                        print("OTP: \(self.userListModel_?.data?.otp ?? 0)")
                    }
                } else if self.userListModel_?.code == 401 {
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
    
    func checkMobileNumberAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        AppHelper.showLinearProgress()
        
        let dicParams:[String:String] = ["country_code":(self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtCode.text!,
            "mobile_no":(self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtMobile.text!]
        
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userListModel_?.data?.api_token ?? ""]
        
        AF.request(check_mobile_no, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = json["data"] as? [String:Any]
                    if dict?["is_mobile_no"] as? String == "1" {
                        self.view.viewWithTag(5001)?.removeFromSuperview()
                        AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String)
                    } else {
                        
                        self.userListModel_?.data?.country_code = (self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtCode.text!
                        self.userListModel_?.data?.mobile_no = (self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtMobile.text!

                    }
                    
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    
    
    //MARK: - @IBAction
    @IBAction func btnLoginWithMobile(_ sender: Any) {
        
//        if currentCountry == "" {
//            checkLocationPermission()
//        } else {
            
//            if let allowedCountry = AllowedCountry(rawValue: currentCountry) {
                let vc = objMainSB.instantiateViewController(withIdentifier: "SignInWithMobileVC") as! SignInWithMobileVC
                self.navigationController?.pushViewController(vc, animated: true)
//            } else {
//                AppHelper.showAlert("Unavailable", message: "This application is not presently accessible in your country.")
//            }
//        }
    }
    
    @IBAction func btnLoginWithApple(_ sender: Any) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()

        let request = appleIDProvider.createRequest()

        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self

        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
    }
    
    @IBAction func btnLoginWithFb(_ sender: Any) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    //fbLoginManager.logOut()
                }
            }
        }
    }
    
    @IBAction func btnLoginWithGoogle(_ sender: Any) {
        
        let signInConfig = GIDConfiguration(clientID: Helper.shared.google_clientID)
        
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//            guard error == nil else { return }
//
//            let userId = user?.userID                  // For client-side use only!
//            //let idToken = user?.authentication.idToken // Safe to send to the server
//            //let fullName = user?.profile?.name
//            let email = user?.profile?.email
//
//            var dict1:[String:String] = [:]
//            dict1["google_id"] = userId!
//
//
//            Helper.shared.email = email ?? ""
//
//            self.socialLoginAPI(dict:dict1)
//          }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print("Error during Google Sign-In: \(error!.localizedDescription)")
                return
            }

            // Access user details
            guard let user = signInResult?.user else { return }
            let userId = user.userID                   // User ID (client-side only)
            let email = user.profile?.email            // User email

            var dict1: [String: String] = [:]
            dict1["google_id"] = userId ?? ""

            Helper.shared.email = email ?? ""

            self.socialLoginAPI(dict: dict1)
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
    
    @IBAction func btnLanguagePopup(_ sender: UIButton) {
        
        if sender.tag == 0 {
            sender.tag = 1
            viewEnglish.isHidden = false
            viewArabic.isHidden = false
        } else {
            sender.tag = 0
            viewEnglish.isHidden = true
            viewArabic.isHidden = true
        }
    }
    
    @IBAction func btnSupport(_ sender: Any) {
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
    
    @IBAction func btnSelectLanguage(_ sender: UIButton) {
       
        if sender.tag == 0 {
            Helper.shared.strLanguage = "en"
        } else {
            Helper.shared.strLanguage = "ar"
        }
        UserDefaults.standard.setValue(Helper.shared.strLanguage, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        
        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: vc)
    }
    
    @objc func btnDoneTappedOnPhonePopup(sender:UIButton) {
        self.view.endEditing(true)
        
        if AppHelper.isNull((self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtCode.text ?? "") == true {
            AppHelper.showAlert(kAlertTitle, message: k_select_code.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        if AppHelper.isNull((self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtMobile.text ?? "") == true {
            AppHelper.showAlert(kAlertTitle, message: k_enter_phone.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        if ("\((self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtMobile.text ?? "")").isValidPhoneNumber == false {

            AppHelper.showAlert(kAlertTitle, message: k_enter_valid_phone.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        
        checkMobileNumberAPI()
    }
    
    @objc func btnCountryCode(sender:UIButton) {
        self.view.endEditing(true)
        CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            guard let self = self else { return }
            (self.view.viewWithTag(5001) as! EnterPhoneNumberView).txtCode.text = country.dialingCode ?? ""
        }
    }
}



//MARK: - UItextview delegate methods
extension MainVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if URL.scheme == "terms" {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
            obj.strName = "terms"
            navigationController?.pushViewController(obj, animated: true)
            return false
        
        } else if URL.scheme == "privacy" {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
            obj.strName = "privacy"
            navigationController?.pushViewController(obj, animated: true)
            return false
        }
        
        return true
    }
}



extension MainVC: ASAuthorizationControllerDelegate {
    // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account as per your requirement
            
            let appleId = appleIDCredential.user
            
            let appleUserFirstName = appleIDCredential.fullName?.givenName
            
            let appleUserLastName = appleIDCredential.fullName?.familyName
            
            let appleUserEmail = appleIDCredential.email
            
            //Write your code
            
            if let _ = appleUserEmail {
                
                var dict:[String:String] = [:]
                //dict["first_name"] = appleUserFirstName
                //dict["last_name"] = appleUserLastName
                //dict["email"] = appleUserEmail
                dict["apple_id"] = "\(appleId)"
                
                Helper.shared.email = appleUserEmail ?? ""
                
                self.socialLoginAPI(dict:dict)
                
                //dict["device_type"] = "ios"
                //dict["device_token"] = Helper.shared.device_token
                
                
                //putEntryToUsersDatabase(dict: dict, loginType: "Apple")
            } else {
                //Toast.show(message: Message.email_necessary, controller: self)
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let appleUsername = passwordCredential.user
            
            let applePassword = passwordCredential.password
            
            //Write your code
            
        }
        
    }
}

extension MainVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
        
    }
}




//MARK: - CLLocationManagerDelegate methods
extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !isLocationUpdated else { return }
        isLocationUpdated = true // Ensure it runs only once
        manager.stopUpdatingLocation() // Stop location updates
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }

            if let country = placemarks?.first?.country {
                print("Country name: \(country)")
                Helper.shared.currentCountry = country
                
//                if let _ = AllowedCountry(rawValue: self.currentCountry) {
//                    
//                } else {
//                    AppHelper.showAlert("Unavailable", message: "This application is not presently accessible in your country.")
//                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            handleDeniedPermission()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}


extension MainVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
