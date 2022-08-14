//
//  EmptyContentViewController.swift
//  Ample
//
//  Created by bajo on 2022-08-07.
//

import UIKit

class EmptyContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.text = "No Content yet"
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.setFont(with: 30)
        return label
    }()
    
}
