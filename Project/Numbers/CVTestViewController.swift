//
//  CVTestViewController.swift
//  Numbers
//
//  Created by Michael Filippov on 28/10/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import UIKit
import Foundation

class CVTestViewController : UIViewController {
    
    
    @IBOutlet weak var src: UIImageView!
    @IBOutlet weak var output: UIImageView!
    @IBOutlet weak var timing: UILabel!
    
    var imageCtr = 1;
    let processing = DMImageProcessing()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func onTouch(_ sender: AnyObject) {
        imageCtr = imageCtr + 1;
        showImage(n: imageCtr)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        showImage(n: imageCtr)
        
        
        
    }
    
    func showImage(n : Int) {
        let srcImage = UIImage(named: "car\(n%11)")
        src.image = srcImage
        let start = CFAbsoluteTimeGetCurrent()
        let out : UIImage? = processing.findPlate(srcImage, withResourcePath: Bundle.main.resourcePath)
        let taken = (CFAbsoluteTimeGetCurrent() - start)
        timing.text = "\(taken * 1000) ms"
        output.image = out
    }
    
}
