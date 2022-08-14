//
//  ErrorViewController.swift
//  Ample
//
//  Created by bajo on 2022-08-07.
//

import UIKit

class ErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.setFont(with: 15)
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

}
