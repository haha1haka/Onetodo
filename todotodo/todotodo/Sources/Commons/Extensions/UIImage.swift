//
//  UIImage.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/29.
//

import UIKit

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
