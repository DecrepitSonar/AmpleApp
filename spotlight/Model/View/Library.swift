//
//  ProfileViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import UIKit

class Library: UIViewController, UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labels: [String] = ["Saved","History","Artists"]
        
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(loadSettings))
        navigationItem.rightBarButtonItem = button
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Library"
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        view.addSubview(navigation)
        navigation.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        navigation.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        navigation.topAnchor.constraint(equalTo: view.topAnchor, constant: 135).isActive = true
        
        navigation.addSubview(saved)
        navigation.addSubview(History)
        navigation.addSubview(Artists)
//
        view.addSubview(scrollContainer)
//
//
//        NSLayoutConstraint.activate([
//            saved.leadingAnchor.constraint(equalTo: navigation.leadingAnchor, constant: 20),
//            saved.centerYAnchor.constraint(equalTo: navigation.centerYAnchor),
//
//            History.leadingAnchor.constraint(equalTo: saved.trailingAnchor, constant: 20),
//            History.centerYAnchor.constraint(equalTo: navigation.centerYAnchor),
//
//            Artists.leadingAnchor.constraint(equalTo: History.trailingAnchor, constant: 20),
//            Artists.centerYAnchor.constraint(equalTo: navigation.centerYAnchor),
//
//            scrollContainer.topAnchor.constraint(equalTo: navigation.bottomAnchor),
//            scrollContainer.heightAnchor.constraint(equalToConstant: 600),
//            scrollContainer.widthAnchor.constraint(equalToConstant: view.bounds.width)
//
//
//        ])
//
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Library"
        navigationItem.searchController = searchController
    
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let vc = searchController.searchResultsController as? SearchResultViewController
        vc?.view.backgroundColor = .systemRed
        print(text)
    }
    
    let navigation: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let saved: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("Saved", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let History: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("History", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
  
    let Artists: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("Artists", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let scrollContainer: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .red
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    func createButton(title: String) -> UIButton{
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle(title, for: .normal)
        return btn
    }
    
    @objc func loadSettings(){
        let view =  SettingsViewController()
        
        navigationController?.pushViewController(view, animated: true)
    }

}
