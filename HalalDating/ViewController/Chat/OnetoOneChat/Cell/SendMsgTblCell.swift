//
//  SendMsgTblCell.swift
//  MVPFitness
//
//  Created by Maulik Vora on 07/04/21.
//

import UIKit

class SendMsgTblCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBubble: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        bgView.backgroundColor = UIColor(hex: "#266FA8")
        imgBubble.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI() {
        bgView.backgroundColor = UIColor(hex: "#266FA8")
        DispatchQueue.main.async {
            self.bgView.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft], radius: 10)
        }
    }
}
