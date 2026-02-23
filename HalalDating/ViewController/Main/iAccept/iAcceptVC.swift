//
//  iAcceptVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 01/12/21.
//

import UIKit

class iAcceptVC: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblBeHonestTitle: UILabel!
    @IBOutlet weak var lblBeHonestSubtitle: UILabel!
    @IBOutlet weak var lblRespectTitle: UILabel!
    @IBOutlet weak var lblRespectSubtile: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblMissionTitle: UILabel!
    @IBOutlet weak var lblMissionSubtitle: UILabel!
    
    
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
            
            lblBeHonestTitle.semanticContentAttribute = .forceRightToLeft
            lblBeHonestSubtitle.semanticContentAttribute = .forceRightToLeft
            lblRespectTitle.semanticContentAttribute = .forceRightToLeft
            lblRespectSubtile.semanticContentAttribute = .forceRightToLeft
            lblMissionTitle.semanticContentAttribute = .forceRightToLeft
            lblMissionSubtitle.semanticContentAttribute = .forceRightToLeft
        }
        
        //lblWelcome.text = "Welcome To HalalDating!".localizableString(lang: Helper.shared.strLanguage)
        lblBeHonestTitle.text = "Be Honest"
        //lblBeHonestSubtitle.text = "HalalDating Only For Those Seriously Looking For Marriage".localizableString(lang: Helper.shared.strLanguage)
        //lblRespectTitle.text = "Be Respectful"
        //lblRespectSubtile.text = "You're here to find real love so please be respectful to others."
        //lblMissionTitle.text = "Our Mission"
        //lblMissionSubtitle.text = "Our support team will manually review every user profile and do our best to eliminate scammers and fake profiles. You will have the highest chance to find your ideal match here."
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
