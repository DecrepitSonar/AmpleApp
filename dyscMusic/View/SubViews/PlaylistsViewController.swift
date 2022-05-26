//
//  PlaylistsViewController.swift
//  dyscMusic
//
//  Created by bajo on 2022-04-04.
//

import UIKit

class PlaylistsViewController: UIViewController {
    let user = UserDefaults.standard.value(forKey: "user")!
    var playlists = [Playlist]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        
        title = "Saved Playlists"
        NetworkManager.Get(url: "user/playlist?user=\(user)") { (data: [Playlist]?, result: NetworkError) in
            switch(result){
            case .success:
                self.playlists = data!
            case .notfound:
                print( "url not found")
            case .servererr:
                print("internal server error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PlayListCell.self, forCellWithReuseIdentifier: PlayListCell.reuseIdentifier)
        view.addSubview(collectionView)
        
        
    }

    
}

extension PlaylistsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayListCell.reuseIdentifier, for: indexPath) as? PlayListCell
        cell!.image.setUpImage(url: playlists[indexPath.row].imageURL, interactable: true)
        cell!.label.text = playlists[indexPath.row].title
        
        return cell!
    }
}
