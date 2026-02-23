//
//  AddEmailVC.swift
//  HalalDating
//
//  Created by Apple on 22/02/24.
//

import UIKit
import Alamofire

class AddEmailVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()

        setLanguageUI()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 1, token: userModel.data?.api_token ?? "")
        
//        if let _ = AllowedCountry(rawValue: Helper.shared.currentCountry) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.txtEmail.becomeFirstResponder()
//            }
//        } else {
//            AppHelper.showAlert("Unavailable", message: "This application is not presently accessible in your country.")
//        }
    }

    
    func setLanguageUI() {
        
    }

    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        
//        if let _ = AllowedCountry(rawValue: Helper.shared.currentCountry) {
            
            self.view.endEditing(true)
            if (txtEmail.text?.isEmpty ?? true) {
                self.view.makeToast("Please enter email address")
                return
            }
            
            if !(txtEmail.text?.isValidEmail() ?? false) {
                self.view.makeToast("Please enter valid email address")
                return
            }
            
            Helper.shared.email = txtEmail.text!
            //--
            let vc = iAcceptNewVC(nibName: "iAcceptNewVC", bundle: nil)
            vc.userModel = userModel
            self.navigationController?.pushViewController(vc, animated: true)
//
    }
}
