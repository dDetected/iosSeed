//
//  Extension.swift
//  Numbers
//
//  Created by Константин on 28.10.16.
//  Copyright © 2016 Anton Spivak. All rights reserved.
//

import Foundation
import CoreGraphics


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}




extension UIImage {
    
    func resized(w: CGFloat) -> UIImage? {
        
        let scale = w / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: w, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: w, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    var pngData: Data? { return UIImagePNGRepresentation(self) }
    
    func jpegData(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}




extension UIButton {

    func asCircle() {
        layer.cornerRadius = frame.size.width/2
    }
}



func delay(seconds: Double, closure: @escaping () -> Void) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        closure()
    }
}
