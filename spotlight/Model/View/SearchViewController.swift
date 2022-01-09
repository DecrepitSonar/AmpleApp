    //
//  SearchViewController.swift
//  spotlight
//
//  Created by bajo on 2021-12-11.
//

import UIKit
import AVFoundation

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    var tableview: UITableView!
    
    let Genres = ["R&B", "Hip Hop", "Rap", "Soul"]
    var trackHistory = [LibItem](){
        didSet{
            tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.prefersLargeTitles = true
        title = "Search"
        
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.showsSearchResultsController = true
        
        NetworkManager.getSearchHistory { result in
            switch(result){
            case .success(let data):
                self.trackHistory = data
                print(data)
            case .failure(let err):
                print(err)
            }
        }
        
        tableview = UITableView()
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.frame

        view.addSubview(tableview)
        
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        tableview.register(GenreColletionCell.self, forCellReuseIdentifier: GenreColletionCell.reuseableIdentifier)
        tableview.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
//
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        let vc = searchController.searchResultsController as? SearchResultViewController
        
//        vc?.view.backgroundColor = .systemRed
        if (text.isEmpty){
            return
        }
        NetworkManager.getSearchResult(query: text){ result in
//            switch(result) {
//            case .success(let data):
//                vc?.data = data
//            }
//            case .failure(let err):
//                vc.data = []
//            }
        }
    
        print(text)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.section){
        case 0:
            return 150
        default:
            return 80
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return "Genres"
        
        case 1:
            return "Recent Searches"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return 1
        default:
            if( trackHistory.count > 1){
                return trackHistory.count
            }
            
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch(indexPath.section){
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: GenreColletionCell.reuseableIdentifier, for: indexPath) as! GenreColletionCell
            cell.configure(genres: Genres)
            return cell
        default:
            if(trackHistory.count > 0 && trackHistory != nil){
                let cell = tableview.dequeueReusableCell(withIdentifier: TrackStrip.reuseIdentifier, for: indexPath) as! TrackStrip
                cell.artist.text = trackHistory[indexPath.row].name
                cell.name.text = trackHistory[indexPath.row].title
                cell.image.setUpImage(url: trackHistory[indexPath.row].imageURL)
                
                return cell
            }
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.textLabel?.text = "No Recent Searchs"
            cell.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
            return cell
        }
    }
}

class GenreColletionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    static var reuseableIdentifier: String = "genre cell"
    
    var data = [String]()
    
    var collectionview: UICollectionView! = nil

    func configure(genres: [String]){
        
        data = genres
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseableidentifier)
        collectionview.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionview.showsHorizontalScrollIndicator = false
        
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseableidentifier, for: indexPath) as! GenreCell
        cell.label.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}

class GenreCell: UICollectionViewCell {
    
    static let reuseableidentifier: String = "collectioncell"
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(container)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
