//
//  NameVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit

class NameVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtEnterName: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var isComeProfile = false
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    let allowedCharacters = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setProgress()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 3, token: userModel.data?.api_token ?? "")
        
//        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 1)
        
        //--
        if isComeProfile{
            setHeaderView()
            setProfile()
            btnNext.setTitle("DONE".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        }else{
            headerView.delegate_HeaderView = self
            btnNext.setTitle("NEXT".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        }
    }
    
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            txtEnterName.textAlignment = .right
            headerView.semanticContentAttribute = .forceRightToLeft
            //imgBack.semanticContentAttribute = .forceRightToLeft
        }
        //lblTitle.text = "What's your name?".localizableString(lang: Helper.shared.strLanguage)
        //lblDetail.text = "Your nick name and don't share your last name".localizableString(lang: Helper.shared.strLanguage)
        txtEnterName.placeholder = "Please enter name".localizableString(lang: Helper.shared.strLanguage)
        
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Edit Profile"
    }
    func setProgress(){
        let percentProgress = Float(1.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: true)
    }
    func setProfile(){
        txtEnterName.text = "\(userModel.data?.name ?? "")"
    }
    
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        self.view.endEditing(true)
        if AppHelper.isNull(txtEnterName.text!) == true {
            AppHelper.showAlert(kAlertTitle, message: k_enter_name.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        
        //--
        userModel.data?.name = txtEnterName.text!
        
        if isComeProfile{
            delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
            self.navigationController?.popViewController(animated: true)
        }else{
            //--
            let vc = DobVC(nibName: "DobVC", bundle: nil)
            vc.userModel = userModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
extension NameVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NameVC: UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        
        //
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        
        if string == filtered {
            
            return setMaxLength(txtfield: textField, range: range, string: string)
            return true
            
        } else {
            
            return false
        }
        
        
    }
    
    func setMaxLength(txtfield:UITextField, range:NSRange, string:String) -> Bool {
        
        //set max length
        let maxLength = 10
        let currentString = (txtfield.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
}

