//
//  DetailViewController.swift
//  spotlight
//
//  Created by Bajo on 2021-09-06.
//

import UIKit

class DetailViewController: UITableViewController {
    let section = NetworkManager.loadTrackDetail(filename: "AlbumDetail", id: "1")
    
    // get sections data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        // register cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: TableHeader.reuseidentifier)
        tableView.register(TrackDetailStrip.self, forCellReuseIdentifier: TrackDetailStrip.reuseidentifier)
        tableView.register(MediumImageCollection.self, forCellReuseIdentifier: MediumImageCollection.reuseidentifier)
        
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
//    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffsetY = ab/s(tableView.contentOffset.y)
//        print(contentOffsetY)
        
        
    }
    
    // override section count -> Int
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.section[section].items.count
        default:
            return 1
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.reuseidentifier) as? TableHeader else {
//            fatalError("")
//        }
//        view.configure()
//        return view
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


    // override tableview for section -> TableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        
        switch indexPath.section {
        case 0 :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackDetailStrip.reuseidentifier, for: indexPath) as? TrackDetailStrip else {
                fatalError("")
            }
            
            cell.config(item: section[indexPath.section].items[indexPath.row])
        
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MediumImageCollection.reuseidentifier, for: indexPath) as? MediumImageCollection else {
                fatalError("")
            }

            cell.configure(items: section[indexPath.section].items)
            return cell
        }
        
    }

}

class TableHeader: UITableViewHeaderFooterView{
    static let reuseidentifier: String = "header"
    
    let view: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func configure(){
        
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
}


class CustomCollections: UITableViewCell {
    static let reuseidentifier: String = "collectionCell"
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<TrackDetail, TrackItem>? = nil
    
    var section: [TrackDetail]!
    
    func config(section: [TrackDetail]){
        
        self.section = section
        
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        // register items
        
        // Section Cells
        collectionView.register(TrackDetailCell.self, forCellWithReuseIdentifier: TrackDetailCell.reuseableIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseableIdentifier)
        collectionView.register(TrackRelatedArtistSEction.self, forCellWithReuseIdentifier: TrackRelatedArtistSEction.reuseableIdentifier)
        
        // Headers
        collectionView.register(TrackImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackImageHeader.reuseableIdentifier)
        collectionView.register(TrackOverviewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier)
        
        addSubview(collectionView)
        createDataSource()
        reloadData()
            
    }
    
    func configure<T: DetailCell>(_ cellType: T.Type, with trackItem: TrackItem, indexPath: IndexPath) -> T{
        print("Configureing cell")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseableIdentifier, for: indexPath) as? T else {
            fatalError("could not configure cell")
        }

        cell.configure(with: trackItem)
        return cell

    }
    
    // Create Datasource
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TrackDetail, TrackItem> (collectionView: collectionView) {
            collectionview, IndexPath, item in
            
            let section = self.section![IndexPath.section]
            
                switch self.section![IndexPath.section].type {
                case "Artists":
                    return self.configure(TrackRelatedArtistSEction.self, with: item, indexPath: IndexPath)
                default:
                    return self.configure(AlbumCollectionCell.self, with: item, indexPath: IndexPath)
                }
        }

        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, IndexPath in
            guard let imageHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackImageHeader.reuseableIdentifier, for: IndexPath) as? TrackImageHeader else {
                return nil
            }

            guard let firstSEction = self?.dataSource?.itemIdentifier(for: IndexPath) else {return nil}

            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstSEction) else {return nil}

            if section.imageURL!.isEmpty {

                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier, for: IndexPath) as? TrackOverviewSectionHeader else {return nil}

                sectionHeader.tagline.text = section.tagline
                sectionHeader.title.text = section.type

                return sectionHeader
            }

            imageHeader.image.image = UIImage(named: section.imageURL!)
            print(section.imageURL!)

            imageHeader.tagline.text = section.title

            return imageHeader
        }
    }

    // initialize snapshot
    func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<TrackDetail, TrackItem>()
        guard let section = section else { return }
        
        snapshot.appendSections(section)
        
        for section in section {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }


    // create compositional layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout {
            index, layoutEnvironment in
            
            let section = self.section![index]

            switch section.type{
            case "Artists":
                return LayoutManager.createAviSliderSection(using: section)
            default:
    
                return LayoutManager.createMediumImageSliderSection(using: section)
            }
        }

        return compositionalLayout
    }

}
class MediumImageCollection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    static var reuseidentifier: String = "imageItems"
    
    var collectionview = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var items: [TrackItem]!
    
    func configure(items: [TrackItem]){
        self.items = items
        collectionview.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseableIdentifier)
        collectionview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(collectionview)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: AlbumCollectionCell.reuseableIdentifier, for: indexPath) as? AlbumCollectionCell else {fatalError("")}
        
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    
}
class collection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    static let reuseidentifier: String = "collectionCell"
    
    var collectionView: UICollectionView!
    
    var section: TrackDetail!
    
    func config(section: TrackDetail){
        
        self.section = section
        
        collectionView = UICollectionView(frame: contentView.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // register items
        
        // Section Cells
      
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseableIdentifier)
        collectionView.register(TrackRelatedArtistSEction.self, forCellWithReuseIdentifier: TrackRelatedArtistSEction.reuseableIdentifier)
        
        // Headers

        collectionView.register(TrackOverviewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier)
        
        addSubview(collectionView)
            
    }

    func createCompositionalLayout() -> UICollectionViewLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { index, layoutEnvironment in
            
            let section = self.section

            switch section!.type{
            case "Tracks":
                return LayoutManager.createTableLayout(using: section!)
            case "Artists":
                return LayoutManager.createAviSliderSection(using: section!)
            default:
                return LayoutManager.createMediumImageSliderSection(using: section!)
            }
        }

        return compositionalLayout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionCell.reuseableIdentifier, for: indexPath) as? AlbumCollectionCell else {
            fatalError("")
        }
        print("item: ", section.items[indexPath.row])
        cell.configure(with: section.items[indexPath.row])
        return cell
    }
}
