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
class SearchViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    
//    let dataManager = DataMananager()
    
    let Genres = ["R&B", "Hip-Hop", "Rap", "Soul", "Jazz", "Pop", "Alternative", "Afro", "Indie", "Rock", "Metal", "Instrumentals"]
//    var trackHistory = [NSManagedObject](){
//        didSet{
//            DispatchQueue.main.async {
//                self.tableview.reloadData()
//            }
//        }
//    }
    
    override func loadView() {
        super.loadView()
        
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Search"
        
        let searchController = UISearchController(searchResultsController: SearchResultViewController())
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        navigationItem.searchController = searchController
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        guard let items = dataManager.getAllSearchHistoryItems() else {
//            return
//        }

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

//        view.addSubview(collectionView)
        
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
//        collectionView.register(GenreColletionCell.self, forCellReuseIdentifier: GenreColletionCell.reuseableIdentifier)
//        collectionView.register(TrackStrip.self, forCellReuseIdentifier: TrackStrip.reuseIdentifier)
        
//        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupView()
        
    }
    
    func setupView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: ( view.bounds.width / 2 ) - 30, height: 100)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseableidentifier)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(collectionView)
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
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseableidentifier, for: indexPath) as! GenreCell
        cell.label.text = Genres[indexPath.row]
//        cell.image.image = UIImage(named: Genres[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return Genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

}


class GenreCell: UICollectionViewCell {
    
    static let reuseableidentifier: String = "collectioncell"
    
    let image: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .red
        view.image = UIImage(named: "pastel-gradient-art-wtlblhphaj0kja3d")
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
    
    
    let contentImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.heightAnchor.constraint(equalToConstant:  40).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        addSubview(image)
        addSubview(containerOverlay)
        
        containerOverlay.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            image.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            containerOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerOverlay.topAnchor.constraint(equalTo: topAnchor),
            containerOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),

            label.centerXAnchor.constraint(equalTo: containerOverlay.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: containerOverlay.centerYAnchor)
        ])
        
//        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}
