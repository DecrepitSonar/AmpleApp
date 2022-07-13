    //
//  SearchViewController.swift
//  spotlight
//
//  Created by bajo on 2021-12-11.
//

import UIKit
import AVFoundation
import CoreData

public class DynamicTableView: UITableView {
    
    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if( bounds.size != intrinsicContentSize ){
            invalidateIntrinsicContentSize()
        }
    }
}
class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {

    var tableview: UITableView!
    let dataManager = DataMananager()
    
    let Genres = ["R&B", "Hip-Hop", "Rap", "Soul", "Jazz", "Pop"]
    var trackHistory = [NSManagedObject](){
        didSet{
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Search"
        
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        tableview = UITableView(frame: .zero, style: .grouped)
//        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.frame
        tableview.separatorColor = UIColor.clear
        tableview.rowHeight = UITableView.automaticDimension
        
        guard let items = dataManager.getAllSearchHistoryItems() else {
            return
        }

//        NetworkManager.Get(url: "search/history?userId=\(user)", completion: { (data: [LibItem]?, error: NetworkError) in
//
//            switch(error){
//            case .notfound:
//                print("Url not found")
//
//            case .servererr:
//                print("server error")
//
//            case .success:
//                self.trackHistory = data!
//            }
//        })

        view.addSubview(tableview)
        
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        tableview.register(GenreColletionCell.self, forCellReuseIdentifier: GenreColletionCell.reuseableIdentifier)
        tableview.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {
            return
        }

        let vc = searchController.searchResultsController as? SearchResultViewController
        
        if (text.isEmpty){
            return
        }
        
        NetworkManager.getSearchResult(query: text){ result in
            switch(result) {
            case .success(let data):
                DispatchQueue.main.async {
                    vc?.searchQuery = text
                    vc?.data = data
                }

            case .failure(let err):
                vc?.data = []
            }
            
        }
    
        print(text)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( indexPath.row == 0 && indexPath.section == 0 ){
            return 100
        }
        return 65
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if( section == 0){
            return "Search Genres"
        }
        return "Recent Searches"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( section == 0 ){
            return 1
        }
        
        if(trackHistory.count > 0){
            return trackHistory.count
        }
        else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if( indexPath.section == 0 ){
            let cell = tableview.dequeueReusableCell(withIdentifier: GenreColletionCell.reuseableIdentifier) as! GenreColletionCell
            cell.configure(genres: Genres)
            cell.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
            return cell
        }
        
//        if(trackHistory.count > 0 ){
//
//            switch(trackHistory[indexPath.row].value(forKey: "type") as! String){
//            case "Artist":
//                return configureTableCell(tableview: tableView, AviTableCell.self, with: trackHistory[indexPath.row], indexPath: indexPath)
//
//            default:
//                return configureTableCell(tableview: tableView, TrackStrip.self, with: trackHistory[indexPath.row], indexPath: indexPath)
//            }
//        }
        else{
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
        cell.image.image = UIImage(named: data[indexPath.row])
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
    
    let image: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let containerOverlay: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view .layer.cornerRadius = 5
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        view.layer.zPosition = 3
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        addSubview(containerOverlay)
        
        containerOverlay.addSubview(label)
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerOverlay.topAnchor.constraint(equalTo: topAnchor),
            containerOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.centerXAnchor.constraint(equalTo: containerOverlay.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerOverlay.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
