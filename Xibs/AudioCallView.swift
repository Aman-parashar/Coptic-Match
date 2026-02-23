//
//  AudioCallView.swift
//  Chat
//
//  Created by Apple on 31/10/22.
//

import UIKit

class AudioCallView: UIView {

    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnAcceptCall: UIButton!
    @IBOutlet weak var btnRejectCall: UIButton!
    @IBOutlet weak var btnHungUp: UIButton!
    
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var btnSpeaker: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        
        
    }

}
