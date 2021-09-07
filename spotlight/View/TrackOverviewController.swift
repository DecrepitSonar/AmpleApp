////
////  TrackOverviewController.swift
////  spotlight
////
////  Created by Robert Aubow on 6/25/21.
////
//
//import Foundation
//import UIKit
//
//class CollectionCell: UITableViewCell {
//    static let reuseIdentifier: String = "cvCell"
//    
//    var albumId: String?
//    
//    var section: [TrackDetail]?
//    
//    
//     var collectionView: UICollectionView!
//     var dataSource: UICollectionViewDiffableDataSource<TrackDetail, TrackItem>?
//    
//    func initialize(section: [TrackDetail]) {
//        
////        navigationController?.navigationItem.backButtonTitle = ""
//        
//        self.section = section
//        
//        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: createCompositionalLayout())
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        collectionView.backgroundColor = .systemBackground
//        collectionView.contentInsetAdjustmentBehavior = .never
//        
//        // register items
//        
//        // Section Cells
//        collectionView.register(TrackDetailCell.self, forCellWithReuseIdentifier: TrackDetailCell.reuseableIdentifier)
////        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
//        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseableIdentifier)
//        collectionView.register(TrackRelatedArtistSEction.self, forCellWithReuseIdentifier: TrackRelatedArtistSEction.reuseableIdentifier)
//        
//        // Headers
////        collectionView.register(TrackImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackImageHeader.reuseableIdentifier)
////        collectionView.register(TrackOverviewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier)
//        
//        addSubview(collectionView)
//        createDataSource()
//        reloadData()
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("")
//    }
//    
//    func configure<T: DetailCell>(_ cellType: T.Type, with trackItem: TrackItem, indexPath: IndexPath) -> T{
//        print("Configureing cell")
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseableIdentifier, for: indexPath) as? T else {
//            fatalError("could not configure cell")
//        }
//
//        cell.configure(with: trackItem)
//        return cell
//
//    }
//    // Create Datasource
//    func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<TrackDetail, TrackItem> (collectionView: collectionView) {
//            collectionview, IndexPath, item in
//
//                switch self.section![IndexPath.section].type {
//                case "Albums":
//                    return self.configure(AlbumCollectionCell.self, with: item, indexPath: IndexPath)
//                case "Artists":
//                    return self.configure(TrackRelatedArtistSEction.self, with: item, indexPath: IndexPath)
//                case "Singles":
//                    return self.configure(AlbumCollectionCell.self, with: item, indexPath: IndexPath)
//                default:
//                    return self.configure(TrackDetailCell.self, with: item, indexPath: IndexPath)
//                }
//        }
//
////        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, IndexPath in
////            guard let imageHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackImageHeader.reuseableIdentifier, for: IndexPath) as? TrackImageHeader else {
////                return nil
////            }
////
////            guard let firstSEction = self?.dataSource?.itemIdentifier(for: IndexPath) else {return nil}
////
////            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstSEction) else {return nil}
////
////            if section.imageURL!.isEmpty {
////
////                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier, for: IndexPath) as? TrackOverviewSectionHeader else {return nil}
////
////                sectionHeader.tagline.text = section.tagline
////                sectionHeader.title.text = section.type
////
////                return sectionHeader
////            }
////
////            imageHeader.image.image = UIImage(named: section.imageURL!)
////            print(section.imageURL!)
////
////            imageHeader.tagline.text = section.title
////
////            return imageHeader
////        }
//    }
//
//    // initialize snapshot
//    func reloadData(){
//        var snapshot = NSDiffableDataSourceSnapshot<TrackDetail, TrackItem>()
//        guard let section = section else { return }
//        
//        snapshot.appendSections(section)
//        
//        for section in section {
//            snapshot.appendItems(section.items, toSection: section)
//        }
//
//        dataSource?.apply(snapshot)
//    }
//
//
//    // create compositional layout
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        let compositionalLayout = UICollectionViewCompositionalLayout {
//            index, layoutEnvironment in
//            
//            
//            let section = self.section![index]
//
//            switch section.type{
//            case "Albums":
//                return LayoutManager.createMediumImageSliderSection(using: section)
//            case "Artists":
//                return LayoutManager.createAviSliderSection(using: section)
//            case "Singles":
//                return LayoutManager.createMediumImageSliderSection(using: section)
//            default:
//                print("configureing header detail")
//                return self.headerDeatil(using: section)
//            }
//        }
//
//        return compositionalLayout
//    }
//    
//    func headerDeatil(using: TrackDetail) -> NSCollectionLayoutSection{
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//    
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        
//        let header = createAlbumHeader()
//        section.boundarySupplementaryItems = [header]
//        
//        return section
//    }
//    
//    func createAlbumHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
//        let layout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.47))
//        
//        let supplementoyItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layout, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        
//        return supplementoyItem
//    }
//}
//
//
//class TrackOverviewController: UIViewController {
//    var albumId: String?
//    
////    let header = HeaderDetail()
////    let footer = DetailFooterDetail()
//    
//    fileprivate var section: [TrackDetail]?
////
////    var currentAlbum: Album? {
////        didSet{
////            header.config(album: currentAlbum!)
////        }
////    }
//        
////    var Songs = [Song](){
////        didSet{
////            tableview.reloadData()
////        }
////    }
//    
//    var tableview = UITableView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.3)
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        section = NetworkManager.loadTrackDetail(filename: "AlbumDetail", id: "1")
//        
//        view.addSubview(tableview)
//        
//        tableview.delegate = self
//        tableview.dataSource = self
//        tableview.register(TrackStripCell.self, forCellReuseIdentifier: "track")
//        tableview.register(TrackImageHeader.self, forHeaderFooterViewReuseIdentifier: TrackImageHeader.reuseableIdentifier)
////        tableview.register(CollectionViewCell.self, forCellReuseIdentifier: CollectionViewCell.reuseIdentifier)
//        
////        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
////        tableview.register(DetailFooterDetail.self, forCellReuseIdentifier: "footer")
//
////        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
////        tableview.tableHeaderView?.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
////        tableview.backgroundColor = .systemBackground
////        tableview.tableHeaderView = header
//    }
////
////    func getAlbumDetail(albumId: String){
////        NetworkManager.getAlbum(id: albumId) { (result) in
////            switch(result){
////            case .success(let album):
////                self.currentAlbum = album
////                print(album)
////            case .failure(let err):
////                print(err)
////            }
////        }
////    }
////
////    func getTracks(albumId: String){
////        NetworkManager.getTracks(albumId: albumId) { (result) in
////            switch(result){
////            case .success(let tracks ):
////                self.Songs = tracks
////                print(tracks)
////            case .failure(let err):
////                print(err)
////            }
////        }
////    }
////    func getSingleTrack(trackId: String){
////        NetworkManager.getTrack(trackId: trackId) { (result) in
////            switch(result){
////            case .success(let song):
////                self.Songs.append(song)
////                print(song)
////            case .failure(let err):
////                print(err)
////            }
////        }
////    }
//        
//    override func viewDidLayoutSubviews() {
//        tableview.frame = view.bounds
////        moreMusicScrollContainer.contentSize = CGSize(width: 1600, height: 0)
////        relatedArtistSV.contentSize = CGSize(width: 950, height: 0)
//    }
//    
//}
//
//extension TrackOverviewController: UITableViewDelegate, UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.section![section].items.count
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return section!.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        
//        switch indexPath.section {
//        case 0:
//            let cell = tableview.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStripCell
//            
//            print("Track", section![indexPath.section].items[indexPath.row].artist, section![indexPath.section].items[indexPath.row].title, section![indexPath.section].items[indexPath.row].imageURL)
//            
//            cell?.configure(with: section![indexPath.section].items[indexPath.row].artist, trackname: section![indexPath.section].items[indexPath.row].title, img: section![indexPath.section].items[indexPath.row].imageURL)
//            
//            return cell!
//        case 1:
//            let cell = tableview.dequeueReusableCell(withIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell
////            cell?.configure(with: section![indexPath.section].items[indexPath.row])
//            cell?.initialize(section: section!)
//            
//            return cell!
//            
//        default:
//            let cell = tableview.dequeueReusableCell(withIdentifier: "track", for: indexPath) as? TrackStripCell
//            
//            print("Track", section![indexPath.section].items[indexPath.row].artist, section![indexPath.section].items[indexPath.row].title, section![indexPath.section].items[indexPath.row].imageURL)
//            
//            cell?.configure(with: section![indexPath.section].items[indexPath.row].artist, trackname: section![indexPath.section].items[indexPath.row].title, img: section![indexPath.section].items[indexPath.row].imageURL)
//            
//            return cell!
//        }
//        
//    }
//}
