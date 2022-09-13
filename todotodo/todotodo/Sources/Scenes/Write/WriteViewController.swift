//
//  WriteViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit

class WriteViewController: BaseViewController {
    
    let writeView = WriteView()
    
    override func loadView() {
        self.view = writeView
    }
    
    override func configure() {
        writeView.backgroundColor = .white
    }
}



extension WriteViewController {
    
}
