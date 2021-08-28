//
//  UtilityFunctions.swift
//  spotlight
//
//  Created by Robert Aubow on 7/2/21.
//

import Foundation
import  UIKit

protocol SelfConfigureingCell {
    static var reuseIdentifier: String { get }
    func configure(with catalog: Catalog, rootVc: UINavigationController?)
}

protocol  DetailCell {
    static var reuseableIdentifier: String { get }
    func configure(with trackItem: TrackItem)
}
protocol PlayerConfiguration {
    static var reuseIdentifier: String { get }
    func configure(with player: Queue, rootVc: UINavigationController?)
}

class ImgGestureRecognizer: UITapGestureRecognizer{
    var albumId: String?
    var artist: String?
    var track: Song?
}

class LayoutManager {
    static func createFeaturedHeader(using: Any) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    
        let layoutItems = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItems.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.83), heightDimension: .estimated(285))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItems])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        print("configured header layout")
        return layoutSection
        
    }
    static func createAviSliderSection(using: Any) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    
        let layoutItems = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItems.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .estimated(120))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItems])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        
        print("configuredd artist section layout")
        return layoutSection
    }
    static func createTrendingSection(using: Any) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.20))
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
        items.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.35))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [items])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        print("configured layout for History Section")
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        
        return layoutSection
    }
    static func createMediumImageSliderSection(using: Any) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
        items.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.42), heightDimension: .fractionalHeight(0.26))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [items])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        print("configured layout for History Section")
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        
        return layoutSection
    }
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
      
        let supplementoryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layout, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return supplementoryItem
    }
    static func createPlayer(using: Player) -> NSCollectionLayoutSection {
        let items = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let itemSize = NSCollectionLayoutItem(layoutSize: items)
        
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupsize, subitems: [itemSize])

         let section = NSCollectionLayoutSection(group: layoutGroup)
        
        return section
    }
}
