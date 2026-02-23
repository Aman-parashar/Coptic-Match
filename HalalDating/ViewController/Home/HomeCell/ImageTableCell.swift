//
//  ImageTableCell.swift
//  HalalDating
//
//  Created by Apple on 28/11/24.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    var imageURLStr: String! {
        didSet {
            if let url = URL(string: imageURLStr) {
                
                imgMain.sd_imageIndicator?.startAnimatingIndicator()
                
                imgMain.sd_setImage(with: url) { _, _, _, _ in
                    self.imgMain.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }
        }
    }

    @IBOutlet weak var imgMain: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
