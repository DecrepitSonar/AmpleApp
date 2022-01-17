//
//  Protocols.swift
//  spotlight
//
//  Created by bajo on 2022-01-17.
//

import Foundation
import UIKit

protocol SelfConfigureingCell {
    static var reuseIdentifier: String { get }
    func configure(with item: LibItem, rootVc: UINavigationController?, indexPath: Int?)
}

@objc protocol GestureAction {
    @objc func didTap(_sender: CustomGestureRecognizer)
}

protocol Cell : SelfConfigureingCell & GestureAction {
    
}


protocol TableCell{
    static var reuseIdentifier: String { get }
    func configureWithSet(image: String, name: String, artist: String, type: String)
}
protocol PlayerConfiguration {
    static var reuseIdentifier: String { get }
    func configure(with player: Queue, rootVc: UINavigationController?)
}
