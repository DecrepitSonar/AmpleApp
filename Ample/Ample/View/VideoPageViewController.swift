//
//  VideoPageViewController.swift
//  Ample
//
//  Created by bajo on 2022-06-29.
//

import UIKit

class VideoPageViewController: UIViewController {

    var tableview: UITableView!
    var section: [LibObject]!
    let user = UserDefaults.standard.object(forKey: "user")
    var header = FeaturedVideoHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        navigationController?.hidesBarsOnSwipe = true
        title = "Videos"
        NetworkManager.Get(url: "videos?user=\("4f975b33-4c28-4af8-8fda-bc1a58e13e56")") { (data: [LibObject]?, error: NetworkError) in
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
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.frame
        tableview.separatorColor = .clear
        tableview.backgroundColor = .black
        tableview.register(LargeVideoHeaderCell.self, forCellReuseIdentifier: LargeVideoHeaderCell.reuseIdentifier)
        tableview.register(videoCollectionFlowCell.self, forCellReuseIdentifier: videoCollectionFlowCell.reuseIdentifier )
        tableview.register(ContentNavigatonSection.self, forCellReuseIdentifier: ContentNavigatonSection.reuseIdentifier)
        
//        tableview.tableHeaderView = header
        view.addSubview(tableview)
        
    }

}

extension VideoPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if( section == 0){
            header.configure(with: self.section[section].videos![section], navigationController: self.navigationController!)
            return header
        }
        
        let header = TableviewSectionHeader()
        if( section == 1 ){
            header.button.isHidden = true
        }
        if( section > 0 ){
            header.tagline.text = self.section[section].tagline
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if( section == 0 ){
            return 210
        }
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch( self.section[indexPath.section].type){
        case "featured":
            let cell = tableview.dequeueReusableCell(withIdentifier: LargeVideoHeaderCell.reuseIdentifier, for: indexPath) as! LargeVideoHeaderCell
            cell.delegate = header.self
            cell.initialize(data: section[indexPath.section], navigationController: self.navigationController!)
            return cell
            
        case "Genres":
            let cell = tableview.dequeueReusableCell(withIdentifier: ContentNavigatonSection.reuseIdentifier) as! ContentNavigatonSection
            cell.configureView(data: section[indexPath.section].items!)
            cell.navigationController = self.navigationController
            return cell
        default:
            let cell = tableview.dequeueReusableCell(withIdentifier: videoCollectionFlowCell.reuseIdentifier, for: indexPath) as! videoCollectionFlowCell
        
            cell.configure(data: section[indexPath.section].videos!, navigationController: self.navigationController!)
            return cell
        }
        
    }
    
    
}

class LargeVideoHeaderCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    static let reuseIdentifier: String  = "Featured Header Video"

    var data: LibObject!
    var nvc: UINavigationController!
    var delegate: VideoHeaderPlaybackDelegate!
    var collectionview: UICollectionView!
    
    let scrollContainer: UIScrollView = {
       let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    func initialize(data: LibObject, navigationController: UINavigationController){

        self.data = data
        self.nvc = navigationController
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 100)
        
        delegate.setTrack(video: data.videos![0])
        
        collectionview = UICollectionView(frame: contentView.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.register(MiniVideoCollection.self, forCellWithReuseIdentifier: MiniVideoCollection.reuseIdentifier)
        collectionview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionview.showsHorizontalScrollIndicator = false
    
        addSubview(collectionview)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),

            collectionview.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionview.topAnchor.constraint(equalTo: topAnchor),
            collectionview.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: MiniVideoCollection.reuseIdentifier, for: indexPath) as! MiniVideoCollection
        cell.configureView(data: data.videos![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return data.videos!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.setTrack(video: data.videos![indexPath.row])
        
        if indexPath.row > 0 && indexPath.row < data.videos!.count - 1{
            collectionview.setContentOffset(CGPoint(x: 210 * indexPath.row , y: 0), animated: true)
        }
        else if (indexPath.row == 0 ){
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class MiniVideoCollection: UICollectionViewCell{
    
    static let reuseIdentifier: String = "MiniVidScroll"
    var currentSelectedVideoId: VideoItemModel!
    
    func configureView(data: VideoItemModel){
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectVideo(sender:)), name: NSNotification.Name("videoSelected"), object: nil)
        
        currentSelectedVideoId = data
        
        addSubview(videoPoster)
        videoPoster.setUpImage(url: data.posterURL!, interactable: true)
        
        addSubview(playStatusContainer)
        playStatusContainer.addSubview(playButton)
        
        NSLayoutConstraint.activate([
        
            contentView.heightAnchor.constraint(equalToConstant: 100),
            
            videoPoster.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoPoster.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoPoster.bottomAnchor.constraint(equalTo: bottomAnchor),
            videoPoster.topAnchor.constraint(equalTo: topAnchor),

            playStatusContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            playStatusContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            playStatusContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            playStatusContainer.topAnchor.constraint(equalTo: topAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: playStatusContainer.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: playStatusContainer.centerYAnchor)
        ])
    }
    
    
    @objc func didSelectVideo(sender: Notification){
        print("notification sent ")
        if let userInfo = sender.userInfo {
            let data = userInfo as NSDictionary
            let selectedVideo = data.object(forKey: "video") as! VideoItemModel
            
            print( selectedVideo)
            
            if( selectedVideo.id == currentSelectedVideoId.id )  {
                DispatchQueue.main.async {
                    self.playStatusContainer.isHidden = false
                }
            }
            else{
                DispatchQueue.main.async {
                    self.playStatusContainer.isHidden = true
                }
            }
        }
        
        
    }
    
    let videoPoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    let playStatusContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 2
        view.isHidden = true
        return view
    }()
    
    let playButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        let image = UIImage.SymbolConfiguration(pointSize: 30)
        btn.setImage(UIImage(systemName: "pause.fill", withConfiguration: image), for: .normal)
        btn.layer.zPosition = 5
        return btn
    }()
}
