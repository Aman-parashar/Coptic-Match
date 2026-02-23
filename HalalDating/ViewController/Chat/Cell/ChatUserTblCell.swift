//
//  ChatUserTblCell.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit

class ChatUserTblCell: UITableViewCell {
    
    var btnSayHiAction: (() -> ())?

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblunreadCount: UILabel!
    @IBOutlet weak var btnDeleteDialog: UIButton!
    @IBOutlet weak var youMatchedStackView: UIStackView!
    @IBOutlet weak var btnSayHi: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setLanguageUI()
        btnSayHi.addTarget(self, action: #selector(btnSayHiTapped), for: .touchUpInside)
    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            viewBg.semanticContentAttribute = .forceRightToLeft
            lblName.semanticContentAttribute = .forceRightToLeft
            lblLastMessage.semanticContentAttribute = .forceRightToLeft
            lblTime.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func btnSayHiTapped() {
        btnSayHiAction?()
    }
    
}
