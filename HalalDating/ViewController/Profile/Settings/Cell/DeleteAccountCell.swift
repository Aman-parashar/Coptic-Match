//
//  DeleteAccountCell.swift
//  HalalDating
//
//  Created by Apple on 23/09/24.
//

import UIKit

class DeleteAccountCell: UITableViewCell {
    
    var btnRadioAction: (() -> ())?

    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnRadio.addTarget(self, action: #selector(btnRadioTapped), for: .touchUpInside)
        btnRadio.setImage(UIImage(named: "iconRadioUnSelected"), for: .normal)
        btnRadio.setImage(UIImage(named: "iconRadioSelected"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func btnRadioTapped() {
        btnRadioAction?()
    }
    
}
