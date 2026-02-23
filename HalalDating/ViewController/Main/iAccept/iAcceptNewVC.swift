//
//  iAcceptNewVC.swift
//  HalalDating
//
//  Created by Apple on 16/07/25.
//

import UIKit

class iAcceptNewVC: UIViewController {
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var btnNext: UIButton!

    
    //MARK: - Veriable
    var userModel = UserModel()
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguageUI()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 2, token: userModel.data?.api_token ?? "")
    }
    
    
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            lblWelcome.semanticContentAttribute = .forceRightToLeft
            lbldescription.semanticContentAttribute = .forceRightToLeft
        }
        
        btnNext.setTitle("I accept".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        //--
        let vc = NameVC(nibName: "NameVC", bundle: nil)
        vc.userModel = userModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
