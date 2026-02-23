//
//  ProfileQuestionCollectionCell.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit

class ProfileQuestionCollectionCell: UICollectionViewCell {

    @IBOutlet weak var viewbg: UIView!
    @IBOutlet weak var ic_cat: UIImageView!
    @IBOutlet weak var lblTitl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLanguageUI()
    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            lblTitl.semanticContentAttribute = .forceRightToLeft
            viewbg.semanticContentAttribute = .forceRightToLeft
        }
    }
}
