//
//  ViewController.swift
//  compositionalLayout
//
//  Created by Robert Aubow on 8/13/21.
//

import UIKit
import Combine

class MusicViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    var section = NetworkManager.readJSONFromFile(fileName: "catalog")!
    var section = [LibObject]()
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openPlayer), name: NSNotification.Name("player"), object: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Browse"
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(self, selector: #selector(openQueue), name: NSNotification.Name("queue"), object: nil)
        let user = UserDefaults.standard.object(forKey: "userId") as! String
        
        NetworkManager.loadHomePageContent(userId: user ) { result in
            switch(result){
            case .success(let data):
                print(data)
                self.section = data
                self.initCollectionView()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @objc func openPlayer(sender: Notification){
        let player = PlayerViewController()
        print("opening player")
           
        print("presenting player")
        player.modalPresentationStyle = .overFullScreen
        navigationController!.present(player, animated: true)

    }
    func initCollectionView(){
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(FeaturedHeader.self, forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
//        collectionView.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionView.register(TrackHistorySlider.self, forCellWithReuseIdentifier: TrackHistorySlider.reuseIdentifier)
        collectionView.register(TrendingSection.self, forCellWithReuseIdentifier: TrendingSection.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        
        createDataSource()
        reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
    }
    
    func createDataSource(){
        
        
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem>(collectionView: collectionView) { collectionView, IndexPath, item in
//            print("creating datasource")
            switch self.section[IndexPath.section].type {
            case "Featured":
////                print("Adding Featured Section")
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   FeaturedHeader.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "Trending":
//                print("Adding Trending section")
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   TrendingSection.self,
                                                   with: item,
                                                   indexPath: IndexPath)
            default:
//                print("Adding default section")
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
