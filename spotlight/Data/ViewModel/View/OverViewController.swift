//
//  OverViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 8/22/21.
//

import UIKit

class OverViewController: UIViewController, UICollectionViewDelegate {
    var albumId: String?
    
    fileprivate var section: [TrackDetail]?
    
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var dataSource: UICollectionViewDiffableDataSource<TrackDetail, TrackItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        section = NetworkManager.loadTrackDetail(filename: "AlbumDetail", id: albumId!)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.delegate = self
        
        // register items
        
        // Section Cells
        collectionView.register(TrackDetailStrip.self, forCellWithReuseIdentifier: TrackDetailStrip.reuseableIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: AlbumCollectionCell.reuseableIdentifier)
        collectionView.register(TrackRelatedArtistSEction.self, forCellWithReuseIdentifier: TrackRelatedArtistSEction.reuseableIdentifier)
//        collectionView.register(TrackImageHeader.self, forCellWithReuseIdentifier: TrackImageHeader.reuseableIdentifier)
        
        // Headers
        collectionView.register(TrackImageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackImageHeader.reuseableIdentifier)
        collectionView.register(TrackOverviewSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier)
        
        view.addSubview(collectionView)
        createDataSource()
        reloadData()

        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = abs(collectionView.contentOffset.y)
        print(contentOffsetY)
    }
    
    func configure<T: DetailCell>(_ cellType: T.Type, with trackItem: TrackItem, indexPath: IndexPath) -> T{
        print("Configureing cell")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseableIdentifier, for: indexPath) as? T else {
            fatalError("could not configure cell")
        }

        cell.configure(with: trackItem, indexPath: indexPath)
        return cell

    }
    
//    func configureItems<T: DetailItems>(_ cellType: T.Type, with trackItems: [TrackItem], indexPath: IndexPath) -> T {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseableIdentifier, for: indexPath) as? T else {
//            fatalError("could not configure cell")
//        }
//
//        cell.configure(items: trackItems, indexPath: indexPath)
//        return cell
//    }
    
    // Create Datasource
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TrackDetail, TrackItem> (collectionView: collectionView) {
            collectionview, IndexPath, item in
            
                switch self.section![IndexPath.section].type {
                case "Tracks":
                    return self.configure(TrackDetailStrip.self, with: item, indexPath: IndexPath)
                case "Artists":
                    return self.configure(TrackRelatedArtistSEction.self, with: item, indexPath: IndexPath)
                default:
                    return self.configure(AlbumCollectionCell.self, with: item, indexPath: IndexPath)
                }
        }

        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, IndexPath in
            
            
            guard let firstSEction = self?.dataSource?.itemIdentifier(for: IndexPath) else {return nil}
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstSEction) else {return nil}

       
            if section.imageURL!.isEmpty {

                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackOverviewSectionHeader.reuseableIdentifier, for: IndexPath) as? TrackOverviewSectionHeader else {return nil}

                sectionHeader.tagline.text = section.tagline
                sectionHeader.title.text = section.type

                return sectionHeader
            }else{
                guard let imageHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackImageHeader.reuseableIdentifier, for: IndexPath) as? TrackImageHeader else {
                    return nil
                }
                
                imageHeader.albumImage.image = UIImage(named: section.imageURL!)

                imageHeader.title.text = section.title
                imageHeader.artist.text = section.artist
                imageHeader.pageTag.text = section.type
                imageHeader.artistAviImage.image = UIImage(named: section.artistImgURL!)
                

                return imageHeader

            }
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
            case "Tracks":
                return LayoutManager.createTableLayout(using: section)
            case "Artists":
                return LayoutManager.createAviSliderSection(using: section)
            default:
                print("configureing header detail")
                return LayoutManager.createMediumImageSliderSection(using: section)
            }
        }

        return compositionalLayout
    }
   
}
