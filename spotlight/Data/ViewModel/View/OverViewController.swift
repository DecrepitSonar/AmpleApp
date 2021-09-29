//
//  OverViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 8/22/21.
//

import UIKit

class OverViewController: UIViewController, UICollectionViewDelegate {
    var albumId: String?
    
    fileprivate var section: [AlbumDetail]?
    
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var dataSource: UICollectionViewDiffableDataSource<AlbumDetail, AlbumItems>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(albumId)
        NetworkManager.getAlbum(id: albumId!) { Result in
            switch Result {
            case .success(let data ):
                self.section = data
                print(data)
                self.initCollectionView()
                
            case .failure(let err):
                print()
            }
        }
    }
    
    func initCollectionView(){
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
        collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeader.reuseableIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        view.addSubview(collectionView)
        createDataSource()
        reloadData()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = abs(collectionView.contentOffset.y)
        print(contentOffsetY)
    }
    
    func configure<T: DetailCell>(_ cellType: T.Type, with trackItem: AlbumItems, indexPath: IndexPath) -> T{
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
        dataSource = UICollectionViewDiffableDataSource<AlbumDetail, AlbumItems> (collectionView: collectionView) {
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

       
            if section.imageURL == nil {

                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else {return nil}

                header.tagline.text = section.title
                header.title.text = section.type

                return header
            }else{
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeader.reuseableIdentifier, for: IndexPath) as? DetailHeader else {
                    return nil
                }
                
                header.albumImage.image = UIImage(named: section.imageURL!)

                header.title.text = section.title
                header.artist.text = section.title
                header.pageTag.text = section.type
                header.artistAviImage.image = UIImage(named: section.imageURL!)
                

                return header

            }
        }
    }

    // initialize snapshot
    func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<AlbumDetail, AlbumItems>()
        guard let section = section else { return }
        
        snapshot.appendSections(section)
        
        for section in section {
            snapshot.appendItems(section.items!, toSection: section)
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
