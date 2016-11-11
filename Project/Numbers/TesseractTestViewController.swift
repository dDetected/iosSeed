//
//  TesseractTestViewController.swift
//  Numbers
//
//  Created by Michael Filippov on 02/11/2016.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import Foundation
import UIKit
import TesseractOCR

class TesseractTestViewController : UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var recongnizedText: UILabel!
    @IBOutlet weak var timing: UILabel!
 
    var imageCtr = 0;
    let processing = DMImageProcessing()
    
 
    @IBAction func nextImage(_ sender: Any) {
        imageCtr = imageCtr + 1;
        showImage(n: imageCtr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showImage(n: imageCtr)
    }
    
    func showImage(n : Int) {
        let srcImage = UIImage(named: "PLATE\(n%5)")
        image.image = srcImage
        
        let start = CFAbsoluteTimeGetCurrent()
//        let out : UIImage? = processing.findPlate(srcImage, withHaar: Bundle.main.path(forResource: "haar_plate", ofType: "xml"))
//        
//        if let tesseract = G8Tesseract(language: "eng"){
////            tesseract.engineMode = .tesseractCubeCombined
////            tesseract.pageSegmentationMode = .singleBlock
////            tesseract.maximumRecognitionTime = 60.0
//            tesseract.charWhitelist="1234567890ETUOPAHKXCBM"
//            tesseract.image = srcImage?.g8_blackAndWhite()
//            tesseract.recognize()
//    
//            processing.extractText(srcImage)
//            
//            
//            if let text = tesseract.recognizedText{
//                recongnizedText.text = text
//            }else{
//                recongnizedText.text = "no text :("
//            }
//        }
        
        if let text = processing.extractText(srcImage){
            recongnizedText.text = text
        }
        
        let taken = (CFAbsoluteTimeGetCurrent() - start)
        timing.text = "\(taken) ms"
        
    }
    
}
