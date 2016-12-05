//
//  VideoTestViewController.swift
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import Foundation
import AVFoundation

class VideoTestViewController : UIViewController {
    
    @IBOutlet weak var outputview: UIImageView!

    var videoProcessing : DMVideoProcessing?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let videoURL = Bundle.main.url(forResource: "vidos", withExtension: "MOV"){
            
            let player = AVPlayer(url: videoURL)
            player.actionAtItemEnd = .none
            
            
            let layer = AVPlayerLayer(player: player);
            
            
            layer.frame = CGRect(x: outputview.frame.origin.x, y: outputview.frame.origin.y, width: outputview.frame.width, height: outputview.frame.height)
            
            outputview.layer.addSublayer(layer)
            
            player.play()
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     //   videoProcessing = DMVideoProcessing(outputImageView: outputview)
        
       // videoProcessing?.start()
    }
    
}
