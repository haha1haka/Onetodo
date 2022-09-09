//
//  DetailViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit

class DetailViewController: BaseViewController {

    let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }
    override func configure() {
        detailView.backgroundColor = .systemGray
        navigationItem.largeTitleDisplayMode = .never
    }
}



extension DetailViewController {
    
}
