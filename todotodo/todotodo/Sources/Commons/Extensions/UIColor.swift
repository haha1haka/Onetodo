//
//  UIColor.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/22.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        UIColor(red: CGFloat.random(in: 0...255)/255,
                green: CGFloat.random(in: 0...255)/255,
                blue: CGFloat.random(in: 0...255)/255,
                alpha: 1.0)
    }
}
