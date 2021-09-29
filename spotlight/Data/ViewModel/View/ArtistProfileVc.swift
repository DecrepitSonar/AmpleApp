////
////  ArtistProfileVc.swift
////  spotlight
////
////  Created by Robert Aubow on 7/1/21.
////
//
import UIKit

class Profile: UIViewController {
    
    let section = NetworkManager.readProfileData(filename: "profileData", id: "1")
    
    var collectionview: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout())
        collectionview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        // register cells
        collectionview.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        collectionview.register(LargeArtCollection.self, forCellWithReuseIdentifier: LargeArtCollection.reuseIdentifier)
        collectionview.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.reuseIdentifier)
        collectionview.register(ProfileHeader.self, forCellWithReuseIdentifier: ProfileHeader.reuseIdentifier)
        
        collectionview.contentInsetAdjustmentBehavior = .never
        collectionview.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
        
        // Headers
        collectionview.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        view.addSubview( collectionview)
        
        createDataSource()
        reloadData()
    }
    
    func compositionalLayout() -> UICollectionViewLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { IndexPath, layoutEnvironement in
            let section = self.section[IndexPath]
            
            switch(section.type){
            case "Header":
                return LayoutManager.createHeaderLayout(using: section)
            case "Artist":
                return LayoutManager.createAviSliderSection(using: section)
            case "Tracks":
                return LayoutManager.createSmallProfileTableLayout(using: section)
            default:
                return LayoutManager.createMediumImageSliderSection(using: section)
            }
        }
        
        return compositionalLayout
    }
    // create Data source snapshot
    func reloadData(){
          var snapshot = NSDiffableDataSourceSnapshot<LibObject , LibItem>()
        let section = self.section
  
          snapshot.appendSections(section)
  
          for section in section {
              snapshot.appendItems(section.items!, toSection: section)
          }
  
          datasource?.apply(snapshot)
      }
    
    // create data source
    func createDataSource() {
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem> (collectionView: collectionview, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let section = self.section[indexPath.section]
//            print(section.type)
            switch(section.type){
            case "Header":
                return self.configureCell(_cellType: ProfileHeader.self, with: item, indexPath: indexPath)
            case "Tracks":
                return self.configureCell(_cellType: CollectionCell.self, with: item, indexPath: indexPath)
            case "Artist":
                return self.configureCell(_cellType: ArtistCell.self, with: item, indexPath: indexPath)
            default:
                return self.configureCell(_cellType: LargeArtCollection.self, with: item, indexPath: indexPath)
            }
        })
        
        datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, IndexPath in
      
            
            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else { return nil}
            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil}
                
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
                print("could not dequeue supplementory view")
                return nil
            }
                
            sectionHeader.tagline.text = section.tagline
            sectionHeader.title.text = section.type
                
            return sectionHeader
                
        }
    }
    
    fileprivate func configureCell<T: CellConfigurer>(_cellType: T.Type, with item: LibItem, indexPath: IndexPath ) -> T {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
        cell?.configure(item: item, indexPath: indexPath.row )
            return cell!
    }
}
