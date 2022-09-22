//
//  SearchViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/23.
//

import UIKit

class SearchViewController: BaseViewController {

    
    
    
    
    override func configure() {
        setupSearchController()
        configureUINavigationBar()
    }
    
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureUINavigationBar() {
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = "todotodo"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

}
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("검색됌")
    }
}
