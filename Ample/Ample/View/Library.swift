//
//  ProfileViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 7/6/21.
//

import UIKit
import CoreData


class Library: UIViewController {
    
    var section: [LibObject]!
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>!
    
    let user = UserDefaults.standard.value(forKey: "user")
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
      
        title = "Library"
        
        NetworkManager.Get(url: "library?user=\(user!)") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .notfound:
                print("error url not found")
            
            case .servererr:
                print("Internal Server error")
                
            case .success:
                print(data!)
                self.section = data!
                
                DispatchQueue.main.async {
                    self.initDataSource()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard collectionView != nil else{
            return
        }
        loadView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initDataSource(){
        
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(SectionHeaderWithButton.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier)
        
        collectionView.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionView.register(SmallImageSlider.self, forCellWithReuseIdentifier: SmallImageSlider.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        collectionView.register(SmallVideoPoster.self, forCellWithReuseIdentifier: SmallVideoPoster.reuseIdentifier)
        
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
                
            case "Videos":

                return LayoutManager.configureCell(collectionView: collectionView,
                                                   navigationController: self.navigationController,
                                                   SmallVideoPoster.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "History":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   SmallImageSlider.self,
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
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier, for: IndexPath) as? SectionHeaderWithButton else{
                print("could not dequeue supplementory view")
                return nil
            }
            
            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else { return nil}
            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil}
            
            if section.tagline!.isEmpty{return nil}
        
            sectionHeader.tagline.text = section.tagline
            sectionHeader.title.text = section.type
            sectionHeader.navigationController = self!.navigationController
            
            switch( section.type){
            case "Artists":
                sectionHeader.vc = ArtistFollowViewController()
                
//            case "Track History":
//                sectionHeader.vc = SmallImageSlider()
                
            case "Saved Albums":
                sectionHeader.vc = CollectionViewController()
                
            default:
                break
            }
            
            return sectionHeader
        }
        
//        datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, IndexPath in
//            
//            guard let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooter.reuseIdentifier, for: IndexPath) as? SectionFooter else{
//                print("could not dequeue supplementory view")
//                return nil
//            }
//            
//            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else { return nil}
//            guard (self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp)) != nil else { return nil}
//            
//            return sectionFooter
//        }
        
    
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
            
                case "Videos":
                    return LayoutManager.createWideVideoLayout(using: section)
            
                
                case "History":
                    return LayoutManager.smallSliderSection(using: section)
                
                default:
                    return LayoutManager.createMediumImageSliderSection(using: section)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }

}



