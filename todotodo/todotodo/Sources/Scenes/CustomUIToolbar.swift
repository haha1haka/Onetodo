//
//  CustomUIToolbar.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/15.
//

import UIKit

class CustomToolbar: UIToolbar {

override func sizeThatFits(_ size: CGSize) -> CGSize {

    var newSize: CGSize = super.sizeThatFits(size)
    newSize.height = 80  // there to set your toolbar height

    return newSize
    }

}

