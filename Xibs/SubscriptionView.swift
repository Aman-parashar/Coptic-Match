//
//  SubscriptionView.swift
//  HalalDating
//
//  Created by Apple on 23/02/23.
//

import UIKit

class SubscriptionView: UIView {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSubscibe: UIButton!
    
    override func awakeFromNib() {
        
    }

    @IBAction func btnTransparent(_ sender: Any) {
        self.removeFromSuperview()
    }
}
