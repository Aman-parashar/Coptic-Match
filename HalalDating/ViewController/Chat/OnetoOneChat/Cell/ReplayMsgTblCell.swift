//
//  ReplayMsgTblCell.swift
//  MVPFitness
//
//  Created by Maulik Vora on 07/04/21.
//

import UIKit

class ReplayMsgTblCell: UITableViewCell {

    @IBOutlet weak var imgBubble: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var bgView: UIView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.backgroundColor = .systemGray5
        imgBubble.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        DispatchQueue.main.async {
            self.bgView.roundCorners(corners: [.bottomLeft, .bottomRight, .topRight], radius: 10)
        }
    }

    
}
