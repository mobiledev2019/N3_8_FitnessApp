//
//  PlayerViewClass.swift
//  Fitness_App
//
//  Created by Phuong_Nguyen on 3/27/19.
//  Copyright © 2019 Phuong_Nguyen. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class PlayerViewClass: UIView {
    
    override static var layerClass: AnyClass {
        
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
}
