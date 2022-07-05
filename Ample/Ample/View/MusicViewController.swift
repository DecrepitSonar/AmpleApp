//
//  ViewController.swift
//  compositionalLayout
//
//  Created by Robert Aubow on 8/13/21.
//

import UIKit
import Combine

//class BrowserViewController: UIViewController {
//    
//    let pageScrollContainer: UIScrollView = {
//        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let container: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        view.backgroundColor = .red
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Browes"
//
//
//        let MusicViewController = V1()
//        let VideoViewController = V2()
//
//        pageScrollContainer.addSubview(MusicViewController.view!)
//        addChild(MusicViewController)
//        MusicViewController.view!.frame = view.frame
//        MusicViewController.didMove(toParent: self)
//
//        pageScrollContainer.addSubview(VideoViewController.view!)
//        addChild(VideoViewController)
//        VideoViewController.view!.frame = view.frame
//        VideoViewController.didMove(toParent: self)
//        view.addSubview(pageScrollContainer)
//
//        NSLayoutConstraint.activate([
//            pageScrollContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            pageScrollContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            pageScrollContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            pageScrollContainer.topAnchor.constraint(equalTo: view.topAnchor),
//
//            MusicViewController.view!.leadingAnchor.constraint(equalTo: pageScrollContainer.leadingAnchor),
//            MusicViewController.view!.topAnchor.constraint(equalTo: pageScrollContainer.topAnchor),
//            MusicViewController.view!.bottomAnchor.constraint(equalTo: pageScrollContainer.bottomAnchor),
//
//            VideoViewController.view!.leadingAnchor.constraint(equalTo: MusicViewController.view!.trailingAnchor),
//            VideoViewController.view!.topAnchor.constraint(equalTo: pageScrollContainer.topAnchor),
//            VideoViewController.view!.bottomAnchor.constraint(equalTo: pageScrollContainer.bottomAnchor)
//
//
//        ])
//
//    }
//
//    override func viewWillLayoutSubviews() {
//        pageScrollContainer.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height)
//    }
//
//    let navContainer: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
//        view.backgroundColor = .green
//        return view
//    }()
//
//}
//
//class V1: UIViewController{
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .orange
//    }
//}
//class V2: UIViewController{
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .yellow
//    }
//}


class MusicViewController: UIViewController, PlayerDelegate {

    var section = [LibObject]()
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    var collectionView: UICollectionView!
    let user = UserDefaults.standard.value(forKey: "user")!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        NetworkManager.Get(url: "home?user=\(user)") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .success:
//                print("success",data!)
                self.section = data!
                
                DispatchQueue.main.async {
                    self.initCollectionView()
                }

            case .notfound:
                print("not found")
                
            case .servererr:
                print("Internal Server /err")
            }
        }
        
    }
    
    func openPlayer(){
        let player = PlayerViewController()
//        print("opening player")
//
//        print("presenting player")
        player.modalPresentationStyle = .overFullScreen
        navigationController!.present(player, animated: true)

    }
    
    func initCollectionView(){
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(SectionHeaderWithButton.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier)
        
        collectionView.register(FeaturedHeader.self,
                                forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
        collectionView.register(TrackHistorySlider.self,
                                forCellWithReuseIdentifier: TrackHistorySlider.reuseIdentifier)
        collectionView.register(TrendingSection.self,
                                forCellWithReuseIdentifier: TrendingSection.reuseIdentifier)
        collectionView.register(MediumImageSlider.self,
                                forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        collectionView.register(LargeArtistAvi.self,
                                forCellWithReuseIdentifier: LargeArtistAvi.reuseIdentifier)
        
        createDataSource()
        reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 190, right: 0)
    }
    
    func createDataSource(){
        
        
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem>(collectionView: collectionView) { collectionView, IndexPath, item in

            switch self.section[IndexPath.section].type {
            case "Featured":
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   FeaturedHeader.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "Trending":
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   TrendingSection.self,
                                                   with: item,
                                                   indexPath: IndexPath)
            case "Artists":
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   LargeArtistAvi.self,
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
            
            
            guard let firstApp = self?.datasource?.itemIdentifier(for: IndexPath) else { return nil}
            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil}
            
            if section.tagline!.isEmpty{return nil}
        
            switch section.type{
            case "Trending":
                
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier, for: IndexPath) as? SectionHeaderWithButton else{
                    print("could not dequeue supplementory view")
                    return nil
                }
                
                sectionHeader.tagline.text = section.tagline
                sectionHeader.title.text = section.type
                sectionHeader.navigationController = self!.navigationController
                sectionHeader.vc = TrendingCollectionViewController()
                
                return sectionHeader
                
            case "History":
                
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier, for: IndexPath) as? SectionHeaderWithButton else{
                    print("could not dequeue supplementory view")
                    return nil
                }
                
                sectionHeader.tagline.text = section.tagline
                sectionHeader.title.text = section.type
                sectionHeader.navigationController = self!.navigationController
                sectionHeader.vc = TrendingCollectionViewController()
                
                return sectionHeader
            default:
                
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
                    print("could not dequeue supplementory view")
                    return nil
                }
                
                sectionHeader.tagline.text = section.tagline
                sectionHeader.title.text = section.type
                
                return sectionHeader
                
            }
            
        }
//
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
//            print("Creating compositinal layout")

            switch(section.type){
            case "Featured":
////                print("configuring featured section layout")
                return LayoutManager.createFeaturedHeader(using: section)
                
//            case "Artists":
////                print("configuring aritst layout")
//                return LayoutManager.createAviSliderSection(using: section)
            case "Trending":
//                print("configuring trending section layout")
                return LayoutManager.createTrendingSection(using: section)
            
            case "Releases":
                return LayoutManager.twoRowCollectionSlider(using: section)
                
            case "Artists":
                return LayoutManager.largeImageLayout(using: section)
                
//            case "":
//                return LayoutManager.createWideLayout(using: section)
            default:
//                print("configuring mediumSection header layout")
            return LayoutManager.createMediumImageSliderSection(using: self.section[sectionIndex])
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    

}
enum NetworkErr: Error{
    case ServerError
    case ResponseError
}
