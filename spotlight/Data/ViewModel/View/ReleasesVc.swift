//
//  ReleasesVc.swift
//  spotlight
//
//  Created by Robert Aubow on 7/1/21.
//

import UIKit

class ReleasesVc: UIViewController{
    let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 0.5)
        
//        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
}

//extension ReleasesVc: UICollectionViewDataSource, UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}
