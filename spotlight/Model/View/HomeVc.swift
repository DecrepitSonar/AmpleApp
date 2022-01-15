//
//  HomeVc.swift
//  spotlight
//
//  Created by bajo on 2021-11-29.
//

import UIKit
import Foundation

class HomeVc: UIViewController {

    var section: [LibObject]!
    
    var datasource: UICollectionViewDiffableDataSource<LibObject, LibItem>?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Home"
        
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
                                         
        NetworkManager.loadHomePageContent { result in
            switch( result ){
            case .success(let data ):
                
                let date = Date()
                print(date.formateDate(dateString: "2022-01-11T01:25:41.922Z"))
                
//                print( formattedDate)

                if(data.isEmpty){
                    self.setAsEmpty()
                }
                else{
                    self.section = data
                    self.initCollectionView()
                }
                
            case .failure(let err ):
                print(err)
            }
        }
    }
    
    func setAsEmpty(){
        
        let label = UILabel()
        label.text = "Your new here huh?"
        label.setFont(with: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    
    func initCollectionView(){
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(TrendingSection.self, forCellWithReuseIdentifier: TrendingSection.reuseIdentifier)
        collectionView.register(MediumImageSlider.self, forCellWithReuseIdentifier: MediumImageSlider.reuseIdentifier)
        
        createDataSource()
        reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
    }
    
    func createDataSource(){
        
        
        datasource = UICollectionViewDiffableDataSource<LibObject, LibItem>(collectionView: collectionView) { collectionView, IndexPath, item in
            print("creating datasource")
            switch self.section[IndexPath.section].type {
            case "History":
                print("Adding Featured Section")
                return LayoutManager.configureCell(collectionView: self.collectionView, navigationController: self.navigationController, TrendingSection.self, with: item, indexPath: IndexPath)
            default:
                print("Adding default section")
                return LayoutManager.configureCell(collectionView: self.collectionView, navigationController: self.navigationController, MediumImageSlider.self, with: item, indexPath: IndexPath)
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
            print("Creating compositinal layout")

            switch(section.type){
            case "History":
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

}

