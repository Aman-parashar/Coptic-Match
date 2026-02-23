//
//  ImageCell.swift
//  HalalDating
//
//  Created by Apple on 20/09/24.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
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

}
