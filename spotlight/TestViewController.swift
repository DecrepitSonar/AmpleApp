//
//  TestViewController.swift
//  spotlight
//
//  Created by Robert Aubow on 6/18/21.
//

import UIKit

class TestViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Add()
        
    }
    func Add(){
//        view.addSubview(Albums)
//        Albums.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
    }

    override func viewDidLayoutSubviews() {
    
    }

    let container: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: 365).isActive = true
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
}
