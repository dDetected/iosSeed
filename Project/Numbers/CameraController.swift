//
//  CameraController.swift
//  Numbers
//
//  Created by Michael Filippov on 21/12/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class CameraController : UIViewController {
    @IBOutlet weak var cameraView: GPUImageView!
    
    var camera : GPUImageVideoCamera!
    let opencvFilter = OpenCVFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.camera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetiFrame960x540, cameraPosition: .back)!
        self.camera.outputImageOrientation = .portrait
        self.camera.addTarget(opencvFilter)
        
        self.opencvFilter.addTarget(cameraView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        camera.startCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        camera.stopCapture()
    }
    
}
