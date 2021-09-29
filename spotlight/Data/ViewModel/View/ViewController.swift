//
//  ViewController.swift
//  compositionalLayout
//
//  Created by Robert Aubow on 8/13/21.
//

import UIKit
import Combine

class RVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

class ViewController: UIViewController, UISearchResultsUpdating {

//    var section = NetworkManager.readJSONFromFile(fileName: "catalog")!
    var section = [LibObject]()
    
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NetworkManager.loadHomeContent { result in
            switch(result){
            case .success(let data):
                print(data)
                self.section = data
                self.initCollectionView()
            case .failure(let error):
                print(error)
            }
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Browes"
        
        let searchController = UISearchController(searchResultsController: RVC())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        
    }
    
    func initCollectionView(){
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(FeaturedHeader.self, forCellWithReuseIdentifier: FeaturedHeader.reuseIdentifier)
        collectionView.register(ArtistSection.self, forCellWithReuseIdentifier: ArtistSection.reuseIdentifier)
        collectionView.register(TrendingSection.self, forCellWithReuseIdentifier: TrendingSection.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        
        createDataSource()
        reloadData()
    }
    
    func createDataSource(){
        
        
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem>(collectionView: collectionView) { collectionView, IndexPath, Catalog in
            print("creating datasource")
            switch self.section[IndexPath.section].type {
            case "Featured":
                print("Adding Featured Section")
                return self.configure(FeaturedHeader.self, with: Catalog, indexPath: IndexPath)
            case "Artists":
                print("Adding Artist section")
                return self.configure(ArtistSection.self, with: Catalog, indexPath: IndexPath)
            case "Trending":
                print("Adding Trending section")
                return self.configure(TrendingSection.self, with: Catalog, indexPath: IndexPath)
            default:
                print("Adding default section")
                return self.configure(MediumImageSlider.self, with: Catalog, indexPath: IndexPath)
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
    
    func configure<T: SelfConfigureingCell>(_ celltype: T.Type, with catalog: LibItem, indexPath: IndexPath) -> T{
        print("configuring cells")
        print("configuring cell with retrieved section data")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: celltype.reuseIdentifier, for: indexPath) as? T else {
            fatalError("unable to dequeu cell type \(celltype)")
        }
        
        print("no Errors in cell configuration")
        cell.configure(with: catalog, rootVc: self.navigationController!, indexPath: Int(indexPath.row))
        return cell
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
            print("Creating compositinal layout")

            switch(section.type){
            case "Featured":
                print("configuring featured section layout")
                return LayoutManager.createFeaturedHeader(using: section)
            case "Artists":
                print("configuring aritst layout")
                return LayoutManager.createAviSliderSection(using: section)
            case "Trending":
                print("configuring trending section layout")
                return LayoutManager.createTrendingSection(using: section)
            default:
                print("configuring mediumSection header layout")
            return LayoutManager.createMediumImageSliderSection(using: self.section[sectionIndex])
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        let vc = searchController.searchResultsController as? RVC
        vc?.view.backgroundColor = .systemRed
        print(text)
    }
}
enum NetworkErr: Error{
    case ServerError
    case ResponseError
}
