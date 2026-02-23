//
//  DeactivateAccountVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit
import Alamofire
import Quickblox
import GoogleSignIn
import FBSDKLoginKit

class DeactivateAccountVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
//    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
//    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var viewbgOtherReasontxt: UIView!
    @IBOutlet weak var viewbgOtherReasontext_height: NSLayoutConstraint! //120
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var confirmationBottomSheetBottom: NSLayoutConstraint!
    @IBOutlet weak var deletedBottomSheetBottom: NSLayoutConstraint!
    @IBOutlet weak var deletedBottomSheet: UIView!
    
    @IBOutlet weak var lblAreYouSure: UILabel!
    @IBOutlet weak var lblDeleteWarning: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblAccountDeletedTittle: UILabel!
    @IBOutlet weak var lblAccountDeletedDesc: UILabel!
    
    
    //MARK: - Veriable
//    var arrList = ["I met a partner on Logos", "I met a partner elsewhere", "I want to take a break", "I did't like Logos", "Other"]
    
    var arrList = [
        "Met my partner on Coptic Match".localizableString(lang: Helper.shared.strLanguage),
        "Met my partner somewhere else".localizableString(lang: Helper.shared.strLanguage),
        "Didn't meet anyone".localizableString(lang: Helper.shared.strLanguage),
        "Taking a break".localizableString(lang: Helper.shared.strLanguage),
        "Didn't like Coptic Match".localizableString(lang: Helper.shared.strLanguage),
        "Something else".localizableString(lang: Helper.shared.strLanguage)
    ]
    var selectIndex = 0
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setHeaderView()
        registerCell()
        hiddenOtherTxt()
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            headerView.semanticContentAttribute = .forceRightToLeft
            
        }
        
        lblTitle1.font = UIFont(name: Fonts.SFproSemiBold.rawValue, size: 22)
        lblTitle1.text = "Why do you want to delete your profile?".localizableString(lang: Helper.shared.strLanguage)
        btnSubmit.setTitle("Continue".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        
        lblAreYouSure.text = "Are you sure?".localizableString(lang: Helper.shared.strLanguage)
        lblDeleteWarning.text = "Deleting your account will permanently remove your profile, messages, and all associated data.".localizableString(lang: Helper.shared.strLanguage)
        lblAccountDeletedTittle.text = "Account Deleted Successfully".localizableString(lang: Helper.shared.strLanguage)
        lblAccountDeletedDesc.text = "Your account has been permanently deleted. If you ever decide to return, we'll be here to welcome you back!".localizableString(lang: Helper.shared.strLanguage)
        btnNo.setTitle("No".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnDelete.setTitle("Yes, Delete".localizableString(lang: Helper.shared.strLanguage), for: .normal)

        
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = ""
    }
    func registerCell(){
        tblList.register(UINib(nibName: DeleteAccountCell.className, bundle: nil), forCellReuseIdentifier: DeleteAccountCell.className)
    }
    
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
    func deleteAccountAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let params = ["reason":arrList[selectIndex]]
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AppHelper.showLinearProgress()
        
        AF.request(deactive_account, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            //print(response)
            AppHelper.hideLinearProgress()
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    print(json)
                    //AppHelper.returnTopNavigationController().view.makeToast("Account deleted successfully.".localizableString(lang: Helper.shared.strLanguage))
                    
                    //
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
                    
                    
                    UIView.animate(withDuration: 0.3) {
                        self.confirmationBottomSheetBottom.constant = -214
                        self.view.layoutIfNeeded()
                    }
                    
                    
                    self.deletedBottomSheetBottom.constant = -261
                    UIView.animate(withDuration: 0.3) {
                        self.deletedBottomSheetBottom.constant = 0
                        self.view.layoutIfNeeded()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: vc)
                    }
                    
                        //appDelegate.window?.makeKeyAndVisible()
                    //}
                }
            }
        }
    }
    //MARK: - @IBAction
    @IBAction func btnSubmit(_ sender: Any) {
        
//        deleteAccountAPI()
        
        confirmationBottomSheetBottom.constant = -214
        
        UIView.animate(withDuration: 0.3) {
            self.confirmationBottomSheetBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNoAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.confirmationBottomSheetBottom.constant = -214
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        deleteAccountAPI()
    }
    
    @IBAction func btnAccountDeleted(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.deletedBottomSheetBottom.constant = -261
            self.view.layoutIfNeeded()
        }
    }
    
    
}
extension DeactivateAccountVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count//studentListModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeleteAccountCell.className, for: indexPath) as! DeleteAccountCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrList[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
        
        if indexPath.row == selectIndex{
//            cell.lblTitle.textColor = UIColor(named: "AppRed")
//            cell.viewbg.borderColor = UIColor(named: "AppRed")
            cell.btnRadio.isSelected = true
        } else {
//            cell.lblTitle.textColor = UIColor(named: "AppGray")
//            cell.viewbg.borderColor = UIColor(named: "AppGray")
            cell.btnRadio.isSelected = false
        }
        
        cell.btnRadioAction = {
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row
        tblList.reloadData()
        
        if selectIndex == arrList.count-1{
            showOtherTxt()
        }else{
            hiddenOtherTxt()
        }
    }
    func showOtherTxt(){
        viewbgOtherReasontxt.isHidden = false
        viewbgOtherReasontext_height.constant = 120
    }
    func hiddenOtherTxt(){
        viewbgOtherReasontxt.isHidden = true
        viewbgOtherReasontext_height.constant = 0
    }
}

extension DeactivateAccountVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
