//
//  ManageAccountVC.swift
//  HalalDating
//
//  Created by Apple on 12/11/24.
//

import UIKit
import Alamofire
import GoogleSignIn
import FBSDKLoginKit

class ManageAccountVC: UIViewController {
    
    
    
    //MARK: - @IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDeleteAccount: UILabel!
    @IBOutlet weak var lblLogout: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    
    //MARK: - @IBAction
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDeleteAccountAction(_ sender: UIButton) {
        let vc = DeactivateAccountVC(nibName: "DeactivateAccountVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnLogoutAccountAction(_ sender: UIButton) {
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
    
    
    
    //MARK: - Functions
    func setupUI() {
        
        lblHeader.text = "Manage Account".localizableString(lang: Helper.shared.strLanguage)
        lblDeleteAccount.text = "Delete Account".localizableString(lang: Helper.shared.strLanguage)
        lblLogout.text = "Logout".localizableString(lang: Helper.shared.strLanguage)

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

}
