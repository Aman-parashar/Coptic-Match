//
//  TagListCell.swift
//  HalalDating
//
//  Created by Apple on 20/09/24.
//

import UIKit

class TagListCell: UICollectionViewCell {
    
    var data: String? {
        didSet {
            setData()
        }
    }

    @IBOutlet weak var viewbg: UIView!
    @IBOutlet weak var ic_cat: UIImageView!
    @IBOutlet weak var lblTitl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLanguageUI()
        
        lblTitl.textColor = .white
        viewbg.backgroundColor = UIColor(resource: .blueTagBG)

    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            lblTitl.semanticContentAttribute = .forceRightToLeft
            viewbg.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func setData() {
        lblTitl.text = data
        ic_cat.image = UIImage(named: "iconKid")
    }
}
