//
//  ChatUserDirectCell.swift
//  HalalDating
//
//  Created by Apple on 19/12/22.
//

import UIKit

class ChatUserDirectCell: UICollectionViewCell {

    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblunreadCount: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBg.layer.borderWidth = 2
        viewBg.layer.borderColor = #colorLiteral(red: 1, green: 0.2322891653, blue: 0.2753679752, alpha: 1)
        viewBg.layer.cornerRadius = viewBg.frame.height/2
    }

}
