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
    func configure(with catalog: LibItem, rootVc: UINavigationController?, indexPath: Int?)
}

protocol CellConfigurer {
    static var reuseIdentifier: String { get }
     func configure(item: LibItem)
}

protocol  DetailCell {
    static var reuseableIdentifier: String { get }
    func configure(with trackItem: TrackItem, indexPath: IndexPath?)
}
//
//protocol DetailItems {
//    static var reuseableIdentifier: String { get }
//    func configure(items: [TrackItem], indexPath: IndexPath?)
//}

protocol ProfileSectionConfigurer {
    static var reuseIdentifier: String { get }
    func configure(with item: ProfileItem)
}

protocol PlayerConfiguration {
    static var reuseIdentifier: String { get }
    func configure(with player: Queue, rootVc: UINavigationController?)
}

class ImgGestureRecognizer: UITapGestureRecognizer{
    var albumId: String?
    var artist: String?
    var track: Song?
    var id: String?
}

class LayoutManager {
    
    // Sections Layout
    static func createFeaturedHeader(using: Any) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    
        let layoutItems = NSCollectionLayoutItem(layoutSize: itemSize)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.83), heightDimension: .estimated(285))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItems])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        print("configured header layout")
        return layoutSection
        
    }
    static func createAviSliderSection(using: Any) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    
        let layoutItems = NSCollectionLayoutItem(layoutSize: itemSize)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .estimated(120))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItems])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        
        print("configuredd artist section layout")
        return layoutSection
    }
    static func createTrendingSection(using: Any) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.20))
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
        items.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 10)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.35))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [items])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        print("configured layout for collection Section")
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        
        return layoutSection
    }
    static func createMediumImageSliderSection(using: Any) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
//        items.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.42), heightDimension: .fractionalHeight(0.26))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [items])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        print("configured layout for History Section")
        
        let sectionheader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [sectionheader]
        
        return layoutSection
    }
    static func createTableLayout(using: Any) -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let items = NSCollectionLayoutItem(layoutSize: itemSize)
        items.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.07))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [items])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        print("configured layout for History Section")
        
        let sectionheaderImage = createAlbumHeader()
        layoutSection.boundarySupplementaryItems = [sectionheaderImage]
//
        return layoutSection
    }
    
    // Header Layout
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
      
        let supplementoryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layout, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return supplementoryItem
    }
    static func createAlbumHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let layout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.60))
        
        let supplementoyItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layout, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return supplementoyItem
    }
}
