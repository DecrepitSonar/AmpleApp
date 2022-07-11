//
//  testViewController.swift
//  Ample
//
//  Created by bajo on 2022-07-08.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let segment = UISegmentedControl(items: ["Music", "Video", "Podcast"])
        segment.sizeToFit()
        if #available(iOS 13.0, *) {
           segment.selectedSegmentTintColor = UIColor.red
        } else {
          segment.tintColor = UIColor.red
        }
        segment.selectedSegmentIndex = 0
        
        navigationController?.navigationItem.titleView = segment
    }
    
    let navigationbarView: UIView = {
        let viewBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        viewBar.backgroundColor = .red
        return viewBar
    }()
}
