//
//  File.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/29.
//

import UIKit


enum ColorType {
    static var backgroundColorSet: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.black
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }
    
    static var lableColorSet: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            }
        } else {
            return UIColor.white
        }
    }
    static var writeViewColorSet: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.black
                } else {
                    return UIColor.myLightGray
                }
            }
        } else {
            return UIColor.white
        }
    }
    static var textViewColorSet: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.myDarkGray
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }
    
    static var completeColorSet: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(hex: "#1C1C1E")
                } else {
                    return UIColor.myLightGray
                }
            }
        } else {
            return UIColor.white
        }
    }
    static var completeStringSet: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor(hex: "#6e6e6e")
                } else {
                    return UIColor(hex: "#d2d2d2")
                }
            }
        } else {
            return UIColor.white
        }
    }
}
