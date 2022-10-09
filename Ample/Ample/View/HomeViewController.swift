//
//  HomeViewController.swift
//  Ample
//
//  Created by bajo on 2022-07-07.
//

import UIKit

class HomeViewController: UIViewController{
    
    private var section: [LibObject]!
    private var collectionView: UICollectionView!
    private var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>!
    
    private var emptyView = EmptyContentViewController()
    private var errorView = ErrorViewController()
    private let user = UserDefaults.standard.value(forKey: "user")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        navigationController?.navigationBar.tintColor = UIColor.init(red: 142 / 255, green: 5 / 255, blue: 194 / 255, alpha: 1)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        NetworkManager.Get(url: "home?user=\(user)") { (data: [LibObject]?, error: NetworkError) in
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func loadCollectionView(){
        
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
        
        collectionView.register(FeaturedHeader.self, forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
        collectionView.register(CatagoryCollectionCell.self, forCellWithReuseIdentifier: CatagoryCollectionCell.reuseIdentifier)
        collectionView.register(LargePlaylistCover.self, forCellWithReuseIdentifier: LargePlaylistCover.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        collectionView.register(SmallImageSlider.self, forCellWithReuseIdentifier: SmallImageSlider.reuseIdentifier)
        collectionView.register(PlayList.self, forCellWithReuseIdentifier: PlayList.reuseIdentifier)
        
        createDataSource()
        reloadData()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
        
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
            case "Browse":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   CatagoryCollectionCell.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "History":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   SmallImageSlider.self,
                                                   with: item,
                                                   indexPath: IndexPath)
                
            case "Playlists":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   LargePlaylistCover.self,
                                                   with: item,
                                                   indexPath: IndexPath)
            
                
            case "Mix":
                
                return LayoutManager.configureCell(collectionView: self.collectionView,
                                                   navigationController: self.navigationController,
                                                   PlayList.self,
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
            case "History":
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier, for: IndexPath) as? SectionHeaderWithButton else{
                    print("could not dequeue supplementory view")
                    return nil
                }

                header.tagline.text = section.tagline
                header.title.text = section.type
                header.navigationController = self!.navigationController
                header.vc = TrackHistoryViewController()
                
                sectionHeader = header
                
            default:
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
                    print("could not dequeue supplementory view")
                    return nil
                }
                
                header.tagline.text = section.tagline
                header.title.text = section.type
                
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
    
    func createCompositionalLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in

            let section = self.section[sectionIndex]

            switch(section.type){
                
                case "Featured":
                    return LayoutManager.createFeaturedHeader(using: section)
                    
                case "Browse":
                    return LayoutManager.createWideLayout(using: section)
                
                case "History":
                    return LayoutManager.smallSliderSection(using: section)
                
                case "Playlists":
                    return LayoutManager.createLargePlaylistSectonLayout(using: section)
                
//                case "Track History":
//                    return LayoutManager.createTrendingSection(using: section)
                    
//                case "Saved Tracks":
//                    return LayoutManager.createTrendingSection(using: section)
                    
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

class LargeSliderCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static var reuseIdentifier: String = "large slider"
    var collectionview: UICollectionView!
    var data: [LibItem] = []
    var navigationController: UINavigationController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func initCell(data: [LibItem]){
        
        self.data = data
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionview = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.isPagingEnabled = true 
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(FeaturedHeader.self, forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([
            
//            heightAnchor.constraint(equalToConstant: 200),
            
            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: FeaturedHeader.reuseIdentifier, for: indexPath) as! FeaturedHeader
        cell.configure(with: data[indexPath.row], rootVc: self.navigationController, indexPath: indexPath.row)
        return cell
    }
    
}

class ContentNavigatonSection: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
   
    static let reuseIdentifier: String = "contentNav"
    var collectionView: UICollectionView!
    var sections: [LibItem]!
    var navigationController: UINavigationController!
    
    func configureView(data: [LibItem]){
        
        sections = data
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 200, height: 80)
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout:  layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CatagoryCollectionCell.self, forCellWithReuseIdentifier: CatagoryCollectionCell.reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatagoryCollectionCell.reuseIdentifier , for: indexPath) as! CatagoryCollectionCell
//        cell.configure(catagory: sections[indexPath.row])
        cell.navigationController = navigationController
        return cell
        
    }
    
}
class CatagoryCollectionCell: UICollectionViewCell, Cell {
    
    static let reuseIdentifier: String = "catagoryCell"
    private var catagory: String = ""
    var navigationController: UINavigationController!
    private var tapRecognizer: UITapGestureRecognizer!
    
    let sectionLabel: UILabel = {
       let view = UILabel()
        view.setBoldFont(with: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        self.catagory = item.title!
        
        navigationController = rootVc
        
        backgroundColor = .red
        addSubview(backgroundImage)
        backgroundImage.image = UIImage(named: item.imageURL!)
        backgroundImage.isUserInteractionEnabled = true
        
        addSubview(sectionLabel)
        sectionLabel.text = item.title

        layer.cornerRadius = 5
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentCatagoryView))
        addGestureRecognizer(tapRecognizer)
        
        NSLayoutConstraint.activate([
            
            sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.topAnchor.constraint(equalTo: topAnchor)
            
        ])
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        
    }
    
    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    @objc func presentCatagoryView(){
        
        var _view: UIViewController!
        
        switch( catagory){
        case "Trending":
            _view = TrendingCollectionViewController()
            
        case "Videos":
            _view = VideosViewController()
        
        case "Trending Videos":
            _view = TrendingVideoViewController()
            
        default:
            return
        }
        
        navigationController.pushViewController(_view, animated: true )
        
    }
    
}

//func dynamicCell<T: UICollectionViewCell>(type: T, collectionview: UICollectionView, indexPath: IndexPath){
//    guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: type.reuseableidentifier, for: IndexPath) as! T
//    else{ return nil }
//
//}
