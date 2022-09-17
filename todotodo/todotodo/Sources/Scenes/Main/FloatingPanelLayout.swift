//
//  FloatingPanelLayout.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/15.
//

import UIKit
import FloatingPanel

class MyFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanelState = .tip
        
    

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { // 가능한 floating panel: 현재 full, half만 가능하게 설정
//        return [
//            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
//            .half: FloatingPanelLayoutAnchor(absoluteInset: 292, edge: .bottom, referenceGuide: .safeArea),
//            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
//        ]
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 20.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 262.0, edge: .bottom, referenceGuide: .safeArea),
             /* Visible + ToolView */
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0 + 44, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}








class MyFloatingPanelLayout2: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanelState = .full
        
    

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] { // 가능한 floating panel: 현재 full, half만 가능하게 설정
//        return [
//            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
//            .half: FloatingPanelLayoutAnchor(absoluteInset: 292, edge: .bottom, referenceGuide: .safeArea),
//            .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
//        ]
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 56.0, edge: .top, referenceGuide: .safeArea),
            //.half: FloatingPanelLayoutAnchor(absoluteInset: 262.0, edge: .bottom, referenceGuide: .safeArea),
             /* Visible + ToolView */
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 0.0 + 0.0, edge: .bottom, referenceGuide: .superview),
        ]
    }
}
