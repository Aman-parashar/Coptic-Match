//
//  SubscriptionCell.swift
//  HalalDating
//
//  Created by Maulik Vora on 29/11/21.
//

import UIKit

class SubscriptionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewbgMain: UIView!
    
    @IBOutlet weak var lblBestOffer: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewOffer: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLanguageUI()
    }
    
    func setLanguageUI() {
        
        //lblBestOffer.text = "Best offer".localizableString(lang: Helper.shared.strLanguage)
    }
}
