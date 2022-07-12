////
////  VideoViewController.swift
////  spotlight
////
////  Created by bajo on 2021-12-11.
////
//
//import UIKit
//class VideoLibraryViewController: UIViewController {
//
////    var section = NetworkManager.readJSONFromFile(fileName: "catalog")!
//    var section = [VideoSectionModel]()
//    var datasource: UICollectionViewDiffableDataSource<VideoSectionModel, VideoItemModel>?
//    var collectionView: UICollectionView!
//    let user = UserDefaults.standard.value(forKey: "user")
//    
//    override func loadView() {
//        super.loadView()
//        title = "Video"
//        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//    }
//    
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        
//        NetworkManager.Get(url: "videos?user=\(user!)") { (data: [VideoSectionModel]?, error: NetworkError) in
//            switch(error){
//            case .success:
//                self.section = data!
//                
//                DispatchQueue.main.async {
//                    self.initCollectionView()
//                }
//
//            case .notfound:
//                print("not found")
//                
//            case .servererr:
//                print("Internal Server /err")
//            }
//        }
//        
//    }
//    
//    func initCollectionView(){
//        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        
//        view.addSubview(collectionView)
//        
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
//
//        // register cells
////        collectionView.register(SectionHeaderWithButton.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier)
////        collectionView.register(SmallVideoPoster.self, forCellWithReuseIdentifier: SmallVideoPoster.reuseIdentifier)
//
////        collectionView.register(FeaturedVideoHeader.self, forCellWithReuseIdentifier: FeaturedVideoHeader.reuseIdentifier)
//        
//        createDataSource()
//        reloadData()
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 190, right: 0)
//
//    }
//    
//    func createDataSource(){
//        
//        datasource = UICollectionViewDiffableDataSource<VideoSectionModel, VideoItemModel>(collectionView: collectionView) { collectionView, IndexPath, item in
////
//            switch self.section[IndexPath.section].type {
//            case "featured":
//                
//                return LayoutManager.configureVideoCell(collectionView: self.collectionView,
//                                                   navigationController: self.navigationController,
//                                                   FeaturedVideoHeader.self,
//                                                   with: item,
//                                                   indexPath: IndexPath)
//            default:
//                return LayoutManager.configureVideoCell(collectionView: self.collectionView,
//                                                   navigationController: self.navigationController,
//                                                   SmallVideoPoster.self,
//                                                   with: item,
//                                                   indexPath: IndexPath)
//            
//            }
//        }
//        
//        datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, IndexPath in
//            
//            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else {
//                print("fist App returned nil")
//                return nil}
//            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil}
//            
//            if section.tagline.isEmpty{return nil}
//        
//            switch section.type{
//            case "featured":
//                
//                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
//                    print("could not dequeue supplementory view")
//                    return nil
//                }
//                
//                sectionHeader.tagline.text = section.tagline
//                sectionHeader.title.text = section.type
//                
//                return sectionHeader
//                
//            default:
//                
//                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier, for: IndexPath) as? SectionHeaderWithButton else{
//                    print("could not dequeue supplementory view")
//                    return nil
//                }
//                
//                sectionHeader.tagline.text = section.tagline
//                sectionHeader.title.text = section.type
//                sectionHeader.navigationController = self!.navigationController
//                
//                return sectionHeader
//                
//            }
//            
//        }
//    }
//    
//    func reloadData(){
//        var snapshot = NSDiffableDataSourceSnapshot<VideoSectionModel, VideoItemModel>()
//        snapshot.appendSections(section)
//        
//        for section in section{
//            snapshot.appendItems(section.items, toSection: section)
//        }
//        
//        datasource?.apply(snapshot)
//    }
//    
//    func createCompositionalLayout() -> UICollectionViewLayout {
//
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//
//            let section = self.section[sectionIndex]
//
//            switch(section.type){
//            case "featured":
//                return LayoutManager.createFeaturedVideoHeader(using: section)
//            default:
//                return LayoutManager.createWideLayout(using: section)
//            }
//        }
//
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 20
//        layout.configuration = config
//        
//        return layout
//    }
//
//}
