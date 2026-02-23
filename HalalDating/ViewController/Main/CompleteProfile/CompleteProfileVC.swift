//
//  CompleteProfileVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit

class CompleteProfileVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetal2: UILabel!
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()

        setLanguageUI()
        if userModel.data?.user_image.count != 0{
            var imgName = userModel.data?.user_image.first?.image ?? ""
            imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
            
            //--
            ImageLoader().imageLoad(imgView: imgUser, url: imgName)
        }
        lblName.text = "\("Hello".localizableString(lang: Helper.shared.strLanguage)) \(userModel.data?.name ?? ""),"
        
    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            
            
        }
        lblDetail1.text = "We're reviewing your profile.".localizableString(lang: Helper.shared.strLanguage)
        lblDetal2.text = "Once approved we'll make your profile public for other amazing muslims to discover.".localizableString(lang: Helper.shared.strLanguage)
        btnDone.setTitle("Done".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }

    
    //MARK: - @IBAction
    @IBAction func btnDone(_ sender: Any) {
        AppHelper.openTabBar()
    }
    

}
