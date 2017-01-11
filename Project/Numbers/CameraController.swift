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
    var cameraViewPlates: Array = Array<UIView>()
    
    let camera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetiFrame960x540, cameraPosition: .back)!
    let opencv = OpenCVFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.camera.outputImageOrientation = .portrait
        self.camera.addTarget(self.opencv)
        self.opencv.addTarget(self.cameraView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribe()
        self.camera.startCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribe()
        self.camera.stopCapture()
        runSynchronouslyOnVideoProcessingQueue {
            glFinish()
        }
    }
}

extension CameraController {
    
    // MARK: Observers

    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.imageProcessingDidFoundPlates(notification:)), name: .DMImageProcessingDidFoundPlates, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.imageProcessingDidLoosePlates(notification:)), name: .DMImageProcessingDidLoosePlates, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func imageProcessingDidFoundPlates(notification: Notification) {
        guard let values = notification.userInfo?[DMImageProcessingInfoFramesKey] as? Array<NSValue> else { return }
        
        if values.count > self.cameraViewPlates.count {
            for _ in 0..<(values.count - self.cameraViewPlates.count) {
                let view = UIView(frame: .zero)
                view.backgroundColor = .red
                self.cameraViewPlates.append(view)
            }
        } else if values.count < self.cameraViewPlates.count {
            for i in values.count..<self.cameraViewPlates.count {
                self.cameraViewPlates[i].removeFromSuperview()
            }
        }
        
        for i in 0..<values.count {
            let frame = values[i].cgRectValue
            
            let scaleX = self.cameraView.bounds.size.width/540.0
            let scaleY = self.cameraView.bounds.size.height/960.0
            let scaled = CGRect(x: frame.origin.x * scaleX, y: frame.origin.y * scaleY, width: frame.size.width * scaleX, height: frame.size.height * scaleY)
            
            if let _ = self.cameraViewPlates[i].superview {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.cameraViewPlates[i].frame = scaled
                })
            } else {
                self.cameraViewPlates[i].frame = scaled
                self.cameraView.addSubview(self.cameraViewPlates[i])
            }
        }
    }
    
    func imageProcessingDidLoosePlates(notification: Notification) {
        for view in self.cameraViewPlates {
            view.removeFromSuperview()
        }
    }
}
