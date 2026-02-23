//
//  AppUpdateView.swift
//  Snagpay
//
//  Created by Apple on 23/04/22.
//

import UIKit

class AppUpdateView: UIView {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblTitleNewVersionAvailable: UILabel!
    
    override func awakeFromNib() {
        
        setLanguage()
    }
    func setLanguage() {
        
        btnCancel.setTitle("Cancel".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnUpdate.setTitle("Update".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTitleNewVersionAvailable.text = "New app version available".localizableString(lang: Helper.shared.strLanguage)
        
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        if let url = URL(string: "itms-apps://apple.com/app/id6477770277") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
}
