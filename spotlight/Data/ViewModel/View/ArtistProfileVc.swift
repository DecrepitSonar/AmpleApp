////
////  ArtistProfileVc.swift
////  spotlight
////
////  Created by Robert Aubow on 7/1/21.
////
//
import UIKit

class Profile: UIViewController {
    var artistId: String?
//    let section = NetworkManager.readProfileData(filename: "profileData", id: "1")
    var section = [LibObject]()
    
    var collectionview: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getArtistsProfileData(artistId: artistId!) { result in
            switch( result) {
            case .success(let data):
                self.section = data
                self.initCollection(
                )
            case .failure(let err):
                print(err)
            }
        }
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        navigationController?.navigationBar.isHidden = true
        
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
    func initCollection(){
        collectionview = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout())
        collectionview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        // register cells
        collectionview.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
        collectionview.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        collectionview.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionview.register(ProfileHeader.self, forCellWithReuseIdentifier: ProfileHeader.reuseIdentifier)
        
        collectionview.contentInsetAdjustmentBehavior = .never
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        // Headers
        collectionview.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        view.addSubview( collectionview)
        
        createDataSource()
        reloadData()
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

            switch(section.type){
            case "Header":
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: self.navigationController, ProfileHeader.self, with: item, indexPath: indexPath)
            case "Tracks":
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: nil, CollectionCell.self, with: item, indexPath: indexPath)
            case "Artist":
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: self.navigationController, ArtistSection.self, with: item, indexPath: indexPath)
            default:
                return LayoutManager.configureCell(collectionView: self.collectionview, navigationController: self.navigationController, MediumImageSlider.self, with: item, indexPath: indexPath)
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
}
