//
//  UIImage+Additions.swift
//  SearchAndStoreDemo
//
//  Created by Avinash on 28/07/18.
//  Copyright © 2018 Avinash. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func resizeImage(image: UIImage, size: CGSize) -> UIImage? {
        
       let rr = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width - 20, height: size.height)
        
       UIGraphicsBeginImageContextWithOptions(rr.size, false, 0)
       image.draw(in: rr)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
        
        return newImage
    }
}
