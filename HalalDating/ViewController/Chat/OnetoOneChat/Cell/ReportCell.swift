//
//  ReportCell.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLanguageUI()
    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            lblTitle.semanticContentAttribute = .forceRightToLeft
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
