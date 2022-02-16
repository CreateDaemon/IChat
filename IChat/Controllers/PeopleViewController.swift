//
//  PeopleViewController.swift
//  IChat
//
//  Created by Дмитрий Межевич on 9.02.22.
//

import UIKit

class PeopleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        setupSearchController()
    }
}

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension PeopleViewController {
    
    private func setupSearchController() {
        let searcheController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searcheController
        navigationItem.hidesSearchBarWhenScrolling = false
        searcheController.hidesNavigationBarDuringPresentation = false
        searcheController.obscuresBackgroundDuringPresentation = false
        searcheController.searchBar.delegate = self
    }
}
