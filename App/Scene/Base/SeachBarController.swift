//
//  SeachBarController.swift
//  GithubRepoSearch
//
//  Created by Rasel on 2021/08/01.
//

import UIKit

class SeachBarController: UISearchController {
    
    // MARK: - Properties
    var updateSearchResults: CallBackWithValue<String, Void>?
    
    convenience init() {
        self.init(searchResultsController: nil)
        configureSearchController()
    }
    
    private func configureSearchController() {
        searchResultsUpdater = self
        obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true 
        searchBar.placeholder = Const.searchPlaceHolder
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
    }
    
    func update(_ next: @escaping CallBackWithValue<String, Void>) -> Self {
        updateSearchResults = next
        return self
    }
}

// MARK: - UISearchResultsUpdating
extension SeachBarController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        updateSearchResults?(searchString)
    }
}

// MARK: - UISearchBarDelegate
extension SeachBarController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
