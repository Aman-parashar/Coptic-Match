//
//  EnterPhoneNumberView.swift
//  HalalDating
//
//  Created by Apple on 25/11/22.
//

import UIKit

class EnterPhoneNumberView: UIView {

    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    
    override func awakeFromNib() {
        txtMobile.delegate = self
        setLanguageUI()
    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            viewBg.semanticContentAttribute = .forceRightToLeft
            txtMobile.textAlignment = .right
        }
        
        
        txtMobile.placeholder = "Enter your phone number".localizableString(lang: Helper.shared.strLanguage)
        txtCode.placeholder = "Code".localizableString(lang: Helper.shared.strLanguage)
        btnDone.setTitle("Done".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnCancel.setTitle("Cancel".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    @IBAction func btnCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
extension EnterPhoneNumberView:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}
