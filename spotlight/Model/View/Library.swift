//
//  ProfileViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import UIKit

class Library: UIViewController {
    
    var section: [LibObject]!
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>!
    let user = UserDefaults.standard.object(forKey: "userId")
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        title = "Library"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.loadLibraryContent(id: user as! String) { result in
            switch(result){
            case .success(let data):
                print(data)
            case .failure(let err):
                print(err)
            }
        }
//        initDataSource()
        
    }
    
    func initDataSource(){
        
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionView.register(TrendingSection.self, forCellWithReuseIdentifier: TrendingSection.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
    }
    
    func createDataSource(){
        
        
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem>(collectionView: collectionView) { collectionView, IndexPath, item in
            
            switch self.section[IndexPath.section].type {
                
            case "Artists":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   ArtistSection.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "History":

                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   TrendingSection.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "Saved Tracks":

                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   TrendingSection.self,
                                                   with: item,
                                                   indexPath: IndexPath)
            default:

                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   MediumImageSlider.self,
                                                   with: item,
                                                   indexPath: IndexPath)
            }
        }
        
        datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, IndexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
                print("could not dequeue supplementory view")
                return nil
            }
            
            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else { return nil}
            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil}
            
            if section.tagline!.isEmpty{return nil}
        
            sectionHeader.tagline.text = section.tagline
            sectionHeader.title.text = section.type
            
            return sectionHeader
        }
        
    
    }
    
    func reloadData(){
        
        var snapshot = NSDiffableDataSourceSnapshot<LibObject, LibItem>()
        snapshot.appendSections(section)
        
        for section in section{
            snapshot.appendItems(section.items!, toSection: section)
        }
        
        datasource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let section = self.section[sectionIndex]

            switch(section.type){
                
                case "Artists":
                    return LayoutManager.createAviSliderSection(using: section)
                    
                case "History":
                    return LayoutManager.createTrendingSection(using: section)
                    
                case "Saved Tracks":
                    return LayoutManager.createTrendingSection(using: section)
                    
                default:
                    return LayoutManager.createMediumImageSliderSection(using: self.section[sectionIndex])
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }

}



