//
//  VideoTestViewController.swift
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import Foundation
import AVFoundation
import GPUImage

class VideoTestViewController : UIViewController {
    
    @IBOutlet weak var gpuView: GPUImageView!
    

    var videoProcessing : DMVideoProcessing?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.videoProcessing = DMVideoProcessing(outputImageView: gpuView);
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        videoProcessing?.start()
    }
    
}
