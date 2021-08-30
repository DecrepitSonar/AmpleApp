//
//  AlbumOverviewController.swift
//  spotlight
//
//  Created by Robert Aubow on 8/24/21.
//

import UIKit

class AlbumOverviewController: UIViewController {

    fileprivate let section = NetworkManager.loadTrackDetail(filename: "AlbumDetail", id: "1")
    fileprivate var collectionView: UICollectionView!
    fileprivate var dataSource: UICollectionViewDiffableDataSource<TrackDetail, TrackItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
//
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        collectionView.backgroundColor = .systemBackground
//        collectionView.contentInsetAdjustmentBehavior = .never
        
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
//        createDataSource()
//        reloadData()
        
    }
//
//    fileprivate func configure<T: DetailCell>(_ cellType: T.Type, with trackItem: TrackItem, indexPath: IndexPath) -> T{
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
//    fileprivate func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<TrackDetail, TrackItem> (collectionView: collectionView) {
//            collectionview, IndexPath, item in
//
//                switch self.section[IndexPath.section].type {
//                case "Albums":
//                    return self.configure(AlbumCollectionCell.self, with: item, indexPath: IndexPath)
//                case "Artists":
//                    return self.configure(TrackRelatedArtistSEction.self, with: item, indexPath: IndexPath)
//                default:
//                    return self.configure(TrackDetailCell.self, with: item, indexPath: IndexPath)
//                }
//        }
//
//        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, IndexPath in
//            guard let imageHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackImageHeader.reuseableIdentifier, for: IndexPath) as? TrackImageHeader else {
//                return nil
//            }
//
//            guard let firstSEction = self?.dataSource?.itemIdentifier(for: IndexPath) else {return nil}
//
//            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstSEction) else {return nil}
//
//            if section.imageURL!.isEmpty {
//
//                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier, for: IndexPath) as? TrackOverviewSectionHeader else {return nil}
//
//                sectionHeader.tagline.text = section.tagline
//                sectionHeader.title.text = section.type
//
//                return sectionHeader
//            }
//
//            imageHeader.image.image = UIImage(named: section.imageURL!)
//            print(section.imageURL!)
//
//            imageHeader.tagline.text = section.title
//
//            return imageHeader
//        }
//    }
//
//    // initialize snapshot
//    fileprivate func reloadData(){
//        var snapshot = NSDiffableDataSourceSnapshot<TrackDetail, TrackItem>()
//        snapshot.appendSections(section)
//
//        for section in section {
//            snapshot.appendItems(section.items, toSection: section)
//        }
//
//        dataSource?.apply(snapshot)
//    }
//
//    // create compositional layout
//    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
//        let compositionalLayout = UICollectionViewCompositionalLayout {
//            index, layoutEnvironment in
//            let section = self.section[index]
//
//            switch section.type{
//            case "Albums":
//                return LayoutManager.createMediumImageSliderSection(using: section)
//            case "Artists":
//                return LayoutManager.createAviSliderSection(using: section)
//            default:
//                print("configureing header detail")
//                return LayoutManager.createTrackDetailSection(using: section)
//            }
//        }
//
//        return compositionalLayout
//    }
//
//
//
}
