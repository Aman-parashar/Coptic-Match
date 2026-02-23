//
//  LikeUserCollectionCell.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit

class LikeUserCollectionCell: UICollectionViewCell {

    @IBOutlet weak var ingUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLanguageUI()
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            lblName.semanticContentAttribute = .forceRightToLeft
            lblLocation.semanticContentAttribute = .forceRightToLeft
        }
    }
    func makesViewBlur() {
        DispatchQueue.main.async {
            
            self.viewWithTag(8001)?.removeFromSuperview()
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.tag = 8001
            blurEffectView.layer.cornerRadius = 10
            blurEffectView.clipsToBounds = true
            blurEffectView.frame = self.viewBg.bounds//bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurEffectView)
        }
        
    }

}
