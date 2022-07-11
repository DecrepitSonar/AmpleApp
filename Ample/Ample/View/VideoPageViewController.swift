//
//  VideoPageViewController.swift
//  Ample
//
//  Created by bajo on 2022-06-29.
//

import UIKit

class VideoPageViewController: UIViewController {

    var tableview: UITableView!
    var section: [VideoSectionModel]!
    let user = UserDefaults.standard.object(forKey: "user")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = true
        
        NetworkManager.Get(url: "videos?user=\("4f975b33-4c28-4af8-8fda-bc1a58e13e56")") { (data: [VideoSectionModel]?, error: NetworkError) in
            switch(error){
            case .success:
                self.section = data!
                
                DispatchQueue.main.async {
                    self.initCollectionView()
                }

            case .notfound:
                print("not found")
                
            case .servererr:
                print("Internal Server /err")
            }
        }
        
    }
    
    func initCollectionView(){
        
        tableview = UITableView(frame: .zero, style: .grouped)
        tableview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.frame
        tableview.separatorColor = .clear
        
        tableview.register(LargeVideoHeaderCell.self, forCellReuseIdentifier: LargeVideoHeaderCell.reuseIdentifier)
        tableview.register(videoCollectionFlowCell.self, forCellReuseIdentifier: videoCollectionFlowCell.reuseIdentifier )
        
        view.addSubview(tableview)
        
    }
    
}

extension VideoPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if( section > 0 ){
            let header = TableviewSectionHeader()
            
            header.tagline.text = self.section[section].tagline
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch( self.section[indexPath.section].type){
        case "featured":
            let cell = tableview.dequeueReusableCell(withIdentifier: LargeVideoHeaderCell.reuseIdentifier, for: indexPath) as! LargeVideoHeaderCell
            cell.initialize(data: section[indexPath.section], navigationController: self.navigationController!)
            
            return cell
            
        default:
            let cell = tableview.dequeueReusableCell(withIdentifier: videoCollectionFlowCell.reuseIdentifier, for: indexPath) as! videoCollectionFlowCell
            cell.configure(data: section[indexPath.section].items, navigationController: self.navigationController!)
            return cell
        }
        
    }
    
    
}

class LargeVideoHeaderCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let reuseIdentifier: String  = "Featured Header Video"

    var data: VideoSectionModel!
    var nvc: UINavigationController!
    
    var collectionview: UICollectionView!
    
    let scrollContainer: UIScrollView = {
       let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    
    func initialize(data: VideoSectionModel, navigationController: UINavigationController){

        self.data = data
        self.nvc = navigationController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: frame.width, height: 200)
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(FeaturedVideoHeader.self, forCellWithReuseIdentifier: FeaturedVideoHeader.reuseIdentifier)
        collectionview.backgroundColor = UIColor.init(displayP3Red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
    
        addSubview(collectionview)
        
        NSLayoutConstraint.activate([

            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: FeaturedVideoHeader.reuseIdentifier, for: indexPath) as! FeaturedVideoHeader
    
        cell.configure(with: data.items[indexPath.row], navigationController: nvc)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data.items.count
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


class EmbededVideoPlayer: UICollectionViewCell {
    
    static let reuseIdentifier: String = "EmbededVideoPlayer"
    
    let image: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func configure(data: VideoItemModel){
        
        addSubview(image)
        image.frame = bounds
//        image.backgroundColor = .red
        image.setUpImage(url: data.posterURL!, interactable: false)
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
