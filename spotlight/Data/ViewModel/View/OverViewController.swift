//
//  OverViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 8/22/21.
//
import Foundation
import UIKit

class OverViewController: UIViewController, UICollectionViewDelegate {
    var albumId: String?
    
    fileprivate var section: [LibObject]?
    
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var dataSource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(albumId)
        NetworkManager.getAlbum(id: albumId!) { Result in
            switch Result {
            case .success(let data ):
                self.section = data
                print(data)
                self.initCollectionView()
                
            case .failure(_):
                print()
            }
        }
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)

    }
    
    func initCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.2)
        collectionView.delegate = self
        
        // register items
        collectionView.register(TrackDetailStrip.self, forCellWithReuseIdentifier: TrackDetailStrip.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)

        // Headers
        collectionView.register(DetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeader.reuseableIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        view.addSubview(collectionView)
        
        createDataSource()
        
        reloadData()
    }

    func setupGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.init(displayP3Red: 255 / 255, green: 227 / 255, blue: 77 / 255, alpha: 0.2).cgColor]
        gradientLayer.frame = view.frame
        gradientLayer.locations = [0.0,0.5]
        
        collectionView.layer.addSublayer(gradientLayer)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = abs(collectionView.contentOffset.y)
        print(contentOffsetY)
    }
    
 
    
    // Create Datasource
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<LibObject, LibItem> (collectionView: collectionView) {
            collectionview, IndexPath, item in
            return LayoutManager.configureCell(collectionView: collectionview, navigationController: self.navigationController, TrackDetailStrip.self, with: item, indexPath: IndexPath)
//
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
                
                header.image.image = UIImage(named: section.imageURL!)

                header.title.text = section.title
                header.artist.text = section.name
                header.pageTag.text = section.type
                header.artistAviImage.image = UIImage(named: section.artistImgURL!)
                header.artistId = section.artistId!
                header.vc = self?.navigationController
                header.datePublished.text = "\(section.items!.count) Tracks, Published 2019, 45 minutes"
                
                
                
                for i in 0..<section.items!.count {
                    header.tracks.append(section.items![i].id)
                }
                
//                header.tracks = section.items as? Track
                return header

            }
        }
    }

    // initialize snapshot
    func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<LibObject, LibItem>()
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
            
//
//            let section = self.section![index]
//
//            switch section.type{
//            case "Tracks":
            return LayoutManager.createTableLayout(using: self.section ?? LibItem.self)
//            case "Artists":
//                return LayoutManager.createAviSliderSection(using: section)
//            default:
//                print("configureing header detail")
//                return LayoutManager.createMediumImageSliderSection(using: section)
//            }
        }

        return compositionalLayout
    }
   
}
