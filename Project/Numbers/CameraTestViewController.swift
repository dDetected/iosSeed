//
//  CameraTestViewController.swift
//  Numbers
//
//  Created by Michael Filippov on 17/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import Foundation
import AVFoundation


class CameraTestViewController : UIViewController {
    
    var camera: DMCameraProcessing?
    
    @IBOutlet weak var outputView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        camera = DMCameraProcessing(outputImageView: outputView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkPermission() {
            self.camera?.startCapture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera?.stopCapture()
    }
    
    func checkPermission(withBlock block: @escaping () -> ()) {
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if granted {
                    block()
                }
            })
        } else if status == .authorized {
            block()
        }
    }
    
}
