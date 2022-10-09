//
//  TrendingCollectionViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-05-27.
//

import UIKit

class TrendingCollectionViewController: UIViewController {

    private var section: [LibObject]!
    private var collectionView: UICollectionView!
    private var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>!
    
    private var emptyView = EmptyContentViewController()
    private var errorView = ErrorViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Trending"
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        NetworkManager.Get(url: "trending") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .success:
                print("success",data!)
                
                self.section = data!
                
                if data!.isEmpty {
                    DispatchQueue.main.async {
                        self.addChild(self.emptyView)
                        self.view.addSubview(self.emptyView.view)
                        self.emptyView.label.text = "Looks like theres nothing in here yet"
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.loadCollectionView()
                    }
                }
               

            case .notfound:
                print("not found")
                
            case .servererr:
                DispatchQueue.main.async {
                    self.addChild(self.errorView)
                    self.view.addSubview(self.errorView.view)
                    self.errorView.label.text = "Oops. Ran into an error. Check your network"
                }
            }
        }
    }
    
    func loadCollectionView(){
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: compositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(SectionHeaderWithButton.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier)
        
        collectionView.register(TrackDetailStrip.self, forCellWithReuseIdentifier: TrackDetailStrip.reuseIdentifier)
        collectionView.register(SmallVideoPoster.self, forCellWithReuseIdentifier: SmallVideoPoster.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        collectionView.register(TrendingArtistAvi.self, forCellWithReuseIdentifier: TrendingArtistAvi.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
    }
    
    func compositionalLayout() -> UICollectionViewLayout{
        
        let layout = UICollectionViewCompositionalLayout { ( sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let section = self.section[sectionIndex]

            switch(section.type){
                
                case "Hot":
                    return LayoutManager.createTrendingSection(using: section)
                    
                case "Videos":
                    return LayoutManager.createWideVideoLayout(using: section)
                
                case "Artist":
                    return LayoutManager.largeArtistSection(using: section)
                
                default:
                    return LayoutManager.createMediumImageSliderSection(using: self.section[sectionIndex])
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
        
    }
    
    func createDataSource(){
        
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem>(collectionView: collectionView) { collectionView, IndexPath, item in
            
            switch self.section[IndexPath.section].type {
                
            case "Hot":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   TrackDetailStrip.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
                
            case "Videos":
                
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   SmallVideoPoster.self,
                                                   with: item,
                                                   indexPath: IndexPath)
            case "Artist":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   TrendingArtistAvi.self,
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
            
            var sectionHeader: UICollectionReusableView!
            
            guard let firstSection = self?.datasource?.itemIdentifier(for: IndexPath) else {
                print( "returned nil for first item", self?.section[IndexPath.section])
                return nil}
            
            guard let section = self?.datasource?.snapshot().sectionIdentifier(containingItem: firstSection) else { return nil}
            
            if section.tagline!.isEmpty{
                print("!!!!!!!!!!! section returned nil")
                return nil}
            
            switch( section.type){
            case "Featured":
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
                    print("could not dequeue supplementory view")
                    return nil
                }
                
                header.tagline.text = section.tagline
                header.title.text = section.type
                
                sectionHeader = header
                
            default:
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier, for: IndexPath) as? SectionHeaderWithButton else{
                    print("could not dequeue supplementory view")
                    return nil
                }
                
                header.tagline.text = section.tagline
                header.title.text = section.type
                header.navigationController = self!.navigationController
                
                header.vc = PlaylistsViewController()
                sectionHeader = header
                
            }
            
            return sectionHeader
        }
    
    }
    
    func reloadData(){
        var snapshot = NSDiffableDataSourceSnapshot<LibObject, LibItem>()
        snapshot.appendSections(section)
        
        for section in section {
            snapshot.appendItems(section.items!, toSection: section)
        }
        
        datasource?.apply(snapshot)
    }
    
}

class TrendingArtistAvi: UICollectionViewCell, Cell {
    
    static let reuseIdentifier: String = "Trendingartist"
    
    override init(frame: CGRect) {
        super.init( frame: frame )
        
        addSubview(artistImage)
        addSubview(conentOverlay)
        conentOverlay.addSubview(name)
        
        NSLayoutConstraint.activate([
            artistImage.heightAnchor.constraint(equalTo: heightAnchor),
            artistImage.widthAnchor.constraint(equalTo: widthAnchor),
            
            conentOverlay.heightAnchor.constraint(equalTo: artistImage.heightAnchor),
            conentOverlay.widthAnchor.constraint(equalTo: artistImage.widthAnchor),
            
            name.bottomAnchor.constraint(equalTo: conentOverlay.bottomAnchor, constant: -10),
            name.leadingAnchor.constraint(equalTo: conentOverlay.leadingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        artistImage.setUpImage(url: item.imageURL!, interactable: true)
        name.text = item.name
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
    
    let conentOverlay: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        _view.layer.cornerRadius = 5
        return _view
    }()
    
    let artistImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        
        return img
    }()
    
    let name: UILabel = {
        let _name = UILabel()
        _name.translatesAutoresizingMaskIntoConstraints = false
        _name.setBoldFont(with: 20)
        return _name
    }()
}
