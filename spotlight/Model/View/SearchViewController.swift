//
//  SearchViewController.swift
//  spotlight
//
//  Created by bajo on 2021-12-11.
//

import UIKit

class SearchViewController: UIViewController {

    var datasource: UITableViewDiffableDataSource<SearchObj, SearchItem>!
    var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        title = "Search"
        
//        let searchController = UISearchController(searchResultsController: SearchResultViewController())
//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
        
    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//
//        let vc = searchController.searchResultsController as? SearchResultViewController
//        vc?.view.backgroundColor = .systemRed
//        print(text)
//    }
    
}
