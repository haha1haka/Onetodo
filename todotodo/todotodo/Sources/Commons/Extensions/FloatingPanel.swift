//
//  FloatingPanel.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/19.
//

import UIKit
import FloatingPanel

extension FloatingPanelController {
    func changePanelStyle() {
            let appearance = SurfaceAppearance()
            let shadow = SurfaceAppearance.Shadow()
            shadow.color = UIColor.black
            shadow.offset = CGSize(width: 0, height: -4.0)
            shadow.opacity = 0.15
            shadow.radius = 2
            appearance.shadows = [shadow]
            appearance.cornerRadius = 15.0
            appearance.backgroundColor = .red
            appearance.borderColor = .clear
            appearance.borderWidth = 0
            surfaceView.appearance = appearance
            surfaceView.backgroundColor = .clear
        }
}
