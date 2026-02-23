//
//  Helper.swift
//  Chat
//
//  Created by Apple on 13/10/22.
//
//EDIT
import UIKit
import QuickbloxWebRTC

class HelperAudioCall: NSObject {

    static let shared = HelperAudioCall()
    
    //audio call
    var session:QBRTCSession?
    var isCallReceived = false
    
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            player?.numberOfLoops = 50
            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        
        player?.stop()
    }
}
