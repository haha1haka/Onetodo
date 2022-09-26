//
//  String.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/26.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
}
