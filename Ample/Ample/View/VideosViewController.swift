//
//  VideosViewController.swift
//  Ample
//
//  Created by bajo on 2022-09-10.
//

import UIKit

class VideosViewController: UIViewController {

    var collectionView: UICollectionView!
    var diffableDataSource: UICollectionViewDiffableDataSource<LibObject, LibItem>!
    var sections: [LibObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Watch"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        
        NetworkManager.Get(url: "videos?user=\("4f975b33-4c28-4af8-8fda-bc1a58e13e56")") { (data: [LibObject]?, error: NetworkError) in
            switch(error){
            case .success:
                self.sections = data!
                
                DispatchQueue.main.async {
                    self.initCollection()
                }

            case .notfound:
                print("not found")
                
            case .servererr:
                print("Internal Server /err")
            }
        }
        
    }
    
    func initCollection(){
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(SectionHeaderWithButton.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderWithButton.reuseIdentifier)
        
        collectionView.register(VideoFeaturedHeader.self, forCellWithReuseIdentifier:  VideoFeaturedHeader.reuseIdentifier)
        collectionView.register(SmallVideoPoster.self, forCellWithReuseIdentifier:  SmallVideoPoster.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        
        configureDataSource()
        saveSnapShot()
        
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (index, layoutEnvironment ) -> NSCollectionLayoutSection? in
            
            let section = self.sections[index]
            
            switch( section.type){
            case "Featured":
                
                return LayoutManager.createFeaturedVideoHeader(using: section)
                
            default:
                return LayoutManager.createWideVideoLayout(using: section)
            }
            
        }
        
        return layout
        
    }
    
    func saveSnapShot(){
        
        var snapshot = NSDiffableDataSourceSnapshot<LibObject, LibItem>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items!, toSection: section)
        }
        
        diffableDataSource.apply(snapshot)
    }
    
    func configureDataSource(){
        
        diffableDataSource = UICollectionViewDiffableDataSource<LibObject, LibItem> (collectionView: collectionView){ collectionView, IndexPath, item in
            
            let sectionType = self.sections[IndexPath.section].type
            
            switch( sectionType){
                
            case "Featured":
                
                return LayoutManager.configureCell(collectionView: collectionView,
                                            navigationController: self.navigationController,
                                            VideoFeaturedHeader.self,
                                            with: item,
                                            indexPath: IndexPath)
                
            default:
               
                return LayoutManager.configureCell(collectionView: collectionView,
                                            navigationController: self.navigationController,
                                                   SmallVideoPoster.self,
                                            with: item,
                                            indexPath: IndexPath)
            }
        }
        
        diffableDataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, IndexPath in
            
            var sectionHeader: UICollectionReusableView!
            
            guard let firstSection = self?.diffableDataSource?.itemIdentifier(for: IndexPath) else {return nil}
            
            guard let section = self?.diffableDataSource?.snapshot().sectionIdentifier(containingItem: firstSection) else { return nil}
            
            if section.tagline!.isEmpty{
                return nil}
            
            switch( section.type){
            case "Featured":
                
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: IndexPath) as? SectionHeader else{
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

}

class VideoFeaturedHeader: UICollectionViewCell, Cell{

    static var reuseIdentifier: String = "Videos Featured Header"
    var tapGesture = CustomGestureRecognizer()
    var NavVc: UINavigationController?
    let blurrEffect = UIBlurEffect(style: .light)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        
        let visualEffect = UIVisualEffectView(effect: blurrEffect)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        
        let seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = .tertiaryLabel
        
        let labelStack = UIStackView(arrangedSubviews: [type, tagline, subTitle])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 2
        
        let stackview = UIStackView(arrangedSubviews: [ seperator,labelStack, image ])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = 10
        
        tapGesture = CustomGestureRecognizer(target: self, action: #selector(didTap(_sender:)))
        
        contentView.addSubview(stackview )
//        container.addGestureRecognizer(tapGesture)
//        contentView.addSubview(container)

//        container.addSubview(featuredTrackImage)
//        container.addSubview(artistName)
        addSubview(itemContainer)
//
//        let itemGroupLabelContainer = UIStackView(arrangedSubviews: [title, artistName])
//        itemGroupLabelContainer.axis = .vertical
//        itemGroupLabelContainer.distribution = .fillEqually
//
//        title.text = "Song title"
//        artistName.text = "Artist"
//
//        let itemGroupContainer = UIStackView(arrangedSubviews: [featuredTrackImage, itemGroupLabelContainer])
//        itemGroupContainer.translatesAutoresizingMaskIntoConstraints = false
//        itemGroupContainer.axis = .horizontal
//        itemGroupContainer.spacing = 20
//        itemContainer.clipsToBounds = true
//        itemContainer.addSubview(visualEffect)
//        itemContainer.addSubview(itemGroupContainer)
//
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            image.heightAnchor.constraint(equalToConstant: 200),
            
//            itemContainer.heightAnchor.constraint(equalToConstant: 90),
//            itemContainer.widthAnchor.constraint(equalToConstant: bounds.width),
//            itemContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
//
//            itemGroupContainer.leadingAnchor.constraint(equalTo: itemContainer.leadingAnchor, constant: 20),
//            itemGroupContainer.trailingAnchor.constraint(equalTo: itemContainer.trailingAnchor, constant: -20),
//            itemGroupContainer.topAnchor.constraint(equalTo: itemContainer.topAnchor, constant: 20),
//            itemGroupContainer.bottomAnchor.constraint(equalTo: itemContainer.bottomAnchor, constant: -20),
//
//            visualEffect.leadingAnchor.constraint(equalTo: itemContainer.leadingAnchor),
//            visualEffect.trailingAnchor.constraint(equalTo: itemContainer.trailingAnchor),
//            visualEffect.topAnchor.constraint(equalTo: itemContainer.topAnchor),
//            visualEffect.bottomAnchor.constraint(equalTo: itemContainer.bottomAnchor),
//
//            featuredTrackImage.heightAnchor.constraint(equalToConstant: 50),
//            featuredTrackImage.widthAnchor.constraint(equalToConstant: 50),
            
            seperator.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            seperator.heightAnchor.constraint(equalToConstant: 0.5)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?) {
        
        print(catalog)
        self.NavVc = rootVc
        image.setUpImage(url: catalog.imageURL!, interactable: true)
//        featuredTrackImage.setUpImage(url: catalog.imageURL!, interactable: true)
        tapGesture.id = catalog.id

        type.text = catalog.type
        tagline.text = catalog.title
    }
    
    func didTap(_sender: CustomGestureRecognizer) {
        let view = AlbumViewController()
        view.albumId = _sender.id!
        
        print("presenting...")
        NavVc!.title = "Featured"
        NavVc!.pushViewController(view, animated: true)
        
    }
    
    let tagline: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 20)
        return label
    }()
    let image: UIImageView = {
        
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 5
        
        return image
    }()

    let container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.textColor = .purple
        label.setFont(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 17)
        label.text = "Checkout this new thign that just dropped"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let artistName: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.setFont(with: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.setFont(with: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let featuredTrackImage: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 2
        return view
    }()
    let itemContainer: UIView = {
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    
}
