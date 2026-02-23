//
//  CongratsView.swift
//  HalalDating
//
//  Created by Apple on 05/04/24.
//

import UIKit

class CongratsView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        
    }

    @IBAction func btnTransparent(_ sender: Any) {
        self.removeFromSuperview()
    }

}
