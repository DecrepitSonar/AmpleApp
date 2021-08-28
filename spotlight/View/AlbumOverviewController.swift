//
//  AlbumOverviewController.swift
//  spotlight
//
//  Created by Robert Aubow on 8/24/21.
//

import UIKit

class AlbumOverviewController: UIViewController {

    let section = NetworkManager.loadTrackDetail(filename: "AlbumDetail")
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<TrackDetail, TrackItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        
        // register items
        
        // Section Cells
        collectionView.register(TrackDetailCell.self, forCellWithReuseIdentifier: TrackDetailCell.reuseableIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseableIdentifier)
        collectionView.register(TrackRelatedArtistSEction.self, forCellWithReuseIdentifier: TrackRelatedArtistSEction.reuseableIdentifier)
        
        // Headers
        collectionView.register(TrackImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackImageHeader.reuseableIdentifier)
        collectionView.register(TrackOverviewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier)
        
        view.addSubview(collectionView)
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
                
                switch self.section[IndexPath.section].type {
                case "Albums":
                    return self.configure(AlbumCollectionCell.self, with: item, indexPath: IndexPath)
                case "Artists":
                    return self.configure(TrackRelatedArtistSEction.self, with: item, indexPath: IndexPath)
                default:
                    return self.configure(TrackDetailCell.self, with: item, indexPath: IndexPath)
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
            let section = self.section[index]
            
            switch section.type{
            case "Albums":
                return LayoutManager.createMediumImageSliderSection(using: section)
            case "Artists":
                return LayoutManager.createAviSliderSection(using: section)
            default:
                print("configureing header detail")
                return self.headerDeatil(using: section)
            }
        }
        
        return compositionalLayout
    }
    
    func headerDeatil(using: TrackDetail) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        let header = createAlbumHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createAlbumHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.47))
        
        let supplementoyItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layout, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return supplementoyItem
    }
}
